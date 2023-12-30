import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:school_master_erp/services/fees_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/subject_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

class AddSubjectScreen extends StatefulWidget {
  final String id;

  const AddSubjectScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  bool Element_filed = false;
  final SubjectApiService _subjectApiService = SubjectApiService();

  _getDataAsync(String? value) async {
    if (value == "Other") {
      Element_filed = true;
      GoRouter.of(context).go(RouteUri.crudDetail);
    } else {
      Element_filed = false;
      GoRouter.of(context).go(RouteUri.crudDetail);
    }
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
                print(_formData.toJson());
                var res =
                    await _subjectApiService.addSubjectApi(_formData.toJson());
                print(res?.statusCode);
                if (res?.statusCode == 201) {
                  GoRouter.of(context).go(RouteUri.subject_screen);
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
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.subject_screen),
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
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.subject_screen,
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
                    title: "Add Subject",
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
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: FormBuilderTextField(
              name: 'Subject_Name',
              decoration: const InputDecoration(
                labelText: ' Subject Name ',
                hintText: 'Subject Name',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              //initialValue: _formData.item,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.subjetName = value ?? ''),
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
                        name: 'Subject Type',
                        orientation: OptionsOrientation.vertical,
                        decoration: const InputDecoration(
                          labelText: 'Subject Type',
                          border: OutlineInputBorder(),
                        ),
                        // initialValue: _formData.gender,
                        options: const [
                          FormBuilderFieldOption(
                              value: 'THEORY', child: Text('Theory Subject')),
                          FormBuilderFieldOption(
                              value: 'PRACTICAL',
                              child: Text('Practical Subject')),
                          FormBuilderFieldOption(
                              value: 'OTHER', child: Text('Other Subject')),
                        ],
                        onSaved: (value) =>
                            (_formData.subjectType = value ?? ''),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    SizedBox(
                      width: ((constraints.maxWidth * 0.5) -
                          (kDefaultPadding * 0.5)),
                      // child:
                      // FormBuilderRadioGroup(
                      //   name: 'medium',
                      //   wrapSpacing: kDefaultPadding,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Medium',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   // initialValue: _formData.medium,
                      //   options: const [
                      //     FormBuilderFieldOption(
                      //         value: 'English', child: Text('English')),
                      //     FormBuilderFieldOption(
                      //         value: 'Hindi', child: Text('Hindi')),
                      //     // FormBuilderFieldOption(value: 'Item 3', child: Text('Item 3')),
                      //     // FormBuilderFieldOption(value: 'Item 4', child: Text('Item 4')),
                      //     // FormBuilderFieldOption(value: 'Item 5', child: Text('Item 5')),
                      //   ],
                      //   // onSaved: (value) => (_formData.medium = value ?? ''),
                      // ),
                    ),
                  ],
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
                      GoRouter.of(context).go(RouteUri.subject_screen),
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
  String subjetName = '';
  String subjectType = '';
  Map<String, dynamic> toJson() => {
        "name": subjetName,
        'subjectType': subjectType,
      };
}
