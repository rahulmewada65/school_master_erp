import 'package:flutter/material.dart';
import '../../../constants/dimens.dart';
import 'subject_screen.dart';

class subjectModal {
  final int id;
  final String name;
  final String subjectType;
  final int maxMarks;
  final int minPassingMarks;

  const subjectModal(
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

  factory subjectModal.fromJson(Map<String, dynamic> json) {
    return subjectModal(
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
