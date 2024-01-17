import 'dart:convert';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/class_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../utils/app_focus_helper.dart';
import '../exam_screen/exam_profile.dart';


class subjectClassModal {
  final int id;
  final String name;
  final String subjectType;
  final int maxMarks;
  final int minPassingMarks;

  const subjectClassModal(
      this.id,
      this.name,
      this.subjectType,
      this.maxMarks,
      this.minPassingMarks,
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
            child: Text(name),
          );
        })),
        DataCell(Text(subjectType)),
        DataCell(Text(minPassingMarks.toString())),
        DataCell(Text(maxMarks.toString())),
      ],
      onSelectChanged: (newState) {
        callback(id.toString(), newState ?? false);
      },
      selected: selectedIds.contains(id.toString()),
    );
  }

  factory subjectClassModal.fromJson(Map<String, dynamic> json) {
    return subjectClassModal(
        json['id'] as int,
        json['name'] != null ? json['name'] as String : "",
        json['subjectType'] != null ? json['subjectType'] as String : "",
        json["minPassingMarks"]!= null ? json['minPassingMarks'] as int : 0,
        json["maxMarks"]!= null ? json['maxMarks'] as int : 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjectType': subjectType,
      "minPassingMarks": minPassingMarks,
      "maxMarks": maxMarks
    };
  }
}
typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);

class ExampleSource2 extends AdvancedDataTableSource<subjectClassModal> {
  static List<String> selectedIds2 = [];
  String lastSearchTerm = '';
  String classId = '';
  ExampleSource2(String id) {
    classId = id;
  }
  final storage = const FlutterSecureStorage();
  final SubjectApiService apiService = SubjectApiService();
  final ClassApiService apiClassService = ClassApiService();
  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds2, doOperations);
  @override
  int get selectedRowCount => selectedIds2.length;

  // ignore: avoid_positional_boolean_parameters
  void selectedRow(String id, bool newSelectState) {
    if (selectedIds2.contains(id)) {
      selectedIds2.remove(id);
    } else {
      selectedIds2.add(id);
    }
    notifyListeners();
  }

  void _doDelete(BuildContext context, id) {
    final SubjectApiService apiService = SubjectApiService();
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
            apiService.deleteSubject(id).whenComplete(() => setNextView());
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
      GoRouter.of(context).go('${RouteUri.crudDetail}?id=$id');
      print('EDIT');
    }
    if (operationType == 'DETAILS') {
      print('DETAILS');
    }
    if (operationType == 'DELETE') {
      print('DELETE');
      _doDelete(context, id);
      // deleteConfirmationDialog(context, id);
    }
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<subjectClassModal>> getNextPage(
      NextPageRequest pageRequest,
      ) async {
    //the remote data source has to support the pagaing and sorting
    /*final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
    };*/


    final response1 = await apiService.getSubjectList();
    if (response1.statusCode == 200) {
      var response2 = await apiClassService.getClassById(classId);
      if (response2.statusCode == 200) {
      var data1 = jsonDecode(response1.body)["rows"];
      var data2 = jsonDecode(response2.body)["subject"];
      print("data1----->$data1");
      print("data12----->$data2");
    List filteredData1 = data1.where((element1) =>
      !data2.any((element2) => element1['id'].toString() == element2['id'].toString())).toList();

     /// data1.removeWhere((element) => data2.any((e) => e['id'].toString() == element['id'].toString()));
      var le = filteredData1.length;
      print("data3----->$filteredData1");
      return RemoteDataSourceDetails(
        int.parse(le.toString()),
        (filteredData1)
            .map(
              (json) => subjectClassModal.fromJson(json as Map<String, dynamic>),
        )
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty ? (filteredData1).length : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}