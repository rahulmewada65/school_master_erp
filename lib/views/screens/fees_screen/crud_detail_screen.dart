import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:school_master_erp/services/fees_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

class CrudDetailScreen extends StatefulWidget {
  final String id;

  const CrudDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CrudDetailScreen> createState() => _CrudDetailScreenState();
}

class _CrudDetailScreenState extends State<CrudDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  bool elementFiled = false;
  final FeesApiService _feesApiService = FeesApiService();

  _getDataAsync(String? value) async {
    if (value == "Other") {
      elementFiled = true;
      GoRouter.of(context).go(RouteUri.crudDetail);
    } else {
      elementFiled = false;
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
                var res =
                    await _feesApiService.addFeesElement(_formData.toJson());
                // print(res?.statusCode);
                if (res?.statusCode == 201) {
                  GoRouter.of(context).go(RouteUri.feeScreen);
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
          btnOkOnPress: () => GoRouter.of(context).go(RouteUri.feeScreen),
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
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.feeScreen,
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
                    title: "pageTitle",
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
                allowClear: true,
                focusColor: Colors.transparent,
                //hint: const Text('Select Class'),
                validator: FormBuilderValidators.required(),
                items: [
                  'No Select',
                  'Nursery',
                  'LKG',
                  'UKG',
                  'Class-1',
                  'Class-2',
                  'Class-3',
                  'Class-4',
                  'Class-5',
                  'Class-6',
                  'Class-7',
                  'Class-8',
                  'Class-9',
                  'Class-10',
                  'Class-11',
                  'Class-12',
                  'Other',
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => {_getDataAsync(value)},
                onSaved: (value) => (_formData.classes = value ?? ''),
              ),
            ),
          ),
          Visibility(
            visible: elementFiled,
            child: Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
              child: FormBuilderTextField(
                name: 'Element_Name',
                decoration: const InputDecoration(
                  labelText: 'Element Name ',
                  hintText: 'Item',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                //initialValue: _formData.item,
                validator: FormBuilderValidators.required(),
                onSaved: (value) => (_formData.element = value ?? ''),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
            child: FormBuilderTextField(
              name: 'Amount',
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'Price',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              //initialValue: _formData.price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.amount = value ?? ''),
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
                  onPressed: () => GoRouter.of(context).go(RouteUri.feeScreen),
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
  String classes = '';
  String element = '';
  String amount = '';
  Map<String, dynamic> toJson() => {
        "name": classes,
        'otherName': element,
        'amount': amount,
      };
}
