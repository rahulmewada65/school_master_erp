import 'package:flutter/material.dart';
import '../../../constants/dimens.dart';
import 'crud_screen.dart';

class CompanyContact {
  final int id;
  final String rollNumber;
  final String firstName;
  final String lastName;
  final String mobileNumber;

  const CompanyContact(
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
        DataCell(Text(firstName)),
        DataCell(Text(lastName)),
        DataCell(Builder(builder: (context) {
          return Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 20.0,
              child: Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding / 2),
                child: SizedBox(
                  height: 20.0,
                  child: IconButton(
                    icon: const Icon(Icons.whatsapp),
                    color: Colors.green,
                    tooltip: 'Edit',
                    onPressed: () => {
                      {operation(id.toString(), context, "EDIT")}
                    },
                  ),
                ),
              ),
            ),
          ]);
        })),
        DataCell(Builder(builder: (context) {
          return TextButton(
            onPressed: () => {
              {operation(id.toString(), context, "DETAILS")}
            },
            child: Text(mobileNumber),
          );
        })),
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
