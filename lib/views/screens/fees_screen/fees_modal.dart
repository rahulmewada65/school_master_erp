import 'package:flutter/material.dart';
import '../../../constants/dimens.dart';
import 'fee_screen.dart';

class CompanyContact {
  final int id;
  final String name;
  final String otherName;
  final int amount;


  const CompanyContact(
    this.id,
    this.name,
    this.otherName,
    this.amount,
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
            child: Text(name=='' ? otherName:name),
          );
        })),
        DataCell(Text(amount.toString())),
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

  factory CompanyContact.fromJson(Map<String, dynamic> json) {
    return CompanyContact(
        json['id'] as int,
        json['name'] != null ? json['name'] as String : "",
        json['otherName'] != null ? json['otherName'] as String : "",
        json['amount']  as int,
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': name,
      'firstName': otherName,
      'lastName': amount,
    };
  }
}
