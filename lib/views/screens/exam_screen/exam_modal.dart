import 'package:flutter/material.dart';
import '../../../constants/dimens.dart';
import 'exam_screen.dart';

class ExamModal {
  final int id;
  final String name;
  final String examType;

  const ExamModal(
    this.id,
    this.name,
    this.examType,
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
        DataCell(Text(examType)),
        DataCell(Builder(
          builder: (context) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: kDefaultPadding / 2),
                    child: SizedBox(
                      height: 20.0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.green,
                        tooltip: 'Edit',
                        onPressed: () => {
                          {operation(id.toString(), context, "EDIT")}
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: kDefaultPadding / 2),
                    child: SizedBox(
                      height: 25.0,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        tooltip: 'Delete',
                        onPressed: () => {
                          {operation(id.toString(), context, "DELETE")}
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )),
      ],
      onSelectChanged: (newState) {
        callback(id.toString(), newState ?? false);
      },
      selected: selectedIds.contains(id.toString()),
    );
  }

  factory ExamModal.fromJson(Map<String, dynamic> json) {
    return ExamModal(
      json['id'] as int,
      json['name'] != null ? json['name'] as String : "",
      json['examType']!= null ?  json['examType'] as String :"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'examType': examType,
    };
  }
}
