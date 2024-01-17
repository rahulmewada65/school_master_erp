import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:school_master_erp/services/profile_service.dart';
import 'package:school_master_erp/views/widgets/card_elements.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../helpers/constants.dart';
import '../../../services/api_service.dart';
import '../../../services/document_api_service.dart';
import '../../../services/fees_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../theme/theme_extensions/app_color_scheme.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

class StudentScreen extends StatefulWidget {
  final String id;
  const StudentScreen({Key? key, required this.id}) : super(key: key);
  @override
  State<StudentScreen> createState() => _StudentScreen();
}

class _StudentScreen extends State<StudentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  final ApiService apiService = ApiService();
  final ProfileApiService profileApiService = ProfileApiService();
  final FeesApiService apiServiceFee = FeesApiService();
  final _dataTableHorizontalScrollController = ScrollController();
  final DocumentApiService documentApiService = DocumentApiService();
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  Future<bool>? _future;
  Future<bool>? _future2;
  var studentData;
  List dropdowonOption = [];
  XFile? _imageFile;
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  List<Map<String, dynamic>> selectedFiles = [];
  var clickFiles = {};
  final ImagePicker _picker = ImagePicker();
  List stuData = [];
  List submitFeeDataFromApi = [];
  List selectedElement = [];
  var session = [];
  var _visibility1 = false;
  var _visibility2 = false;
  var _visibility3 = false;
  var _visibility4 = false;
  var _visibility5 = false;
  var _visibility6 = false;
  var _visibility7 = false;
  var _visibility8 = false;
  var _visibility9 = false;
  final imgPicker = ImagePicker();
  var selectedData;
  int discountAmountVar = 0;
  int selectedButtonIndex = 0;
  DateTime currentDate = DateTime.now();
  var _currentSession;
  var studentDataFee = [];
  var sbmittedFeeData = {};
  var selectExcel;
  var total;

  // Future<bool> _getDataAsync() async {
  //   await Future.delayed(const Duration(seconds: 2), () {
  //     _formData.userProfileImageUrl = 'hsttps://picsum.photos/id/1005/300/300';
  //     _formData.username = 'Admin ABC';
  //     _formData.email = 'adminabc@email.com';
  //   });
  //
  //   return true;
  // }

  @override
  initState() {
    super.initState();
    setSession();
    _getDataAsync();
    _getDataAsync2();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  Future showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Options"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text("Capture Image From Camera"),
                    onTap: () {
                      // _getImageFromCameraWeb();
                      _getImageFromCamera();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: const Text("Take Image From Gallery"),
                    onTap: () {
                      _getImageFromGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future showOptionsDialog2(BuildContext context) {
    sbmittedFeeData = {};
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final themeData = Theme.of(context);
          final appColorScheme = themeData.extension<AppColorScheme>()!;
          return AlertDialog(
            // title: const Text("Pay Fees"),
            content: SingleChildScrollView(
              child: SizedBox(
                  width: (kDefaultPadding * 20),
                  //height: 50,
                  child: ListBody(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Pay Fees"),
                            Text("$_currentSession"),
                          ],
                        ),
                      ),
                      const Divider(),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Date"),
                                SizedBox(
                                  width: (kDefaultPadding * 7),
                                  height: 50,
                                  child: FormBuilderDateTimePicker(
                                    name: 'Date',
                                    format: DateFormat("dd/MM/yyyy"),
                                    onChanged: (value) => {
                                      sbmittedFeeData["date"] = value,
                                    },
                                    inputType: InputType.date,
                                    validator: FormBuilderValidators.required(),
                                    decoration: const InputDecoration(
                                      // labelText: 'Date Of Birth',
                                      border: UnderlineInputBorder(),
                                    ),
                                    // initialDate: DateTime.now(),
                                    initialValue: DateTime.now(),
                                    // initialValue: _formData.dob.toString().isEmpty?DateTime.parse(_formData.dob.toString()):,
                                    //  onSaved: (value) => _formData.dob =  DateFormat("yyyy-MM-dd").format(value!) ?? '',
                                  ),
                                )
                              ])),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Amount"),
                            SizedBox(
                              width: (kDefaultPadding * 7),
                              height: 50,
                              child: FormBuilderTextField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                  decimal: true,
                                ),
                                validator: FormBuilderValidators.required(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^-?\d*.?\d*')),
                                ],
                                name: 'Amount',
                                decoration: const InputDecoration(
                                  labelText: 'Amount',
                                  border: UnderlineInputBorder(),
                                  // floatingLabelBehavior: FloatingLabelBehavior.auto,
                                ),
                                onChanged: (value) => {
                                  sbmittedFeeData["amount"] = value,
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Description"),
                            SizedBox(
                                width: (kDefaultPadding * 7),
                                height: 50,
                                child: FormBuilderTextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      signed: true,
                                      decimal: true,
                                    ),
                                    name: 'Description',
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                      border: UnderlineInputBorder(),
                                      // floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    ),
                                    onChanged: (value) => {
                                          sbmittedFeeData["decription"] = value,
                                        })),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Text("Payment Mode"),
                      SizedBox(
                        width: (kDefaultPadding * 15),
                        child: FormBuilderFilterChip(
                          name: 'subject',
                          spacing: kDefaultPadding * 0.1,
                          runSpacing: kDefaultPadding * 0.1,
                          selectedColor: appColorScheme.warning,
                          showCheckmark: false,
                          decoration: const InputDecoration(
                            // labelText: 'Subject',
                            border: UnderlineInputBorder(),
                          ),
                          initialValue: const ['Cash'],
                          options: const [
                            FormBuilderChipOption(
                                value: 'Cash',
                                child: Text(
                                  'Cash',
                                  style: TextStyle(fontSize: 12),
                                )),
                            FormBuilderChipOption(
                                value: 'Check',
                                child: Text(
                                  'Check',
                                  style: TextStyle(fontSize: 12),
                                )),
                            FormBuilderChipOption(
                                value: 'UPI',
                                child: Text(
                                  'UPI',
                                  style: TextStyle(fontSize: 12),
                                )),
                            FormBuilderChipOption(
                                value: 'Net Banking',
                                child: Text(
                                  'Net Banking',
                                  style: TextStyle(fontSize: 12),
                                )),
                            FormBuilderChipOption(
                                value: 'Other',
                                child: Text(
                                  'Other',
                                  style: TextStyle(fontSize: 12),
                                )),
                          ],
                          onChanged: (value) => {
                            sbmittedFeeData["paymentMode"] = value,
                          },
                        ),
                      ),
                      Text(
                        _visibility5 ? "* You can not amount empty" : '',
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          saveFee();
                        },
                        //  style: appColorScheme.infoText,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: kTextPadding),
                              child: Icon(Icons.save),
                            ),
                            Text('Save'),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  Future showOptionsDialog3(BuildContext context, Map data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // final themeData = Theme.of(context);
          // final appColorScheme = themeData.extension<AppColorScheme>()!;
          return AlertDialog(
            // title: const Text("Pay Fees"),
            content: SingleChildScrollView(
              child: SizedBox(
                  width: (kDefaultPadding * 20),
                  //height: 50,
                  child: ListBody(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Pay Fees"),
                            Text("$_currentSession"),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        width: (kDefaultPadding * 7),
                        height: 20,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Date"),
                                Text("${data["paidAt"].split(" ")[0]}")
                              ])),
                      const Divider(),
                      const SizedBox(
                        width: (kDefaultPadding * 7),
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Amount"),
                            Text("${data["amount"]}.00")
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        width: (kDefaultPadding * 7),
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Disruption"),
                            Text("${data["decription"]}")
                          ],
                        ),
                      ),
                      const Divider(),
                      //

                      const SizedBox(
                        width: (kDefaultPadding * 7),
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Payment Mood"),
                            Text("${data["paymentMode"]}")
                          ],
                        ),
                      ),
                      const Divider(),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                // saveFee();
                              },
                              //  style: appColorScheme.,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: kTextPadding),
                                    child: Icon(Icons.whatsapp),
                                  ),
                                  //  Text('Save'),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // saveFee();
                              },
                              //  style: appColorScheme.infoText,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: kTextPadding),
                                    child: Icon(Icons.download),
                                  ),
                                  //  Text('Save'),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _printScreen3(data);
                              },
                              //  style: appColorScheme.infoText,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: kTextPadding),
                                    child: Icon(Icons.print),
                                  ),
                                  //  Text('Save'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  Future<void> _getImageFromGallery() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selectedImage;
    });
    Navigator.of(context).pop();
  }

  Future<void> _getImageFromCamera() async {
    final XFile? takenImage =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = takenImage;
    });
    Navigator.of(context).pop();
  }

  Future<bool> _getDataAsync() async {
    selectSession("${currentDate.year - 1}-${currentDate.year}");
    Future<Response> response = getStudentDetails();
    if (widget.id.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1), () {
        response.then((value) => {
              studentData = jsonDecode(value.body),
              _formData.id = widget.id,
              _formData.rollNumber = studentData['rollNumber'],
              _formData.student_name = studentData['firstName'],
              _formData.father_name = studentData['fatherName'],
              _formData.mother_name = studentData['motherName'],
              _formData.aadhar_number = studentData['aadharNumber'],
              _formData.samgara_id = studentData['samagraId'],
              _formData.family_id = studentData['familyId'],
              _formData.gender = studentData['gender'],
              _formData.medium = studentData['medium'],
              // _formData.classes = studentData['classes'],
              _formData.subject = studentData['subjects'],
              _formData.dob = studentData['dob'],
              _formData.mobile_number = studentData['mobileNumber'],
              _formData.mobile_number2 = studentData['parentMobileNumber'],
              _formData.email_id = studentData['email'],
              _formData.bank_name = studentData['bankName'],
              _formData.account_holder_name = studentData['accountHolderName'],
              _formData.account_number = studentData['accountNumber'],
              _formData.ifsc_code = studentData['ifscCode'],
              _formData.address = studentData['address'],
            });
      });
    } else {}
    return true;
  }

  Future<bool> _getDataAsync2() async {
    Future<Response> response = getStudentDetails2();
    List stuData2 = [];
    await Future.delayed(const Duration(seconds: 1), () {
      response.then(
          (value) => {stuData2 = jsonDecode(value.body), setData(stuData2)});
    });

    return true;
  }

  Future<Response> getStudentDetails() async {
    var response = apiService.getStudentById(widget.id);
    return response;
  }

  Future<Response> getStudentProfileDetails(value) async {
    var response =
        profileApiService.getStudentProfileById(widget.id, value.toString());
    return response;
  }

  Future<Response> getFeeDetails(value) async {
    var response2 = profileApiService.getFeeDetailsBySessionAndStudentId(
        widget.id, value.toString());
    return response2;
  }

  Future<Response> getStudentDetails2() async {
    final response = await apiServiceFee.getFeesSturctureList();
    return response;
  }

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();
      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Divider(),
                pw.Container(
                  child: pw.Text("Student Profile"),
                ),
                pw.Divider(),
                pw.LayoutBuilder(
                  builder: (context, constraints) {
                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          child: pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Roll Number         :   ${_formData.rollNumber}",
                              ),
                              pw.SizedBox(
                                height: 15,
                              ),
                              pw.Text(
                                "Student Name        :   ${_formData.student_name}",
                              ),
                              pw.SizedBox(
                                height: 15,
                              ),
                              pw.Text(
                                "Father Name         :   ${_formData.father_name}",
                              ),
                              pw.SizedBox(
                                height: 15,
                              ),
                              pw.Text(
                                " Mother Name      :   ${_formData.mother_name}",
                              ),
                              pw.SizedBox(
                                height: 15,
                              ),
                              pw.Text(
                                " Date Of Birth        :   ${_formData.dob}",
                              ),
                            ],
                          ),
                        ),
                        // pw.Align(alignment: pw.Alignment.bottomRight, child:
                        // pw.Stack(
                        //   children: [
                        //      pw.Circle(
                        //       backgroundColor: PdfColor.,
                        //       backgroundImage:
                        //       pw.NetworkImage('https://picsum.photos/id/1005/300/300'),
                        //       radius: 60.0,
                        //     ),
                        //   ],
                        // )
                        // )
                      ],
                    );
                  },
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Divider(),
                pw.Container(
                  child: pw.Text("Address Details"),
                ),
                pw.Divider(),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Address                :   ${_formData.address}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Divider(),
                pw.Container(
                  child: pw.Text("Contact Details"),
                ),
                pw.Divider(),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Mobile Number 1        :   ${_formData.mobile_number}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "Mobile Number 2        :   ${_formData.mobile_number2}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "Email ID                        :   ${_formData.email_id}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Divider(),
                pw.Container(
                  child: pw.Text("Bank Details"),
                ),
                pw.Divider(),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Bank Name                      :    ${_formData.bank_name}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "Account Number            :   ${_formData.account_number}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              " Account Holder Name  :   ${_formData.account_holder_name}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "IFSC Code                        :   ${_formData.ifsc_code}",
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                pw.SizedBox(
                  height: 15,
                ),
                pw.Divider(),
                pw.Container(
                  child: pw.Text("Other Details"),
                ),
                pw.Divider(),
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Aadhaar Number           :   ${_formData.aadhar_number}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "Samagra ID                    :   ${_formData.samgara_id}",
                            ),
                            pw.SizedBox(
                              height: 15,
                            ),
                            pw.Text(
                              "Family ID                        :   ${_formData.family_id}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }));

      return doc.save();
    });
  }

  void _printScreen2() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();
      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Divider(),
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                          "Structure Name :  ${_visibility4 ? studentDataFee[0]["structureName"] : ''} "),
                      pw.Text(
                          "Session:  ${_visibility4 ? studentDataFee[0]["sessionYear"] : ''} "),
                    ])),
                pw.Divider(),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("Id"),
                    pw.Text("Element"),
                    pw.Text("Amount"),
                  ],
                )),
                pw.Divider(),
                for (int i = 0; i < selectedElement.length; i++)
                  pw.Container(
                      child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                          " ${_visibility4 ? selectedElement[i]["id"] : ''}"),
                      pw.Text("Element"),
                      pw.Text(
                          " ${_visibility4 ? selectedElement[i]["amount"] : ''}"),
                    ],
                  )),
                pw.Divider(),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("Total Amount"),
                    pw.Text(
                        " ${_visibility4 ? studentDataFee[0]["totalAmount"] : ""}"),
                  ],
                )),
                pw.Divider(),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("Discounted Amount"),
                    pw.Text(
                        "${_visibility4 ? studentDataFee[0]["disscount"] : ""}"),
                  ],
                )),
                pw.Divider(),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text("Final Amount"),
                    pw.Text("$discountAmountVar"),
                  ],
                )),
                pw.Divider(),
              ],
            );
          }));

      return doc.save();
    });
  }

  void _printScreen3(Map data) {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();
      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Texas High School of Arts and Science",
                        style: pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "ask@texashsas.edu",
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "222 555 7777",
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 30),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  // crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                          pw.Text(
                            "Basic Primary School Receipt",
                            style: pw.TextStyle(
                                color: PdfColors.red,
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold),
                          ),
                        ])),
                  ],
                )),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  // crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                          pw.Text(
                            "Receipt Number :",
                            style: const pw.TextStyle(
                              // color: PdfColors.red,
                              fontSize: 16,
                              // fontWeight: pw.FontWeight.bold
                            ),
                          ),
                          pw.Text(
                            " ${data["transactionId"]}",
                            style: pw.TextStyle(
                                // color: PdfColors.red,
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold),
                          ),
                        ])),
                  ],
                )),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Student Name :",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                      pw.Text(
                        _formData.student_name,
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Student Address: ",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                      pw.Text(
                        _formData.address,
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Mobile Number : ",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                      pw.Text(
                        _formData.mobile_number,
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Date :",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                      pw.Text(
                        "${data["paidAt"].split(" ")[0]}",
                        style: pw.TextStyle(
                            // color: PdfColors.red,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 30),
                pw.Container(
                    height: 45,
                    color: PdfColors.cyan,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                              width: 150,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Text(
                                "    Description",
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold),
                              )),
                          pw.Container(
                              width: 380,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      "Quantity",
                                      style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      "Price",
                                      style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                    pw.Text(
                                      "Total",
                                      style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ]))
                        ])),
                pw.SizedBox(height: 1),
                pw.Container(
                    height: 45,
                    //color: PdfColors,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                              width: 150,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Text(
                                "${data["decription"] ?? "Tuition Fee"}",
                                style: const pw.TextStyle(
                                  //color: PdfColors.white,
                                  fontSize: 15,
                                  // fontWeight: pw.FontWeight.bold
                                ),
                              )),
                          pw.Container(
                              width: 380,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      "1           ",
                                      style: const pw.TextStyle(
                                        //  color: PdfColors.white,
                                        fontSize: 15,
                                        //fontWeight: pw.FontWeight.bold
                                      ),
                                    ),
                                    pw.Text(
                                      "${data["amount"]} fee",
                                      style: const pw.TextStyle(
                                        //color: PdfColors.white,
                                        fontSize: 15,
                                        // fontWeight: pw.FontWeight.bold
                                      ),
                                    ),
                                    pw.Text(
                                      "${data["amount"]}",
                                      style: const pw.TextStyle(
                                        // color: PdfColors.white,
                                        fontSize: 15,
                                        // fontWeight: pw.FontWeight.bold
                                      ),
                                    ),
                                  ]))
                        ])),
                pw.Container(
                  height: 1,
                  color: PdfColors.grey300,
                ),
                pw.Container(
                    height: 45,
                    //color: PdfColors,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                              width: 250,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Text(
                                "    Tax",
                                style: const pw.TextStyle(
                                  //color: PdfColors.white,
                                  fontSize: 15,
                                  // fontWeight: pw.FontWeight.bold
                                ),
                              )),
                          pw.Container(
                              width: 400,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      "0%",
                                      style: const pw.TextStyle(
                                        // color: PdfColors.white,
                                        fontSize: 15,
                                        // fontWeight: pw.FontWeight.bold
                                      ),
                                    ),
                                  ]))
                        ])),
                pw.Container(
                  height: 1,
                  color: PdfColors.grey300,
                ),
                pw.Container(
                    height: 45,
                    //color: PdfColors,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                              width: 250,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Text(
                                "    Total",
                                style: pw.TextStyle(
                                    //color: PdfColors.white,
                                    fontSize: 15,
                                    fontWeight: pw.FontWeight.bold),
                              )),
                          pw.Container(
                              width: 400,
                              // height: 45,
                              // color: PdfColors.cyan,
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      "${data["amount"]}",
                                      style: pw.TextStyle(
                                          // color: PdfColors.white,
                                          fontSize: 15,
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ]))
                        ])),
                pw.Container(
                  height: 1,
                  color: PdfColors.grey300,
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "Terms & Conditions",
                        style: pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "• The fee mentioned above has been paid by the student.",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                    ])),
                pw.SizedBox(height: 8),
                pw.Container(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        //  crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Text(
                        "• The fee mentioned above has been paid by the student.",
                        style: const pw.TextStyle(
                          // color: PdfColors.red,
                          fontSize: 16,
                          // fontWeight: pw.FontWeight.bold
                        ),
                      ),
                    ])),
              ],
            );
          }));

      return doc.save();
    });
  }

  void _doSave(BuildContext context) {
    AppFocusHelper.instance.requestUnfocus();
    // final lang = Lang.of(context);
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      title: "Do You Want Save Fee Structure.",
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () async {
        var res = await profileApiService
            .addStudentFeeSturcture_WithSession(selectedData);
        // print(res?.statusCode);
        if (res?.statusCode == 201) {
          _showDialog(context, DialogType.SUCCES);
        } else {}
      },
    );

    dialog.show();
  }

  void _showDialog(BuildContext context, DialogType dialogType) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: 'SUCCESS',
      desc: 'Student Fee Structure Success Save ...',
      width: kDialogWidth,
      btnOkOnPress: () {
        selectSession(_currentSession);
      },
      btnCancelOnPress: () {},
    );
    dialog.show();
  }

  void _showDialog2(BuildContext context, DialogType dialogType, Map data) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: dialogType,
      title: 'SUCCESS',
      desc: 'Student Fee Structure Success Save ...',
      width: kDialogWidth,
      btnOkOnPress: () {
        Navigator.pop(context);
        showOptionsDialog3(context, data);
      },
      btnCancelOnPress: () {},
    );
    dialog.show();
  }

  // Future<void> openImages() async {
  //   try {
  //     // FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     //   allowMultiple: true, // Enable multiple file selection
  //     // );
  //     final XFile? takenImage2 = await _picker.pickImage(source: ImageSource.camera);
  //     if (takenImage2 != null) {
  //      // List<Map<String, dynamic>> filesData = [];
  //       // for (var file in result.files) {
  //       //   Uint8List? fileBytes = file.bytes;
  //       //
  //       //   // if( file.extension=="pdf"){
  //       //   //   if (file.bytes != null) {
  //       //   //     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => file.bytes!);
  //       //   //   }
  //       //   // }
  //       //
  //       //   if (fileBytes != null) {
  //       //     Map<String, dynamic> fileData = {
  //       //       'fileName': file.name ?? '',
  //       //       'fileType': file.extension ?? '',
  //       //       'fileContent': fileBytes,
  //       //       'fileBytes': file.bytes,
  //       //     };
  //       //     filesData.add(fileData);
  //       //   }
  //       // }
  //       // setState(() {
  //       //   selectedFiles = filesData;
  //       //   clickFiles = filesData[0];
  //       // });
  //       var studentId = widget.id;
  //       // var fileName = filesData[0]['fileName'];
  //       // var fileBytes = filesData[0]['fileBytes'];
  //       //
  //       // final res = await documentApiService.uploadDocument(
  //       //     studentId: studentId, filesData: clickFiles);
  //
  //       var url = Uri.parse('${Constants.BASE_URL}/upload-document');
  //       var request = html.MultipartRequest('POST', url);
  //       request.fields['studentId'] = studentId;
  //
  //       var multipartFile = await  MultipartFile.fromPath(
  //         'files',
  //         takenImage2.path,
  //       );
  //       request.files.add(multipartFile);
  //     }
  //   } catch (e) {
  //     print('Error while picking files: $e');
  //   }
  // }

  Future<void> openImages() async {
    try {
      var studentId = widget.id;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Enable multiple file selection
      );

      if (result != null && result.files.isNotEmpty) {
        var url = Uri.parse('${Constants.BASE_URL}/upload-document');
        var request = http.MultipartRequest('POST', url);
        // Add studentId field to the request
        request.fields.addAll({'studentId': studentId});
        List<Map<String, dynamic>> filesData = [];
        for (var file in result.files) {
          Uint8List? fileBytes = file.bytes;
          if (fileBytes != null) {
            Map<String, dynamic> fileData = {
              'fileName': file.name ?? '',
              'fileType': file.extension ?? '',
              'fileContent': String.fromCharCodes(file.bytes!),
              'fileBytes': file.bytes,
            };
            filesData.add(fileData);
          }
        }
        setState(() {
          selectedFiles = filesData;
          clickFiles = filesData[0];
        });
        for (var file in result.files) {
          if (file.bytes != null) {
            Uint8List bytes = file.bytes!;
            List<int> byteList = bytes.toList();
            // Add each file to the request
            request.files.add(http.MultipartFile.fromBytes(
              'files',
              byteList,
              filename: file.name,
            ));
          } else {
            print('File "${file.name}" has no bytes');
          }
        }
        try {
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            print('Files uploaded successfully');
          } else {
            print('Failed to upload files. Status code: ${response.statusCode}');
          }
        } catch (e) {
          print('Error during request: $e');
        }
      } else {
        // User canceled the file picker or no files were selected
        print('File picking canceled or no files selected');
      }
    } catch (e) {
      print('Error while picking files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final appButtonTheme = themeData.extension<AppButtonTheme>()!;
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;

    return PortalMasterLayout(
      selectedMenuUri: RouteUri.crud,
      body: SingleChildScrollView(
        // Wrapping the whole body in a SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int index = 0; index < 4; index++)
                    LayoutBuilder(builder: (context, constraints) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17,
                              height: 45,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedButtonIndex = index;
                                  });
                                },
                                style: selectedButtonIndex == index
                                    ? appButtonTheme.primaryText
                                    : appButtonTheme.secondaryText,
                                child: Text(index == 0
                                    ? 'Student Details'
                                    : index == 1
                                        ? 'Student Fee Details'
                                        : index == 2
                                            ? 'Academic Details'
                                            : index == 3
                                                ? 'Sudent Document'
                                                : ""),
                              ),
                            ),
                            Container(
                              color: selectedButtonIndex == index
                                  ? Colors.blue
                                  : Colors
                                      .white, // Set the color of the Container
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.17,
                                height: 2,
                              ),
                            ),
                          ]);
                    })
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (selectedButtonIndex == 0) ...[
              SingleChildScrollView(
                // Wrap the section you want to make scrollable
                child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: kDefaultPadding,
                              right: kDefaultPadding,
                              top: kDefaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CardHeader(
                                title: "Student Profile",
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CardBody(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // const Align(alignment: Alignment.topLeft, child: Text("left")),
                                            // const Align(alignment: Alignment.centerRight, child: Text("right")),

                                            Text(
                                                "Roll Number          :   ${_formData.rollNumber}",
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Student Name       :   ${_formData.student_name}",
                                                textAlign: TextAlign.start),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Father Name         :   ${_formData.father_name}",
                                                textAlign: TextAlign.left),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Mother Name        :   ${_formData.mother_name}",
                                                textAlign: TextAlign.left),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                                "Date Of Birth         :   ${_formData.dob}",
                                                textAlign: TextAlign.left),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage:
                                                  _imageFile != null
                                                      ? NetworkImage(
                                                          _imageFile!.path,
                                                        )
                                                      : null,
                                              // Use NetworkImage for network URLs
                                              radius: 60.0,
                                            ),
                                            Positioned(
                                              top: 0.0,
                                              right: 0.0,
                                              child: SizedBox(
                                                height: 40.0,
                                                width: 40.0,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    showOptionsDialog(
                                                        context); // Show options to pick or capture image
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit_rounded,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ));
                                },
                              ),
                              const CardHeader(
                                title: "",
                              ),
                              const CardHeader(
                                title: "Address Details",
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    CardBody(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "Address                :   ${_formData.address}",
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const CardHeader(
                                title: "",
                              ),
                              const CardHeader(
                                title: "Contact Details",
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    CardBody(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "Mobile Number 1        :   ${_formData.mobile_number}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Mobile Number 2        :   ${_formData.mobile_number2}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Email ID                        :   ${_formData.email_id}",
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const CardHeader(
                                title: "",
                              ),
                              const CardHeader(
                                title: "Bank Details",
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    CardBody(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "Bank Name                      :    ${_formData.bank_name}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Account Number            :   ${_formData.account_number}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              " Account Holder Name  :   ${_formData.account_holder_name}",
                                              textAlign: TextAlign.left),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "IFSC Code                        :   ${_formData.ifsc_code}",
                                              textAlign: TextAlign.left),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const CardHeader(
                                title: "",
                              ),
                              const CardHeader(
                                title: "Other Details",
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    CardBody(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "Aadhaar Number           :   ${_formData.aadhar_number}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Samagra ID                    :   ${_formData.samgara_id}",
                                              textAlign: TextAlign.start),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Family ID                        :   ${_formData.family_id}",
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const CardHeader(
                                title: "",
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: SizedBox(
                                    height: 40.0,
                                    width: 120.0,
                                    child: TextButton(
                                      onPressed: () {
                                        _printScreen();
                                      },
                                      style: appButtonTheme.infoText,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: kTextPadding),
                                            child: Icon(Icons.print_rounded),
                                          ),
                                          Text('Print'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    )),
              ),
            ],
            if (selectedButtonIndex == 1) ...[
              SingleChildScrollView(
                // Wrap the section you want to make scrollable
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: kDefaultPadding,
                          right: kDefaultPadding,
                          top: kDefaultPadding),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text("Fees Section "),
                          ),
                          const Divider(),

                          Container(
                              alignment: Alignment.center,
                              child:Row(

                                  children: <Widget>[
                                    FormBuilderDropdown(
                                        name: 'class',
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        iconEnabledColor:
                                        appColorScheme.primary,
                                        decoration: const InputDecoration(
                                          //labelText: 'Select Session',
                                          border: OutlineInputBorder(),
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                        ),
                                        allowClear: true,
                                        focusColor: Colors.transparent,
                                        //hint: const Text('Select Class'),
                                        initialValue:
                                        "${currentDate.year - 1}-${currentDate.year}",
                                        // validator: FormBuilderValidators.required(),
                                        // onChanged: ,
                                        // onTap: ,
                                        items: dropdowonOption
                                            .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                            .toList(),
                                        onChanged: (value) =>
                                        (selectSession(value))),

                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  create();
                                                },
                                                //style: appButtonTheme.infoText,
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          right:
                                                          kTextPadding),
                                                      child: Icon(Icons
                                                          .create_new_folder),
                                                    ),
                                                    Text('Upload/Update'),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  ]),

                            ),


                          // Visibility(
                          //     visible: _visibility1,
                          //     child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             bottom: kDefaultPadding),
                          //         child: Card(
                          //             clipBehavior: Clip.antiAlias,
                          //             child: Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   const CardHeader(
                          //                     title: "Select Structure",
                          //                   ),
                          //                   CardBody(
                          //                       child: Container(
                          //                     alignment: Alignment.centerLeft,
                          //                     child: FormBuilderDropdown(
                          //                         name: 'class',
                          //                         decoration:
                          //                             const InputDecoration(
                          //                           labelText:
                          //                               'Select a structure',
                          //                           border:
                          //                               OutlineInputBorder(),
                          //                           hoverColor:
                          //                               Colors.transparent,
                          //                           focusColor:
                          //                               Colors.transparent,
                          //                         ),
                          //                         allowClear: true,
                          //                         focusColor:
                          //                             Colors.transparent,
                          //                         items: stuData
                          //                             .map((e) => DropdownMenuItem(
                          //                                 value: e,
                          //                                 child: Text(e[
                          //                                     "structureName"])))
                          //                             .toList(),
                          //                         onChanged: (value) =>
                          //                             (selectStructure(value))),
                          //                   ))
                          //                 ])))), //it's for when data not available in selected session when click on create button
                          //
                          // Visibility(
                          //   visible: _visibility2,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(
                          //         bottom: kDefaultPadding),
                          //     child: Card(
                          //       clipBehavior: Clip.antiAlias,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           CardHeader(
                          //             title:
                          //                 "Selected Structure Name :     ${selectedData?["structureName"]} ",
                          //           ),
                          //           CardBody(
                          //             child: Container(
                          //               alignment: Alignment.centerLeft,
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceBetween,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: const [
                          //                   Text("ID ",
                          //                       textAlign: TextAlign.start),
                          //                   Text(" Name",
                          //                       textAlign: TextAlign.start),
                          //                   Text(" Amount",
                          //                       textAlign: TextAlign.start),
                          //                   SizedBox(
                          //                     height: 10,
                          //                     width: 50,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           const Divider(),
                          //           for (int i = 0;
                          //               i < selectedElement.length;
                          //               i++)
                          //             CardBody(
                          //               child: Container(
                          //                 alignment: Alignment.centerLeft,
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                         " ${selectedElement[i]["id"]}",
                          //                         textAlign: TextAlign.start),
                          //                     const Text("Rahul",
                          //                         textAlign: TextAlign.start),
                          //                     Text(
                          //                         " ${selectedElement[i]["amount"]}",
                          //                         textAlign: TextAlign.start),
                          //                     const SizedBox(
                          //                       height: 15,
                          //                       width: 55,
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           const Divider(),
                          //           CardBody(
                          //             child: Container(
                          //               alignment: Alignment.centerLeft,
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceBetween,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   const Text("Total Amount ",
                          //                       textAlign: TextAlign.start),
                          //                   const Text(" ",
                          //                       textAlign: TextAlign.start),
                          //                   Text(
                          //                       " ${selectedData?["totalAmount"]}",
                          //                       textAlign: TextAlign.start),
                          //                   const SizedBox(
                          //                     height: 10,
                          //                     width: 50,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           const Divider(),
                          //           CardBody(
                          //             child: Container(
                          //               alignment: Alignment.centerLeft,
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceBetween,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   const Text("Discount Amount ",
                          //                       textAlign: TextAlign.start),
                          //                   const Text(" ",
                          //                       textAlign: TextAlign.start),
                          //                   const SizedBox(
                          //                     height: 10,
                          //                     width: 40,
                          //                   ),
                          //                   SizedBox(
                          //                     width: (kDefaultPadding * 12),
                          //                     height: 40,
                          //                     child: FormBuilderTextField(
                          //                       keyboardType:
                          //                           const TextInputType
                          //                               .numberWithOptions(
                          //                         signed: true,
                          //                         decimal: true,
                          //                       ),
                          //                       inputFormatters: [
                          //                         FilteringTextInputFormatter
                          //                             .allow(RegExp(
                          //                                 r'^-?\d*.?\d*')),
                          //                       ],
                          //                       name: 'mobile_number',
                          //                       decoration:
                          //                           const InputDecoration(
                          //                         labelText: 'Discount Amount',
                          //                         border: OutlineInputBorder(),
                          //                         floatingLabelBehavior:
                          //                             FloatingLabelBehavior
                          //                                 .auto,
                          //                       ),
                          //                       onChanged: (value) =>
                          //                           (discountAmount(
                          //                               value,
                          //                               selectedData?[
                          //                                   "totalAmount"])),
                          //                     ),
                          //                   ),
                          //                   const SizedBox(
                          //                     height: 10,
                          //                     width: 40,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           const Divider(),
                          //           CardBody(
                          //             child: Container(
                          //               alignment: Alignment.centerLeft,
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceBetween,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   const Text("Final Amount ",
                          //                       textAlign: TextAlign.start),
                          //                   const Text(" ",
                          //                       textAlign: TextAlign.start),
                          //                   const Text(" ",
                          //                       textAlign: TextAlign.start),
                          //                   Text(
                          //                       " ${discountAmountVar != 0 ? discountAmountVar : selectedData?["totalAmount"]}",
                          //                       textAlign: TextAlign.start),
                          //                   Container(
                          //                     alignment: Alignment.centerLeft,
                          //                     child: Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .spaceBetween,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         TextButton(
                          //                           onPressed: () {
                          //                             saveData(context);
                          //                           },
                          //                           // style: appButtonTheme.infoText,
                          //                           child: Row(
                          //                             mainAxisSize:
                          //                                 MainAxisSize.min,
                          //                             children: const [
                          //                               Padding(
                          //                                 padding: EdgeInsets.only(
                          //                                     right:
                          //                                         kTextPadding),
                          //                                 child:
                          //                                     Icon(Icons.save),
                          //                               ),
                          //                               Text('Save'),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                         TextButton(
                          //                           onPressed: () {
                          //                             _printScreen();
                          //                           },
                          //                           // style: appButtonTheme.infoText,
                          //                           child: Row(
                          //                             mainAxisSize:
                          //                                 MainAxisSize.min,
                          //                             children: const [
                          //                               Padding(
                          //                                 padding: EdgeInsets.only(
                          //                                     right:
                          //                                         kTextPadding),
                          //                                 child: Icon(Icons
                          //                                     .print_rounded),
                          //                               ),
                          //                               Text('Print'),
                          //                             ],
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Visibility(
                              visible: _visibility3,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: kDefaultPadding),
                                  child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: CardBody(
                                          child:
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                        "No Fee Data Available Please Create a Fee Structure",
                                                        textAlign:
                                                            TextAlign.center),
                                                    TextButton(
                                                      onPressed: () {
                                                        create();
                                                      },
                                                      //style: appButtonTheme.infoText,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        kTextPadding),
                                                            child: Icon(Icons
                                                                .create_new_folder),
                                                          ),
                                                          Text('Create'),
                                                        ],
                                                      ),
                                                    ),
                                                  ]))
                                      )))),
                          Visibility(
                            visible: true,
                            // _visibility7,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: kDefaultPadding),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardBody(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      " Structure Name :  ${studentDataFee.isNotEmpty ? studentDataFee[0]["structureName"] : ''}",
                                                      textAlign:
                                                          TextAlign.start),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Session:  ${studentDataFee.isNotEmpty ? studentDataFee[0]["sessionYear"] : ""} ",
                                                      textAlign: TextAlign.end),
                                                ]),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _visibility6 = !_visibility6;
                                                });
                                              },
                                              //style: appButtonTheme.infoText,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right:
                                                                kTextPadding),
                                                    child: _visibility6
                                                        ? const Icon(Icons
                                                            .keyboard_arrow_up)
                                                        : const Icon(Icons
                                                            .keyboard_arrow_down),
                                                  ),
                                                  //Text('Create'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _visibility6,
                                      child: _visibility4
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0),
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // CardHeader(
                                                    //   title: lang.recentOrders(2),
                                                    //   showDivider: false,
                                                    // ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final double
                                                              dataTableWidth =
                                                              max(
                                                                  kScreenWidthMd,
                                                                  constraints
                                                                      .maxWidth);
                                                          return Scrollbar(
                                                            controller:
                                                                _dataTableHorizontalScrollController,
                                                            thumbVisibility:
                                                                true,
                                                            trackVisibility:
                                                                true,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              controller:
                                                                  _dataTableHorizontalScrollController,
                                                              child: SizedBox(
                                                                width:
                                                                    dataTableWidth,
                                                                child: Theme(
                                                                  data: themeData
                                                                      .copyWith(
                                                                    cardTheme:
                                                                        appDataTableTheme
                                                                            .cardTheme,
                                                                    dataTableTheme:
                                                                        appDataTableTheme
                                                                            .dataTableThemeData,
                                                                  ),
                                                                  child:
                                                                      DataTable(
                                                                    showCheckboxColumn:
                                                                        true,
                                                                    showBottomBorder:
                                                                        true,
                                                                    columns: const [
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Id '),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Description '),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Amount'),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              '         '),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              '         '),
                                                                          numeric:
                                                                              true)
                                                                    ],
                                                                    rows: List.generate(
                                                                        selectedElement
                                                                            .length,
                                                                        (index) {
                                                                      return DataRow
                                                                          .byIndex(
                                                                        index:
                                                                            index,
                                                                        cells: [
                                                                          DataCell(
                                                                              Text("#${index + 1}")),
                                                                          DataCell(
                                                                              Text("${selectedElement.isNotEmpty ? selectedElement[index]["decription"] : ''}")),
                                                                          const DataCell(
                                                                              Text("            ")),
                                                                          DataCell(
                                                                              Text(
                                                                            "${selectedElement.isNotEmpty ? selectedElement[index]["amount"] : ''}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                          )),
                                                                          const DataCell(
                                                                              Text("            ")),
                                                                        ],
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const Text("   "),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          const Text(
                                                              "Total  Amount :  "),
                                                          Text(
                                                              " ${studentDataFee.isNotEmpty ? studentDataFee[0]["totalAmount"] : ''}"),
                                                        ]),
                                                    const Text(""),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          const Text(
                                                              " Discounted Amount : "),
                                                          Text(
                                                              " ${studentDataFee.isNotEmpty ? studentDataFee[0]["disscount"] : ""}")
                                                        ]),
                                                    const Text(""),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          const Text(
                                                              " Final Amount : "),
                                                          Text(
                                                              "  $discountAmountVar")
                                                        ]),
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  remove(
                                                                      context);
                                                                },
                                                                style: appButtonTheme
                                                                    .errorText,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: const [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              kTextPadding),
                                                                      child: Icon(
                                                                          Icons
                                                                              .delete),
                                                                    ),
                                                                    Text(""),
                                                                  ],
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  _printScreen2();
                                                                },
                                                                style:
                                                                    appButtonTheme
                                                                        .infoText,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: const [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              kTextPadding),
                                                                      child: Icon(
                                                                          Icons
                                                                              .print_rounded),
                                                                    ),
                                                                    Text(""),
                                                                  ],
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  setState(() =>
                                                                      _visibility5 =
                                                                          false);
                                                                  showOptionsDialog2(
                                                                      context);
                                                                },
                                                                style: appButtonTheme
                                                                    .primaryText,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: const [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              kTextPadding),
                                                                      child: Icon(
                                                                          Icons
                                                                              .payments_outlined),
                                                                    ),
                                                                    Text(""),
                                                                  ],
                                                                ),
                                                              )
                                                            ])),
                                                    // Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                                    //     children: <Widget>[
                                                    //       TextButton(
                                                    //         onPressed: () {
                                                    //           create();
                                                    //         },
                                                    //         style: appButtonTheme.infoText,
                                                    //         child: Row(
                                                    //           mainAxisSize: MainAxisSize.min,
                                                    //           children: const [
                                                    //             Padding(
                                                    //               padding: EdgeInsets.only(
                                                    //                   right: kTextPadding),
                                                    //               child: Icon(Icons.print),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       TextButton(
                                                    //         onPressed: () {
                                                    //           create();
                                                    //         },
                                                    //         style: appButtonTheme.primaryText,
                                                    //         child: Row(
                                                    //           mainAxisSize: MainAxisSize.min,
                                                    //           children: const [
                                                    //             Padding(
                                                    //               padding: EdgeInsets.only(
                                                    //                   right: kTextPadding),
                                                    //               child: Icon(
                                                    //                   Icons.payments_outlined),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     ])
                                                  ],
                                                ),
                                              ),
                                            )
                                          : CardBody(
                                              child:

                                                  Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        "No Uploaded  Fees Structure Available ",
                                                        textAlign:
                                                            TextAlign.start),
                                                    TextButton(
                                                      onPressed: () {
                                                        create();
                                                      },
                                                      //style: appButtonTheme.infoText,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        kTextPadding),
                                                            child: Icon(Icons
                                                                .create_new_folder),
                                                          ),
                                                          // Text('Create'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            // _visibility7,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: kDefaultPadding),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardBody(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(" Fee Detail ",
                                                      textAlign:
                                                          TextAlign.start),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Session:  ${studentDataFee.isNotEmpty ? studentDataFee[0]["sessionYear"] : ""} ",
                                                      textAlign: TextAlign.end),
                                                ]),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _visibility8 = !_visibility8;
                                                  total =
                                                      submitFeeDataFromApi.fold(
                                                          0,
                                                          (sum, item) => sum +
                                                                  item["amount"]
                                                              as int);
                                                });
                                              },
                                              //style: appButtonTheme.infoText,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right:
                                                                kTextPadding),
                                                    child: _visibility8
                                                        ? const Icon(Icons
                                                            .keyboard_arrow_up)
                                                        : const Icon(Icons
                                                            .keyboard_arrow_down),
                                                  ),
                                                  //Text('Create'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _visibility8,
                                      child: _visibility7
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 0),
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // CardHeader(
                                                    //   title: lang.recentOrders(2),
                                                    //   showDivider: false,
                                                    // ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final double
                                                              dataTableWidth =
                                                              max(
                                                                  kScreenWidthMd,
                                                                  constraints
                                                                      .maxWidth);

                                                          return Scrollbar(
                                                            controller:
                                                                _dataTableHorizontalScrollController,
                                                            thumbVisibility:
                                                                true,
                                                            trackVisibility:
                                                                true,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              controller:
                                                                  _dataTableHorizontalScrollController,
                                                              child: SizedBox(
                                                                width:
                                                                    dataTableWidth,
                                                                child: Theme(
                                                                  data: themeData
                                                                      .copyWith(
                                                                    cardTheme:
                                                                        appDataTableTheme
                                                                            .cardTheme,
                                                                    dataTableTheme:
                                                                        appDataTableTheme
                                                                            .dataTableThemeData,
                                                                  ),
                                                                  child:
                                                                      DataTable(
                                                                    showCheckboxColumn:
                                                                        false,
                                                                    showBottomBorder:
                                                                        true,
                                                                    columns: const [
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Transaction Id           '),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Description '),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label:
                                                                              Text('Date')),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Amount'),
                                                                          numeric:
                                                                              true),
                                                                      DataColumn(
                                                                          label: Text(
                                                                              'Action               '),
                                                                          numeric:
                                                                              true),
                                                                    ],
                                                                    rows: List.generate(
                                                                        submitFeeDataFromApi
                                                                            .length,
                                                                        (index) {
                                                                      return DataRow
                                                                          .byIndex(
                                                                        index:
                                                                            index,
                                                                        cells: [
                                                                          DataCell(
                                                                              Text('#${submitFeeDataFromApi[index]["transactionId"]}')),
                                                                          DataCell(
                                                                              Text("${submitFeeDataFromApi[index]["decription"]}")),
                                                                          DataCell(
                                                                              Text("${submitFeeDataFromApi[index]["paidAt"]}")),
                                                                          DataCell(
                                                                              Text(
                                                                            "${submitFeeDataFromApi[index]["amount"]}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                          )),
                                                                          DataCell(Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    create();
                                                                                  },
                                                                                  style: appButtonTheme.successText,
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: const [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(right: kTextPadding),
                                                                                        child: Icon(Icons.edit),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ]))
                                                                        ],
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const Text("   "),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          const Text(
                                                              "Total pay amount in Selected Session : "),
                                                          Text("$total"),
                                                        ]),
                                                    const Text(""),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          const Text(
                                                              "               Total Fee in Selected Session : "),
                                                          Text(
                                                              " ${studentDataFee[0]["totalAmount"]}"),
                                                        ]),

                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              create();
                                                            },
                                                            style:
                                                                appButtonTheme
                                                                    .infoText,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: const [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              kTextPadding),
                                                                  child: Icon(
                                                                      Icons
                                                                          .print),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() =>
                                                                  _visibility5 =
                                                                      false);
                                                              showOptionsDialog2(
                                                                  context);
                                                            },
                                                            style: appButtonTheme
                                                                .primaryText,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: const [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              kTextPadding),
                                                                  child: Icon(Icons
                                                                      .payments_outlined),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ])
                                                  ],
                                                ),
                                              ),
                                            )
                                          : CardBody(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        "No Submitted Fees Data Available ",
                                                        textAlign:
                                                            TextAlign.start),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() =>
                                                            _visibility5 =
                                                                false);
                                                        showOptionsDialog2(
                                                            context);
                                                      },
                                                      style: appButtonTheme
                                                          .primaryText,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        kTextPadding),
                                                            child: Icon(Icons
                                                                .payments_outlined),
                                                          ),
                                                          Text(""),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ), //it's for when data available in selected session
                        ],
                      ), // Widget for the second card
                    ),
                  ),
                ),
              ),
            ],
            if (selectedButtonIndex == 3) ...[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: kDefaultPadding,
                                runSpacing: kDefaultPadding,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text("Student Document"),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 40.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding),
                                          child: SizedBox(
                                            height: 40.0,
                                            child: IconButton(
                                                color: Colors.cyan,
                                                icon: const Icon(
                                                    Icons.print_sharp),
                                                tooltip: 'Print',
                                                onPressed: () async {
                                                  if (clickFiles["fileType"] ==
                                                          'xlsx' ||
                                                      clickFiles["fileType"] ==
                                                          'pdf') {
                                                    await Printing.layoutPdf(
                                                        onLayout: (PdfPageFormat
                                                                format) async =>
                                                            clickFiles[
                                                                'fileBytes']);
                                                  }

                                                  if (clickFiles["fileType"] == 'jpg' ||
                                                      clickFiles["fileType"] ==
                                                          'png' ||
                                                      clickFiles["fileType"] ==
                                                          'JPG') {
                                                    final doc = pw.Document();
                                                    doc.addPage(pw.Page(
                                                        pageFormat:
                                                            PdfPageFormat.a4,
                                                        build: (pw.Context
                                                            context) {
                                                          return pw.Center(
                                                            child: pw.Text(
                                                                'Hello World'),
                                                          ); // Center
                                                        }));

                                                    // PdfPreview(
                                                    //   build: (format) => doc.save(),
                                                    // );
                                                    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async =>clickFiles['fileBytes']);

                                                  }

                                                  // if (clickFiles["fileType"] == 'pdf') {
                                                  //   final blob = html.Blob([
                                                  //     clickFiles['fileContent']!
                                                  //         .codeUnits
                                                  //   ]);
                                                  //   final url = html.Url
                                                  //       .createObjectUrlFromBlob(
                                                  //       blob);
                                                  //   final anchor =
                                                  //   html.AnchorElement(
                                                  //       href: url)
                                                  //     ..setAttribute(
                                                  //         'download',
                                                  //         clickFiles[
                                                  //         'fileName']!)
                                                  //     ..click();
                                                  //   html.Url.revokeObjectUrl(
                                                  //       url);
                                                  // }
                                                  // if (clickFiles["fileType"] ==
                                                  //     'docx') {
                                                  //   final blob = html.Blob([
                                                  //     clickFiles['fileContent']!
                                                  //         .codeUnits
                                                  //   ]);
                                                  //   final url = html.Url
                                                  //       .createObjectUrlFromBlob(
                                                  //       blob);
                                                  //   final anchor =
                                                  //   html.AnchorElement(
                                                  //       href: url)
                                                  //     ..setAttribute(
                                                  //         'download',
                                                  //         clickFiles[
                                                  //         'fileName']!)
                                                  //     ..click();
                                                  //   html.Url.revokeObjectUrl(
                                                  //       url);
                                                  // }
                                                  // if (clickFiles["fileType"] == 'jpg' ||
                                                  //     clickFiles["fileType"] ==
                                                  //         'png' ||
                                                  //     clickFiles["fileType"] ==
                                                  //         'JPG') {
                                                  //   final blob = html.Blob([
                                                  //     Uint8List.fromList(
                                                  //         clickFiles[
                                                  //         'fileContent']
                                                  //             .codeUnits)
                                                  //   ], 'image/jpeg');
                                                  //   final url = html.Url
                                                  //       .createObjectUrlFromBlob(
                                                  //       blob);
                                                  //   final anchor =
                                                  //   html.AnchorElement(
                                                  //       href: url)
                                                  //     ..setAttribute(
                                                  //         'download',
                                                  //         clickFiles[
                                                  //         'fileName']!)
                                                  //     ..click();
                                                  //   html.Url.revokeObjectUrl(
                                                  //       url);
                                                  // }
                                                }),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding),
                                          child: SizedBox(
                                            height: 40.0,
                                            child: IconButton(
                                                color: Colors.green,
                                                icon:
                                                    const Icon(Icons.download),
                                                tooltip: 'Download',
                                                onPressed: () {
                                                  if (clickFiles["fileType"] ==
                                                      'xlsx') {
                                                    final encodedContent =
                                                        base64.encode(clickFiles[
                                                                'fileContent']!
                                                            .codeUnits);
                                                    final dataUri =
                                                        'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$encodedContent';
                                                    html.window.open(
                                                        dataUri, '_blank');
                                                  }
                                                  if (clickFiles["fileType"] ==
                                                      'pdf') {
                                                    final blob = html.Blob([
                                                      clickFiles['fileContent']!
                                                          .codeUnits
                                                    ]);
                                                    final url = html.Url
                                                        .createObjectUrlFromBlob(
                                                            blob);
                                                    final anchor =
                                                        html.AnchorElement(
                                                            href: url)
                                                          ..setAttribute(
                                                              'download',
                                                              clickFiles[
                                                                  'fileName']!)
                                                          ..click();
                                                    html.Url.revokeObjectUrl(
                                                        url);
                                                  }
                                                  if (clickFiles["fileType"] ==
                                                      'docx') {
                                                    final blob = html.Blob([
                                                      clickFiles['fileContent']!
                                                          .codeUnits
                                                    ]);
                                                    final url = html.Url
                                                        .createObjectUrlFromBlob(
                                                            blob);
                                                    final anchor =
                                                        html.AnchorElement(
                                                            href: url)
                                                          ..setAttribute(
                                                              'download',
                                                              clickFiles[
                                                                  'fileName']!)
                                                          ..click();
                                                    html.Url.revokeObjectUrl(
                                                        url);
                                                  }
                                                  if (clickFiles["fileType"] == 'jpg' ||
                                                      clickFiles["fileType"] ==
                                                          'png' ||
                                                      clickFiles["fileType"] ==
                                                          'JPG') {
                                                    final blob = html.Blob([
                                                      Uint8List.fromList(
                                                          clickFiles[
                                                                  'fileContent']
                                                              .codeUnits)
                                                    ], 'image/jpeg');
                                                    final url = html.Url
                                                        .createObjectUrlFromBlob(
                                                            blob);
                                                    final anchor =
                                                        html.AnchorElement(
                                                            href: url)
                                                          ..setAttribute(
                                                              'download',
                                                              clickFiles[
                                                                  'fileName']!)
                                                          ..click();
                                                    html.Url.revokeObjectUrl(
                                                        url);
                                                  }
                                                }),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding),
                                          child: SizedBox(
                                            height: 40.0,
                                            child: IconButton(
                                                color: Colors.red,
                                                icon: const Icon(Icons.delete),
                                                tooltip: 'Delete Selected',
                                                onPressed: () => {}
                                                //GoRouter.of(context).go(RouteUri.crudDetail),
                                                ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: kDefaultPadding),
                                          child: SizedBox(
                                            height: 40.0,
                                            child: IconButton(
                                                color: Colors.blueAccent,
                                                icon: const Icon(
                                                    Icons.add_circle_outline),
                                                tooltip: 'Add New Document',
                                                onPressed: () => openImages()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          selectedFiles.isNotEmpty
                              ? SizedBox(
                                  height:
                                      100, // Adjust the height of the grid view
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, // Enable horizontal scrolling
                                    child: Row(
                                      children: List.generate(
                                        selectedFiles.length,
                                        (index) {
                                          final fileData = selectedFiles[index];
                                          final fileType = fileData['fileType'];
                                          final fileContent =
                                              fileData['fileContent'];
                                          final fileName = fileData['fileName'];
                                          final truncatedFileName = fileName !=
                                                      null &&
                                                  fileName.length > 10
                                              ? '${fileName.substring(0, 10)}...'
                                              : fileName;
                                          Widget fileWidget;
                                          if (fileType == 'jpg' ||
                                              fileType == 'png' ||
                                              fileType == 'JPG') {
                                            fileWidget = OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  clickFiles = fileData;
                                                });
                                              },
                                              style: clickFiles == fileData
                                                  ? appButtonTheme
                                                      .primaryOutlined
                                                  : appButtonTheme
                                                      .secondaryOutlined,
                                              child: Image.memory(
                                                Uint8List.fromList(
                                                    fileContent!.codeUnits),
                                                fit: BoxFit.cover,
                                                width: 50, // Adjust image width
                                                height:
                                                    50, // Adjust image height
                                              ),
                                            );
                                          } else if (fileType == 'pdf') {
                                            fileWidget = OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    clickFiles = fileData;
                                                  });
                                                },
                                                style: clickFiles == fileData
                                                    ? appButtonTheme
                                                        .primaryOutlined
                                                    : appButtonTheme
                                                        .secondaryOutlined,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  width:
                                                      50, // Adjust icon width
                                                  height:
                                                      50, // Adjust icon height
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.picture_as_pdf,
                                                      size:
                                                          45, // Decrease PDF icon size
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ));
                                          } else if (fileType == 'docx') {
                                            fileWidget = OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    clickFiles = fileData;
                                                  });
                                                },
                                                style: clickFiles == fileData
                                                    ? appButtonTheme
                                                        .primaryOutlined
                                                    : appButtonTheme
                                                        .secondaryOutlined,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  width:
                                                      50, // Adjust icon width
                                                  height:
                                                      50, // Adjust icon height
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.description,
                                                      size: 45, // Icon size
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ));
                                          } else if (fileType == 'xlsx') {
                                            fileWidget = OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    clickFiles = fileData;
                                                  });
                                                },
                                                style: clickFiles == fileData
                                                    ? appButtonTheme
                                                        .primaryOutlined
                                                    : appButtonTheme
                                                        .secondaryOutlined,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  width:
                                                      50, // Adjust icon width
                                                  height:
                                                      50, // Adjust icon height
                                                  child: Center(
                                                    child: SvgPicture.string(
                                                      '''<?xml version="1.0" ?><!DOCTYPE svg  PUBLIC '-//W3C//DTD SVG 1.1//EN'  'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'><svg enable-background="new 0 0 0 0" height="30px" id="Layer_1" version="1.1" viewBox="0 0 30 30" width="30px" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path clip-rule="evenodd" d="M28.705,7.506l-5.461-6.333l-1.08-1.254H9.262   c-1.732,0-3.133,1.403-3.133,3.136V7.04h1.942L8.07,3.818c0.002-0.975,0.786-1.764,1.758-1.764l11.034-0.01v5.228   c0.002,1.947,1.575,3.523,3.524,3.523h3.819l-0.188,15.081c-0.003,0.97-0.79,1.753-1.759,1.761l-16.57-0.008   c-0.887,0-1.601-0.87-1.605-1.942v-1.277H6.138v1.904c0,1.912,1.282,3.468,2.856,3.468l17.831-0.004   c1.732,0,3.137-1.41,3.137-3.139V8.966L28.705,7.506" fill="black" fill-rule="evenodd"/><path d="M20.223,25.382H0V6.068h20.223V25.382 M1.943,23.438h16.333V8.012H1.943" fill="green"/><polyline fill="green" points="15.73,20.822 12.325,20.822 10.001,17.538 7.561,20.822 4.14,20.822 8.384,15.486 4.957,10.817    8.412,10.817 10.016,13.355 11.726,10.817 15.242,10.817 11.649,15.486 15.73,20.822  "/></g></svg>''',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ));
                                          } else {
                                            fileWidget = Text(
                                              'File: $truncatedFileName, Type: $fileType\nContent: $fileContent',
                                            );
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              if (fileType == 'jpg' ||
                                                  fileType == 'png' ||
                                                  fileType == 'JPG') {
                                                // Open the image in a larger size or perform other actions here
                                                print(
                                                    'Image clicked: $fileName');
                                                // You can open the image in a larger size or perform any other action here
                                              }
                                            },
                                            child: Tooltip(
                                              message: fileName ?? '',
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Column(
                                                  children: [
                                                    Expanded(child: fileWidget),
                                                    Text(
                                                      truncatedFileName ?? '',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 100,
                                  child: Center(
                                      child:
                                          Text("No Uploaded File Available ")),
                                ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 350,
                            child: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround, // Center the icons horizontally
                                children: [
                                  if (clickFiles.isNotEmpty)
                                    IconButton(
                                      onPressed: () {
                                        nextImage(0);
                                      },
                                      icon: const Icon(Icons.arrow_back_ios),
                                    ),
                                  if (clickFiles["fileType"] == 'png' ||
                                      clickFiles["fileType"] == 'JPG')
                                    Center(
                                      child: Image.memory(
                                        Uint8List.fromList(
                                            clickFiles['fileContent']
                                                .codeUnits),
                                        fit: BoxFit.cover,
                                        width: 250, // Adjust image width
                                        height: 300, // Adjust image height
                                      ),
                                    ),
                                  if (clickFiles["fileType"] == 'pdf')
                                    Center(
                                      child: Container(
                                        color: Colors.grey[200],
                                        width: 250, // Adjust icon width
                                        height: 300, // Adjust icon height
                                        child: const Center(
                                          child: Icon(
                                            Icons.picture_as_pdf,
                                            size: 220, // Decrease PDF icon size
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (clickFiles["fileType"] == 'docx')
                                    Center(
                                      child: Container(
                                        color: Colors.grey[200],
                                        width: 250, // Adjust icon width
                                        height: 300, // Adjust icon height
                                        child: const Center(
                                          child: Icon(
                                            Icons.description,
                                            size: 220, // Icon size
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (clickFiles["fileType"] == 'xlsx')
                                    Center(
                                      child: Container(
                                        color: Colors.grey[200],
                                        width: 280, // Adjust icon width
                                        height: 300, // Adjust icon height
                                        child: Center(
                                          child: SvgPicture.string(
                                            '''<?xml version="1.0" ?><!DOCTYPE svg  PUBLIC '-//W3C//DTD SVG 1.1//EN'  'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'><svg enable-background="new 0 0 0 0" height="30px" id="Layer_1" version="1.1" viewBox="0 0 30 30" width="30px" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path clip-rule="evenodd" d="M28.705,7.506l-5.461-6.333l-1.08-1.254H9.262   c-1.732,0-3.133,1.403-3.133,3.136V7.04h1.942L8.07,3.818c0.002-0.975,0.786-1.764,1.758-1.764l11.034-0.01v5.228   c0.002,1.947,1.575,3.523,3.524,3.523h3.819l-0.188,15.081c-0.003,0.97-0.79,1.753-1.759,1.761l-16.57-0.008   c-0.887,0-1.601-0.87-1.605-1.942v-1.277H6.138v1.904c0,1.912,1.282,3.468,2.856,3.468l17.831-0.004   c1.732,0,3.137-1.41,3.137-3.139V8.966L28.705,7.506" fill="black" fill-rule="evenodd"/><path d="M20.223,25.382H0V6.068h20.223V25.382 M1.943,23.438h16.333V8.012H1.943" fill="green"/><polyline fill="green" points="15.73,20.822 12.325,20.822 10.001,17.538 7.561,20.822 4.14,20.822 8.384,15.486 4.957,10.817    8.412,10.817 10.016,13.355 11.726,10.817 15.242,10.817 11.649,15.486 15.73,20.822  "/></g></svg>''',
                                            width: 200,
                                            height: 280,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (clickFiles.isNotEmpty)
                                    IconButton(
                                      onPressed: () {
                                        nextImage(1);
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios),
                                    )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          // SizedBox(
                          //   height: 40.0,
                          //   width: 120.0,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       _printScreen();
                          //     },
                          //     style: appButtonTheme.infoText,
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: const [
                          //         Padding(
                          //           padding: EdgeInsets.only(
                          //               right: kTextPadding),
                          //           child: Icon(Icons.print_rounded),
                          //         ),
                          //         Text('Print'),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // ... Other sections or cards
          ],
        ),
      ),
    );
  }

  create() {
    setState(() => _visibility1 = true);
    setState(() => _visibility2 = false);
    setState(() => _visibility3 = false);
    setState(() => _visibility4 = false);
  }

  discountAmount(value, selectedDataState) {
    selectedData["disscount"] = value;
    if (value != "") {
      setState(
          () => discountAmountVar = (selectedDataState - double.parse(value!)));
    } else {
      setState(() => discountAmountVar = selectedDataState);
    }
  }

  setData(jsonDecode) {
    jsonDecode.map((e) => stuData.add(e)).toList();
  }

  selectSession(session2) async {
    setState(() => _currentSession = session2.toString());
    Future<Response> response = getStudentProfileDetails(session2);
    Future<Response> response2 = getFeeDetails(session2);
    await Future.delayed(const Duration(seconds: 1), () {
      response.then((value) => {
            studentDataFee = jsonDecode(value.body),
            if (studentDataFee.isNotEmpty)
              {
                setState(() => studentDataFee = studentDataFee),
                setState(() =>
                    selectedElement = studentDataFee[0]["feesModifiedElement"]),
                setState(() => discountAmountVar = (studentDataFee[0]
                        ["totalAmount"] -
                    studentDataFee[0]["disscount"])),
                setState(() => _visibility1 = false),
                setState(() => _visibility2 = false),
                setState(() => _visibility3 = false),
                setState(() => _visibility4 = true),
              }
            else
              {
                setState(() => selectedElement = []),
                setState(() => discountAmountVar = 0),
                setState(() => _visibility1 = false),
                setState(() => _visibility2 = false),
                setState(() => _visibility4 = false),
                setState(() => _visibility3 = true),
              },
          });
    });
    await Future.delayed(const Duration(seconds: 1), () {
      response2.then((value2) => {
            submitFeeDataFromApi = jsonDecode(value2.body),
            if (submitFeeDataFromApi.isNotEmpty)
              {
                // print(submitFeeDataFromApi),
                setState(() => _visibility7 = true),
              }
            else
              {
                setState(() => _visibility7 = false),
              }
          });
    });
    // print(submitFeeDataFromApi);
  }

  remove(BuildContext context) {
    // print("click on remove bottom");
  }

  selectStructure(structreId) async {
    setState(() => selectedElement = structreId["feesModifiedElement"]);
    setState(() => selectedData = structreId);
    setState(() => _visibility2 = true);
    setState(() => _visibility3 = false);
    setState(() => _visibility4 = false);
    setState(() => _visibility1 = true);
  }

  saveData(BuildContext context) {
    var sId = selectedData["id"];
    selectedData["sturctureId"] = sId;
    selectedData["studentId"] = widget.id;
    selectedData["sessionYear"] = _currentSession;
    selectedData.remove('id');
    var obj1 = [];
    var feesModifiedElementArr = [];
    feesModifiedElementArr = selectedData["feesModifiedElement"];
    for (int i = 0; i < feesModifiedElementArr.length; i++) {
      var obj = feesModifiedElementArr[i];
      obj.remove('id');
      obj1.add(obj);
    }
    selectedData["feesModifiedElement"] = obj1;
    _doSave(context);
  }

  Future<void> saveFee() async {
    var data = {};
    var localDate = sbmittedFeeData["date"] ?? currentDate;
    var paymentMode = sbmittedFeeData["paymentMode"] ?? ["Case"];
    var amount = sbmittedFeeData["amount"] ?? "0";
    var decription = sbmittedFeeData["decription"];
    // amount = amount ?? 0;
    decription = decription ?? '';
    paymentMode = paymentMode.join(",");
    localDate = localDate.toString();
    List<String> trId = localDate.split("-");
    var localDate2 = trId.join("");
    trId = localDate2.split(":");
    localDate2 = trId.join("");
    trId = localDate2.split(".");
    localDate2 = trId.join("");
    trId = localDate2.split(" ");
    localDate2 = trId.join("");
    data["amount"] = amount;
    data["paymentMode"] = paymentMode;
    data["decription"] = decription;
    data["transactionId"] = localDate2;
    data["session"] = _currentSession;
    data["studentId"] = _formData.id;
    data["paidAt"] = localDate;
    if (int.parse(amount) > 0) {
      var res = await profileApiService.submitFee(data);
      print(res?.statusCode);
      if (res?.statusCode == 201) {
        _showDialog2(context, DialogType.SUCCES, data);
      } else {}
    } else {
      setState(() => _visibility5 = true);
      Navigator.pop(context);
      showOptionsDialog2(context);
    }
  }

  void setSession() {
    // DateTime currentDate = DateTime.now();
    var arr = [
      '2015-2016',
      '2016-2017',
      '2017-2018',
      '2018-2019',
      '2019-2020',
      '2020-2021',
      '2021-2022',
      '2022-2023',
    ];
    final foundPeople = arr.where(
        (element) => element == "${currentDate.year - 1}-${currentDate.year}");
    // var condition =
    //     arr.map((e) => return( "${currentDate.year}-${currentDate.year + 1}"));
    // print(foundPeople);
    if (foundPeople.isEmpty) {
      arr.add("${currentDate.year - 1}-${currentDate.year}");
    }
    // print(arr);
    setState(() {
      dropdowonOption = arr;
    });
  }

  void nextImage(int i) {
    int index = selectedFiles.indexWhere((file) =>
        file["fileName"] == clickFiles["fileName"] &&
        file["fileContent"] == clickFiles["fileContent"] &&
        file["fileType"] == clickFiles["fileType"]);
    if (i == 0) {
      var indx = index - 1;
      if (indx != -1) {
        setState(() {
          clickFiles = selectedFiles[indx];
        });
      }
    }
    if (i == 1) {
      var indx1 = index + 1;
      if (indx1 < selectedFiles.length) {
        setState(() {
          clickFiles = selectedFiles[indx1];
        });
      }
    }
  }
}

class FormData2 {
  String tid = '';
  String amount = '';
  String date = '';
  String session = '';
  String studentId = '';
  String paymentMode = '';
  String decription = '';
  Map<String, dynamic> toJson() => {
        "id": tid,
        "amount": amount,
        "studentId": studentId,
        "paymentMode": paymentMode,
        "decription": decription,
        "session": decription,
        "date": date
      };
}

class FormData {
  String id = '';
  String rollNumber = '';
  String father_name = '';
  String mother_name = '';
  String aadhar_number = '';
  String student_name = '';
  String samgara_id = '';
  String family_id = '';
  String gender = '';
  String medium = '';
  String classes = '';
  Object subject = {};
  String dob = '';
  String mobile_number = '';
  String mobile_number2 = '';
  String email_id = '';
  String bank_name = '';
  String account_holder_name = '';
  String account_number = '';
  String ifsc_code = '';
  String address = '';
  Map<String, dynamic> toJson() => {
        "firstName": student_name,
        'fatherName': father_name,
        'motherName': mother_name,
        'aadharNumber': aadhar_number,
        'samagraId': samgara_id,
        'familyId': family_id,
        'gender': gender,
        'medium': medium,
        'classes': classes,
        'subjects': subject,
        'dob': dob.toString(),
        'mobileNumber': mobile_number,
        'parentMobileNumber': mobile_number2,
        'email': email_id,
        'bankName': bank_name,
        'accountHolderName': account_holder_name,
        'accountNumber': account_number,
        'ifscCode': ifsc_code,
        'address': address,
      };
}

// class PdfThumbnail extends StatelessWidget {
//   final pdfPath; // Path to the PDF file
//
//   PdfThumbnail(this.pdfPath);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100, // Set a specific height
//       width: 100, // Set a specific width
//       child: SfPdfViewer.file(
//         // Display PDF from file path
//         pdfPath,
//       ),
//     );
//   }
// }
