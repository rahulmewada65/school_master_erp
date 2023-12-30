import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:school_master_erp/services/fees_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/class_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../theme/theme_extensions/app_color_scheme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';



class AddExamScreen extends StatefulWidget {
  final String id;

  const AddExamScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  var subjectList1;
  var element = [];
  List res = [];
  // final FeesApiService _feesApiService = FeesApiService();
  final SubjectApiService apiService = SubjectApiService();
  final ClassApiService apiClassService = ClassApiService();
  _getDataAsync() async {
    final response = await apiService.getSubjectList();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["rows"];
      // var result1 = data["subjectType"];
      List<FormBuilderChipOption<Object?>> optionElement1 = [];
      for (var value in data) {
        optionElement1.add(FormBuilderChipOption(
            value: value,
            child: Text(value["name"].isNotEmpty
                ? value["name"] + " - " + value["subjectType"]
                : "")));
      }

      setState(() {
        subjectList1 = optionElement1;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getDataAsync();
  }

  void _doSubmit(BuildContext context) {
    AppFocusHelper.instance.requestUnfocus();
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final lang = Lang.of(context);
      final dialog = AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        title: lang.confirmSubmitRecord,
        width: kDialogWidth,
        btnOkText: lang.yes,
        btnOkOnPress: () {
          final d = AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              title: lang.recordSubmittedSuccessfully,
              width: kDialogWidth,
              btnOkText: 'OK',
              btnOkOnPress: () async {
                // var obj = ;
                _formKey.currentState!.save();
                // print(_formData.toJson());
                var res = await apiClassService.addExamApi(_formData.toJson());
                 print(res?.statusCode);
                if (res?.statusCode == 201) {
                  GoRouter.of(context).go(RouteUri.exam_screen);
                }
              } //
          );
          d.show();
        },
        btnCancelText: lang.cancel,
        btnCancelOnPress: () {},
      );
      dialog.show();
    }
  }

  void _doDelete(BuildContext context) {
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
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.exam_screen),
        );

        d.show();
      },
      btnCancelText: lang.cancel,
      btnCancelOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    // final lang = Lang.of(context);
    // final themeData = Theme.of(context);
    // final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.exam_screen,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: "Add Class",
                  ),
                  CardBody(
                    child: _content(context),
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

    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: FormBuilderTextField(
              name: 'Exam_Name',
              decoration: const InputDecoration(
                labelText: 'Exam Name',
                hintText: 'Exam Name',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              //initialValue: _formData.item,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.name = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return  FormBuilderRadioGroup(
                        name: 'Exam_Type',
                        wrapSpacing: kDefaultPadding,
                        decoration: const InputDecoration(
                          labelText: 'Exam Type',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _formData.type,
                        options: const [
                          FormBuilderFieldOption(
                              value: 'ONLINE', child: Text('Online')),
                          FormBuilderFieldOption(
                              value: 'OFFLINE', child: Text('Offline')),
                        ],
                        onSaved: (value) => (_formData.type = value ?? ''),
                      );
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  style:
                  themeData.extension<AppButtonTheme>()!.secondaryElevated,
                  onPressed: () =>
                      GoRouter.of(context).go(RouteUri.exam_screen),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(right: kDefaultPadding * 0.5),
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          size: (themeData.textTheme.button!.fontSize! + 4.0),
                        ),
                      ),
                      Text(lang.crudBack),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: widget.id.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(right: kDefaultPadding),
                  child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style:
                      themeData.extension<AppButtonTheme>()!.errorElevated,
                      onPressed: () => _doDelete(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: kDefaultPadding * 0.5),
                            child: Icon(
                              Icons.delete_rounded,
                              size:
                              (themeData.textTheme.button!.fontSize! + 4.0),
                            ),
                          ),
                          Text(lang.crudDelete),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  style: themeData.extension<AppButtonTheme>()!.successElevated,
                  onPressed: () => _doSubmit(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(right: kDefaultPadding * 0.5),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: (themeData.textTheme.button!.fontSize! + 4.0),
                        ),
                      ),
                      Text(lang.submit),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FormData {
  String name = '';
  String type = '';
  List examSubjectDetails = [];

  Map<String, dynamic> toJson() => {
    "name": name,
    'examType': type,
    "examSubjectDetails":examSubjectDetails
  };
}