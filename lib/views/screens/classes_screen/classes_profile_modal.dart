import 'dart:convert';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/class_profile_api_service.dart';
import '../../../utils/app_focus_helper.dart';


class ClassProfileModal {
  final int id;
  final String rollNumber;
  final String firstName;
  final String lastName;
  final String mobileNumber;

  const ClassProfileModal(
    this.id,
    this.rollNumber,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  );

  DataRow getRow(SelectedCallBack callback, List<String> selectedIds,
      OperationCallBack operation) {
    return DataRow(
      cells: [
        DataCell(Text(id.toString())),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () => {
              {operation(id.toString(), context, "DETAILS")}
            },
            child: Text(rollNumber),
          );
        })),
        DataCell(Text("$firstName $lastName")),

        // DataCell(Builder(builder: (context) {
        //   return Row(mainAxisSize: MainAxisSize.min, children: [
        //     SizedBox(
        //       height: 20.0,
        //       child: Padding(
        //         padding: const EdgeInsets.only(right: kDefaultPadding / 2),
        //         child: SizedBox(
        //           height: 20.0,
        //           child: IconButton(
        //             icon: const Icon(Icons.whatsapp),
        //             color: Colors.green,
        //             tooltip: 'Edit',
        //             onPressed: () => {
        //               {operation(id.toString(), context, "EDIT")}
        //             },
        //           ),
        //         ),
        //       ),
        //     ),
        //   ]);
        // })),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () => {
              {operation(id.toString(), context, "DETAILS")}
            },
            child: Text(mobileNumber),
          );
        })),
        // DataCell(Builder(
        //   builder: (context) {
        //     return Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         SizedBox(
        //           height: 20.0,
        //           child: Padding(
        //             padding: const EdgeInsets.only(right: kDefaultPadding / 2),
        //             child: SizedBox(
        //               height: 20.0,
        //               child:
        //               IconButton(
        //                 icon: const Icon(Icons.edit),
        //                 color: Colors.green,
        //                 tooltip: 'Edit',
        //                 onPressed: () => {
        //                   {operation(id.toString(), context, "EDIT")}
        //                 },
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(
        //           height: 25.0,
        //           child: Padding(
        //             padding: const EdgeInsets.only(right: kDefaultPadding / 2),
        //             child: SizedBox(
        //               height: 25.0,
        //               child: IconButton(
        //                 icon: const Icon(Icons.delete),
        //                 color: Colors.red,
        //                 tooltip: 'Delete',
        //                 onPressed: () => {
        //                   {operation(id.toString(), context, "DELETE")}
        //                 },
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     );
        //   },
        // )),
      ],
      onSelectChanged: (newState) {
        callback(id.toString(), newState ?? false);
      },
      selected: selectedIds.contains(id.toString()),
    );
  }

  factory ClassProfileModal.fromJson(Map<String, dynamic> json) {
    return ClassProfileModal(
        json['id'] != null ? json['id'] as int : 0,
        json['rollNumber'] != null ? json['rollNumber'] as String : "",
        json['firstName'] != null ? json['firstName'] as String : "",
        json['lastName'] != null ? json['lastName'] as String : "",
        json['mobileNumber'] != null ? json['mobileNumber'] as String : "");
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': rollNumber,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
    };
  }
}
typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);



class ExampleSource extends AdvancedDataTableSource<ClassProfileModal> {
  static List<String> selectedIds = [];
  String lastSearchTerm = '';
  String classId = '';
  ExampleSource(String id) {
    classId = id;
  }

  ApiService apiService = ApiService();
  final ClassProfileApiService _classStudentApiService = ClassProfileApiService();

  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds, doOperations);
  @override
  int get selectedRowCount => selectedIds.length;

  void selectedRow(
      String id,
      bool newSelectState,
      ) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void _doDelete(BuildContext context, id) {
    ApiService apiService = ApiService();
    AppFocusHelper.instance.requestUnfocus();
    final lang = Lang.of(context);
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO_REVERSED,
      title: lang.confirmDeleteRecord,
      width: kDialogWidth,
      btnOkText: lang.yes,
      btnOkOnPress: () {
        final d = AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          title: lang.recordDeletedSuccessfully,
          width: kDialogWidth,
          btnOkText: 'OK',
          btnOkOnPress: () {
            apiService.deleteRow(id).whenComplete(() => setNextView());
          },
        );
        d.show();
      },
      btnCancelText: lang.cancel,
      btnCancelOnPress: () {},
    );
    dialog.show();
  }

  Future<void> doOperations(
      String id, BuildContext context, String operationType) async {
    if (operationType == 'EDIT') {
      AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

      GoRouter.of(context).go('${RouteUri.form}?id=$id');
      // print('EDIT');
    }
    if (operationType == 'DETAILS') {
      GoRouter.of(context).go('${RouteUri.student}?id=$id');
    }
    if (operationType == 'DELETE') {
      // print('DELETE');
      _doDelete(context, id);
      // deleteConfirmationDialog(context, id);
    }
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  Future<RemoteDataSourceDetails<ClassProfileModal>> getNextPage(NextPageRequest pageRequest) async {
    try {
      final queryParameter = <String, dynamic>{
        'offset': pageRequest.offset.toString(),
        'pageSize': pageRequest.pageSize.toString(),
        'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
        'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
        if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
      };

      final response1 = await apiService.getStudentList(queryParameter);
      final response2 = await _classStudentApiService.getClassStudentById(classId);
      final data1 = jsonDecode(response1.body)['rows'];
      final data2 = jsonDecode(response2.body)['assignStudents'];
      Set<int> idsInData2 = Set.from(data2.map((item) => item["id"]));
      List<dynamic> result;
      if(data2.length>0){
        result = data1.where((item1) =>
        !idsInData2.contains(item1["id"])).toList();
      }else{
        result = data1;
      }

      var length = result.length;
      final List<ClassProfileModal> paginatedData = (result)
          .map((json) => ClassProfileModal.fromJson(json as Map<String, dynamic>))
          .toList();
      final List<ClassProfileModal> paginatedList = paginatedData
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList();
      return RemoteDataSourceDetails(
        int.parse(length.toString()),
        paginatedList,
        filteredRows: lastSearchTerm.isNotEmpty ? paginatedData.length : null,
      );

    } catch (e) {
      // Handle exceptions or errors here
      print("Error in getNextPage: $e");
      return RemoteDataSourceDetails(0, []);
    }
  }

}