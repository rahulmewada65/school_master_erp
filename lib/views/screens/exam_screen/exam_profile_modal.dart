import 'package:flutter/material.dart';
import '../exam_screen/exam_screen.dart';

class ExamProfileModal {
  final int id;
  final String subjectName;
  final String subjectType;
  final String minimumNumber;
  final String maximumNumber;

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
            child: Text(minimumNumber),
          );
        })),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () => {
              {operation(id.toString(), context, "DETAILS")}
            },
            child: Text(maximumNumber),
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

  factory ExamProfileModal.fromJson(Map<String, dynamic> json) {
    return ExamProfileModal(
        json['id'] != null ? json['id'] as int : 0,
        json['name'] != null ? json['name'] as String : "",
        json['subjectType'] != null ? json['subjectType'] as String : "",
        json['minPassingMarks'] != null ? json['minPassingMarks'] as String : "",
        json['maxMarks'] != null ? json['maxMarks'] as String : "");
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
