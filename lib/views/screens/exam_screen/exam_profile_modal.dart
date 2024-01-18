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
import '../../../services/exam_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../utils/app_focus_helper.dart';
import '../exam_screen/exam_screen.dart';

class ExamProfileModal {
  final int id;
  final String subjectName;
  final String subjectType;
  final int minimumNumber;
  final int maximumNumber;

  const ExamProfileModal(
      this.id,
      this.subjectName,
      this.subjectType,
      this.minimumNumber,
      this.maximumNumber,
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
            child: Text(subjectName),
          );
        })),
        DataCell(Text(subjectType)),

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
            child: Text(minimumNumber.toString()),
          );
        })),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () => {
              {operation(id.toString(), context, "DETAILS")}
            },
            child: Text(maximumNumber.toString()),
          );
        })),

      ],
      onSelectChanged: (newState) {
        callback(id.toString(), newState ?? false);
      },
      selected: selectedIds.contains(id.toString()),
    );
  }

  factory ExamProfileModal.fromJson(Map<String, dynamic> json) {
    return ExamProfileModal(
        json['id'] != null ? json['id'] as int : 0,
        json['name'] != null ? json['name'] as String : "",
        json['subjectType'] != null ? json['subjectType'] as String : "",
        json['minPassingMarks'] != null ? json['minPassingMarks'] as int : 0,
        json['maxMarks'] != null ? json['maxMarks'] as int : 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': subjectName,
      'subjectType': subjectType,
      'minPassingMarks': minimumNumber,
      'maxMarks': maximumNumber,
    };
  }
}

typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);

class ExampleSource extends AdvancedDataTableSource<ExamProfileModal> {
  static List<String> selectedIds = [];
  String lastSearchTerm = '';
  String examId = '';
  ExampleSource(String id) {
    examId = id;
  }


  final ExamApiService examApiService = ExamApiService();
  final SubjectApiService apiService = SubjectApiService();

  SubjectApiService apiService2 = SubjectApiService();


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

  @override
  Future<RemoteDataSourceDetails<ExamProfileModal>> getNextPage(NextPageRequest pageRequest) async {
    try {
      // final queryParameter = <String, dynamic>{
      //   'offset': pageRequest.offset.toString(),
      //   'pageSize': pageRequest.pageSize.toString(),
      //   'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      //   'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      //   if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
      // };
      var response = await examApiService.getExamById(examId);
      var response2 = await apiService.getSubjectList();
      final data = jsonDecode(response.body).cast<String, dynamic>();
      final data1 = jsonDecode(response2.body)["rows"];
      List<Map<String, dynamic>> data2 = (data['examSubjectDetails'] as List)
          .map((item) => (item['subject'] as Map<String, dynamic>).cast<String, dynamic>())
          .toList();
      Set<int> idsInData2 = Set.from(data2.map((item) => item["id"]));
      List<dynamic> result = data1.where((item1) => !idsInData2.contains(item1["id"])).toList();
      var length = result.length;
      final List<ExamProfileModal> paginatedData = result
          .map((json) => ExamProfileModal.fromJson(json))
          .toList();
      final List<ExamProfileModal> paginatedList = paginatedData
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