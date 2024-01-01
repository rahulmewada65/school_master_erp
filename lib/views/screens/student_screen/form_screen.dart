import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:form_builder_asset_picker/form_builder_asset_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/class_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

class FormScreen extends StatefulWidget {
  final String id;
  const FormScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiService apiService = ApiService();
  final ClassApiService apiClassService = ClassApiService();
  final _formData = FormData();
  final storage = const FlutterSecureStorage();

  Future<bool>? _future;

  var studentData;
  var classData = [];

  Future<bool> _getDataAsync() async {
    Future<Response> response = getStudentDetails();
    Future<Response> response2 = getClass();
    final ot = response2;
    if (widget.id.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1), () async {
        response.then((value) => {
              studentData = jsonDecode(value.body),
              _formData.id = widget.id,
              _formData.rollNumber = studentData['rollNumber'],
              _formData.studentName = studentData['firstName'],
              _formData.fatherName = studentData['fatherName'],
              _formData.motherName = studentData['motherName'],
              _formData.aadharNumber = studentData['aadharNumber'],
              _formData.samgaraId = studentData['samagraId'],
              _formData.familyId = studentData['familyId'],
              _formData.gender = studentData['gender'],
              _formData.medium = studentData['medium'],
              // _formData.classes = studentData['classes'],
              _formData.subject = studentData['subjects'],
              _formData.dob = studentData['dob'],
              _formData.mobileNumber = studentData['mobileNumber'],
              _formData.mobileNumber2 = studentData['parentMobileNumber'],
              _formData.emailId = studentData['email'],
              _formData.bankName = studentData['bankName'],
              _formData.accountHolderName = studentData['accountHolderName'],
              _formData.accountNumber = studentData['accountNumber'],
              _formData.ifscCode = studentData['ifscCode'],
              _formData.address = studentData['address'],
            });
      });
    } else {}
    await Future.delayed(const Duration(seconds: 1), () {
      ot.then((value2) => {
            classData = jsonDecode(value2.body)['rows'],
            // print(jsonDecode(value2.body)['rows'])
          });
    });
    return true;
  }

  Future<Response> getStudentDetails() async {
    var response = apiService.getStudentById(widget.id);
    return response;
  }

  Future<Response> getClass() async {
    final response = await apiClassService.getClassList();
    return response;
  }

  void _showDialog(BuildContext context, DialogType dialogType) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: 'SUCCESS',
      desc: 'Student Data Success Save ...',
      width: kDialogWidth,
      btnOkOnPress: () {GoRouter.of(context).go(RouteUri.crud);},
      btnCancelOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    // final lang = Lang.of(context);
    final themeData = Theme.of(context);

    final pageTitle =
        'Student - ${widget.id.isEmpty ? "Admission Form" : " Update Form"}';

    return PortalMasterLayout(
      //selectedMenuUri: RouteUri.crud,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          // Text(
          //   pageTitle,
          //   style: themeData.textTheme.headline4,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: pageTitle,
                  ),
                  CardBody(
                    child: FutureBuilder<bool>(
                      initialData: null,
                      future: (_future ??= _getDataAsync()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          if (snapshot.hasData && snapshot.data!) {
                            return _content(context);
                          }
                        } else if (snapshot.hasData && snapshot.data!) {
                          return _content(context);
                        }

                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding),
                          child: SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  themeData.scaffoldBackgroundColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    // final appColorScheme = themeData.extension<AppColorScheme>()!;

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: UrlNewTabLauncher(
          //     displayText: 'flutter_form_builder - pub.dev',
          //     url: 'https://pub.dev/packages/flutter_form_builder',
          //     fontSize: 13.0,
          //   ),
          // ),

          Visibility(
            visible: widget.id.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ((constraints.maxWidth * 0.5) -
                            (kDefaultPadding * 0.5)),
                        child: FormBuilderTextField(
                          name: 'id',
                          decoration: const InputDecoration(
                            labelText: 'Student Id',
                            //hintText: '123456789',
                            helperText:
                                'Note: Student Id and Roll Number not Editable.',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          readOnly: true,
                          initialValue: _formData.id,
                          validator: FormBuilderValidators.required(),
                          onSaved: (value) =>
                              (_formData.samgaraId = value ?? ''),
                        ),
                      ),
                      const SizedBox(width: kDefaultPadding),
                      SizedBox(
                        width: ((constraints.maxWidth * 0.5) -
                            (kDefaultPadding * 0.5)),
                        child: FormBuilderTextField(
                          name: 'rollNumber',
                          decoration: const InputDecoration(
                            labelText: 'Roll Number',
                            //hintText: '1234556',
                            //helperText: 'Helper text',
                            border: OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          readOnly: true,
                          initialValue: _formData.rollNumber,
                          validator: FormBuilderValidators.required(),
                          onSaved: (value) =>
                              (_formData.familyId = value ?? ''),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'student_name',
              decoration: const InputDecoration(
                labelText: 'Student Name',
                hintText: 'Full Name',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.studentName,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.studentName = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'father_Name',
              decoration: const InputDecoration(
                labelText: 'Father Name',
                hintText: 'Full Name',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.fatherName,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.fatherName = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'mother_name',
              decoration: const InputDecoration(
                labelText: 'Mother Name',
                hintText: 'Full Name',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.motherName,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.motherName = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'aadhar_number',
              decoration: const InputDecoration(
                labelText: 'Aadhar Number ',
                hintText: 'XXXX-XXXX-XXXX',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.aadharNumber,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.aadharNumber = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'samgara_id',
                        decoration: const InputDecoration(
                          labelText: 'Samagra ID',
                          hintText: '123456789',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.samgaraId,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) =>
                            (_formData.samgaraId = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'family_id',
                        decoration: const InputDecoration(
                          labelText: 'Family ID',
                          hintText: '1234556',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.familyId,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) => (_formData.familyId = value ?? ''),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderRadioGroup(
                        name: 'gender',
                        orientation: OptionsOrientation.vertical,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _formData.gender,
                        options: const [
                          FormBuilderFieldOption(
                              value: 'Male', child: Text('Male')),
                          FormBuilderFieldOption(
                              value: 'Female', child: Text('Female')),
                          FormBuilderFieldOption(
                              value: 'Other', child: Text('Other')),
                        ],
                        onSaved: (value) => (_formData.gender = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderRadioGroup(
                        name: 'medium',
                        wrapSpacing: kDefaultPadding,
                        decoration: const InputDecoration(
                          labelText: 'Medium',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _formData.medium,
                        options: const [
                          FormBuilderFieldOption(
                              value: 'English', child: Text('English')),
                          FormBuilderFieldOption(
                              value: 'Hindi', child: Text('Hindi')),
                          // FormBuilderFieldOption(value: 'Item 3', child: Text('Item 3')),
                          // FormBuilderFieldOption(value: 'Item 4', child: Text('Item 4')),
                          // FormBuilderFieldOption(value: 'Item 5', child: Text('Item 5')),
                        ],
                        onSaved: (value) => (_formData.medium = value ?? ''),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: Theme(
              data: themeData.copyWith(
                // canvasColor: Colors.amber,
                splashColor: Colors.amber,
              ),
              child: FormBuilderDropdown(
                name: 'class',

                decoration: const InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                //allowClear: true,
                focusColor: Colors.transparent,
                //hint: const Text('Select Class'),
                //initialValue:_formData.classes,
                validator: FormBuilderValidators.required(),
                items: classData
                    .map((e) => DropdownMenuItem(
                        value: e['name'], child: Text(e["name"])))
                    .toList(),
                //  onSaved: (value) => (_formData.classes = value),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderFilterChip(
          //     name: 'subject',
          //     spacing: kDefaultPadding * 0.5,
          //     runSpacing: kDefaultPadding * 0.5,
          //     selectedColor: appColorScheme.warning,
          //     decoration: const InputDecoration(
          //       labelText: 'Subject',
          //       border: OutlineInputBorder(),
          //     ),
          //     //initialValue:_formData.subject,
          //     options: const [
          //       FormBuilderChipOption(value: 'Hindi', child: Text('Hindi')),
          //       FormBuilderChipOption(value: 'English', child: Text('English')),
          //       FormBuilderChipOption(value: 'Math', child: Text('Math')),
          //       FormBuilderChipOption(
          //           value: 'Sanskrit', child: Text('Sanskrit')),
          //       FormBuilderChipOption(value: 'Science', child: Text('Science')),
          //       FormBuilderChipOption(
          //           value: 'Social Science', child: Text('Social Science')),
          //       FormBuilderChipOption(
          //           value: 'Computer', child: Text('Computer')),
          //       FormBuilderChipOption(value: 'EVS', child: Text('EVS')),
          //       FormBuilderChipOption(value: 'Biology', child: Text('Biology')),
          //       FormBuilderChipOption(value: 'Physics', child: Text('Physics')),
          //       FormBuilderChipOption(
          //           value: 'Chemistry', child: Text('Chemistry')),
          //     ],
          //     onSaved: (value) => (_formData.subject = value ?? ''),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderDateTimePicker(
              name: 'dob',
              onChanged: (value) {},
              inputType: InputType.date,
              decoration: const InputDecoration(
                labelText: 'Date Of Birth',
                border: OutlineInputBorder(),
              ),
              // initialDate:DateTime.now(),
              // initialValue:_formData.dob.isEmpty?,
              // initialValue: _formData.dob.toString().isEmpty?DateTime.parse(_formData.dob.toString()):,
              onSaved: (value) =>
                  _formData.dob = DateFormat("yyyy-MM-dd").format(value!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'mobile_number',
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: '123456789',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.mobileNumber,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) =>
                            (_formData.mobileNumber = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'mobile_number2',
                        decoration: const InputDecoration(
                          labelText: 'Parent Contact ',
                          hintText: '1234556',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.mobileNumber2,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) =>
                            (_formData.mobileNumber2 = value ?? ''),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'email_id',
              decoration: const InputDecoration(
                labelText: 'Email ID',
                hintText: 'example@abc.com',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.emailId,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.emailId = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'bank_name',
                        decoration: const InputDecoration(
                          labelText: 'Bank Name',
                          hintText: 'xyz Bank',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.bankName,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) => (_formData.bankName = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'account_holder_name',
                        decoration: const InputDecoration(
                          labelText: 'Account Holder Name ',
                          hintText: 'abc',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.accountHolderName,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) =>
                            (_formData.accountHolderName = value ?? ''),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'account_number',
                        decoration: const InputDecoration(
                          labelText: 'Account Number',
                          hintText: '**********',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.aadharNumber,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) =>
                            (_formData.aadharNumber = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      child: FormBuilderTextField(
                        name: 'ifsc_code',
                        decoration: const InputDecoration(
                          labelText: 'IFSC Code ',
                          hintText: 'XYZ45577',
                          helperText: 'Helper text',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        initialValue: _formData.ifscCode,
                        validator: FormBuilderValidators.required(),
                        onSaved: (value) => (_formData.ifscCode = value ?? ''),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'address',
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText:
                    'House No,City/Village,District,Block,Post,Pin code,Landmark  ',
                helperText: 'Helper text',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.address,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.address = value ?? ''),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderAssetPicker(
          //     name: 'file_picker',
          //     allowedExtensions: const ['jpg', 'png', 'pdf'],
          //     allowMultiple: true,
          //     maxFiles: 5,
          //     type: FileType.custom,
          //     decoration: const InputDecoration(
          //       labelText: 'Document',
          //       border: OutlineInputBorder(),
          //     ),
          //     selector: Row(
          //       children: const [
          //         Icon(Icons.file_upload),
          //         Text('Upload'),
          //       ],
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderCheckbox(
              name: 'accept_terms',
              initialValue: false,
              onChanged: (value) {},
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'I have read and agree to the ',
                      style: TextStyle(
                        color: themeData.colorScheme.onSurface,
                      ),
                    ),
                    const TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              validator: FormBuilderValidators.equal(
                true,
                errorText: 'You must accept terms and conditions to continue',
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderChoiceChip(
          //     name: 'choice_chip',
          //     spacing: kDefaultPadding * 0.5,
          //     runSpacing: kDefaultPadding * 0.5,
          //     selectedColor: appColorScheme.warning,
          //     decoration: const InputDecoration(
          //       labelText: 'Single Choice Chip',
          //       border: OutlineInputBorder(),
          //     ),
          //     options: const [
          //       FormBuilderChipOption(value: 'Item 1', child: Text('Item 1')),
          //       FormBuilderChipOption(value: 'Item 2', child: Text('Item 2')),
          //       FormBuilderChipOption(value: 'Item 3', child: Text('Item 3')),
          //       FormBuilderChipOption(value: 'Item 4', child: Text('Item 4')),
          //       FormBuilderChipOption(value: 'Item 5', child: Text('Item 5')),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //       bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderSwitch(
          //     name: 'switch',
          //     title: const Text('Receive marketing email'),
          //     decoration: const InputDecoration(
          //       labelText: 'Switch',
          //       border: OutlineInputBorder(),
          //       hoverColor: Colors.amber,
          //       focusColor: Colors.transparent,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderDateTimePicker(
          //     name: 'time_picker',
          //     onChanged: (value) {},
          //     inputType: InputType.time,
          //     decoration: const InputDecoration(
          //       labelText: 'Time Picker',
          //       border: OutlineInputBorder(),
          //     ),
          //     initialTime: const TimeOfDay(hour: 8, minute: 0),
          //     initialValue: DateTime.now(),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderDateRangePicker(
          //     name: 'date_range',
          //     firstDate: DateTime(1970),
          //     lastDate: DateTime(2030),
          //     format: DateFormat('yyyy-MM-dd'),
          //     onChanged: (value) {},
          //     decoration: const InputDecoration(
          //       labelText: 'Date Range Picker',
          //       hintText: 'Hint text',
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
          //   child: FormBuilderSlider(
          //     name: 'slider',
          //     validator: FormBuilderValidators.compose([
          //       FormBuilderValidators.min(6),
          //     ]),
          //     onChanged: (value) {},
          //     min: 0.0,
          //     max: 10.0,
          //     initialValue: 7.0,
          //     divisions: 20,
          //     activeColor: appColorScheme.primary,
          //     inactiveColor: appColorScheme.primary.withOpacity(0.3),
          //     decoration: const InputDecoration(
          //       labelText: 'Slider',
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 36.0,
              width: 100.0,
              child: ElevatedButton(
                style: themeData.extension<AppButtonTheme>()!.primaryElevated,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Validation passed.
                    _formKey.currentState!.save();
                    var res = await apiService.addStudent(_formData.toJson());
                    print(res?.statusCode);
                    if (res?.statusCode == 201) {
                      _showDialog(context, DialogType.SUCCES);

                    }
                    //GoRouter.of(context).go(RouteUri.pdf-screen);
                  } else {
                    // Validation failed.
                  }
                },
                child: Text(widget.id.isEmpty ? lang.submit : "Update"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormData {
  String id = '';
  String rollNumber = '';
  String studentName = '';
  String fatherName = '';
  String motherName = '';
  String aadharNumber = '';
  String samgaraId = '';
  String familyId = '';
  String gender = '';
  String medium = '';
  String classes = '';
  List subject = [];
  String dob = '';
  String mobileNumber = '';
  String mobileNumber2 = '';
  String emailId = '';
  String bankName = '';
  String accountHolderName = '';
  String accountNumber = '';
  List documents=[];
  String ifscCode = '';
  String address = '';
  Map<String, dynamic> toJson() => {
        "firstName": studentName,
        'fatherName': fatherName,
        'motherName': motherName,
        'aadharNumber': aadharNumber,
        'samagraId': samgaraId,
        'familyId': familyId,
        'gender': gender,
        'medium': medium,
        'classes': classes,
        'subjects': subject,
        'dob': dob.toString(),
        'mobileNumber': mobileNumber,
        'parentMobileNumber': mobileNumber2,
        'email': emailId,
        'bankName': bankName,
        'accountHolderName': accountHolderName,
        'accountNumber': accountNumber,
        'ifscCode': ifscCode,
        'address': address,
    'documents':documents
      };
}
