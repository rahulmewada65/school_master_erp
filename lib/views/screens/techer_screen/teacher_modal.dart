import 'package:flutter/material.dart';
import '../../../constants/dimens.dart';
import 'teacher_screen.dart';

class teacherModal {
  final int id;
  final String structureName;
  final int totalAmount;

  const teacherModal(
    this.id,
    this.structureName,
    this.totalAmount,
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
            child: Text(structureName),
          );
        })),
        DataCell(Text(totalAmount.toString())),
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

  factory teacherModal.fromJson(Map<String, dynamic> json) {
    return teacherModal(
      json['id'] as int,
      json['structureName'] != null ? json['structureName'] as String : "",
      json['totalAmount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': structureName,
      'totalAmount': totalAmount,
    };
  }
}
