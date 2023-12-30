// import 'dart:convert';
// import 'dart:html';
// import 'dart:js';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import '../../../app_router.dart';
// import '../../../constants/dimens.dart';
// import '../../../generated/l10n.dart';
// import '../../../services/fees_api_service.dart';
// import '../../../theme/theme_extensions/app_button_theme.dart';
// import '../../../theme/theme_extensions/app_color_scheme.dart';
// import '../../widgets/card_elements.dart';
// import '../../widgets/hover_container.dart';
// import '../../widgets/portal_master_layout/portal_master_layout.dart';
// import '../../widgets/text_with_copy_button.dart';
// import '../../widgets/url_new_tab_launcher.dart';

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/fees_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../theme/theme_extensions/app_color_scheme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';

// class CreateStructure extends StatefulWidget {
//   const CreateStructure({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _createStructure();
//   }
// }
class CreateStructure extends StatefulWidget {
  const CreateStructure({Key? key}) : super(key: key);

  @override
  _CreateStructureState createState() => _CreateStructureState();
}

class _CreateStructureState extends State<CreateStructure> {
  late final List<Object> _products = [];
  final _formKey = GlobalKey<FormBuilderState>();
  final FeesApiService apiService = FeesApiService();
  final _formData = FormData();
  Future<bool>? _future;
  var feesElementData={};
  List<FormBuilderChipOption<Object?>> optionElement = [];
  List<Object?>? g;
  List<Object?>? id;
  List? tags;
  var amount = [];
  double totalScores = 0.0;

  @override
  void initState() {
    super.initState();
    //_products.add("No Element Selected");
  }

  @override
  void dispose() {
    super.dispose();
    _products.removeLast();
  }

  Future<bool> _getDataAsync() async {
    Future<Response> response = getAllFeesElement();
    await Future.delayed(const Duration(seconds: 1), () {
      response.then((value) => {
            // print( jsonDecode( value.body)),
        feesElementData = jsonDecode(value.body),
            setState(() {
              feesElementData = jsonDecode(value.body);
            })
          });
    });
    return true;
  }

  Future<Response> getAllFeesElement() async {
    var response = await apiService.getFeesElementList2();
    return response;
  }

  Future<void> _doSubmit(
      BuildContext context, double totalScores, List<Object?>? g) async {
    AppFocusHelper.instance.requestUnfocus();
    //_formKey.currentState!.save();
    Map<String, dynamic> json = _formData.toJson();
    // print(_formData.toJson());
    // print(totalScores);
    // print(g);

    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();
      // print(_formData.toJson());
      // var res = await apiService.addStudent();
    }
    final lang = Lang.of(context);
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      title: g!.isEmpty ? '' : lang.confirmSubmitRecord,
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
              var res = await apiService.addFeesStucture(json);
              // print(res?.statusCode);
              if (res?.statusCode == 201) {
                ///  GoRouter.of(context).go(RouteUri.fee_screen);
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

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    // final textTheme = themeData.textTheme;
    return PortalMasterLayout(
      //selectedMenuUri: RouteUri.crud,
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
                  CardBody(
                    child: FutureBuilder<bool>(
                      initialData: null,
                      future: (_future ??= _getDataAsync()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          if (snapshot.hasData && snapshot.data!) {
                            // final totalRows = fees_element_data["totalRows"];
                            // List? item1 = [];
                            List item = feesElementData["rows"];
                            List<FormBuilderChipOption<Object?>> optionElement =
                                [];
                            for (var element in item) {
                              optionElement.add(FormBuilderChipOption(
                                  value: element["id"],
                                  child: Text(element["name"].isNotEmpty
                                      ? element["name"]
                                      : element["otherName"])));
                            }
                            return Column(children: <Widget>[
                              const CardHeader(title: "Select Element"),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CardHeader(title: "Select Element"),
                                      CardBody(
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          spacing: kDefaultPadding * 2.0,
                                          runSpacing: kDefaultPadding * 2.0,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom:
                                                      kDefaultPadding * 0.2),
                                              child: FormBuilderFilterChip(
                                                name: 'subject',
                                                spacing: kDefaultPadding * 0.5,
                                                runSpacing:
                                                    kDefaultPadding * 0.5,
                                                selectedColor:
                                                    appColorScheme.warning,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                ),
                                                //onReset: (value) => value.reset(),
                                                options: optionElement,
                                                onChanged: (value) => {
                                                  g = value,
                                                  setState(() {
                                                    _products.add(value!);
                                                  })
                                                },
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom:
                                                        kDefaultPadding * 2.0),
                                                child: LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 40.0,
                                                            child:
                                                                ElevatedButton(
                                                              style: themeData
                                                                  .extension<
                                                                      AppButtonTheme>()!
                                                                  .secondaryElevated,
                                                              onPressed: () =>
                                                                  GoRouter.of(
                                                                          context)
                                                                      .go(RouteUri
                                                                          .feeScreen),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right: kDefaultPadding *
                                                                            0.5),
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_circle_left_outlined,
                                                                      size: (themeData
                                                                              .textTheme
                                                                              .button!
                                                                              .fontSize! +
                                                                          4.0),
                                                                    ),
                                                                  ),
                                                                  Text(lang
                                                                      .crudBack),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 40.0,
                                                            child:
                                                                ElevatedButton(
                                                              style: themeData
                                                                  .extension<
                                                                      AppButtonTheme>()!
                                                                  .primaryElevated,
                                                              onPressed: () =>
                                                                  {},
                                                              // doSubmit(context),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right: kDefaultPadding *
                                                                            0.5),
                                                                    child: Icon(
                                                                      Icons
                                                                          .add_circle_outline,
                                                                      size: (themeData
                                                                              .textTheme
                                                                              .button!
                                                                              .fontSize! +
                                                                          4.0),
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                      'Add'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ]);
                                                  },
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kDefaultPadding),
                                  child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CardHeader(
                                                title: "Select Element"),
                                            CardBody(
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical:
                                                          kDefaultPadding),
                                                  child: Column(children: const [
                                                    // Products(
                                                    //   _products,
                                                    //   fees_element_data,
                                                    //   g,
                                                    // )
                                                  ])),
                                            )
                                          ])))
                            ]);
                          }
                        } else if (snapshot.hasData && snapshot.data!) {
                          // final totalRows = fees_element_data["totalRows"];
                          // List? item1 = [];
                          List item = feesElementData["rows"];
                          List<FormBuilderChipOption<Object?>> optionElement =
                              [];
                          for (var element in item) {
                            optionElement.add(FormBuilderChipOption(
                                value: element["id"],
                                child: Text(element["name"].isNotEmpty
                                    ? element["name"]
                                    : element["otherName"])));
                          }
                          return Column(children: <Widget>[
                            const CardHeader(title: "Select Element"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPadding),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const CardHeader(title: "Select Element"),
                                    CardBody(
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          spacing: kDefaultPadding * 2.0,
                                          runSpacing: kDefaultPadding * 2.0,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom:
                                                      kDefaultPadding * 0.5),
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: ((constraints
                                                                    .maxWidth *
                                                                0.5) -
                                                            (kDefaultPadding *
                                                                0.5)),
                                                        child:
                                                            FormBuilderTextField(
                                                          name: 'StructureName',
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Structure Name',
                                                            // hintText: '123456789',
                                                            helperText:
                                                                'Mandatory',
                                                            border:
                                                                OutlineInputBorder(),
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .auto,
                                                          ),

                                                          validator:
                                                              FormBuilderValidators
                                                                  .required(),
                                                          onChanged: (value) =>
                                                              (_formData
                                                                      .stactureName =
                                                                  value ?? ''),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              kDefaultPadding),
                                                      SizedBox(
                                                        width: ((constraints
                                                                    .maxWidth *
                                                                0.5) -
                                                            (kDefaultPadding *
                                                                0.5)),
                                                        child:
                                                            FormBuilderTextField(
                                                          name: 'Description',
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Description',
                                                            // hintText: '1234556',
                                                            helperText:
                                                                'Optional',
                                                            border:
                                                                OutlineInputBorder(),
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .auto,
                                                          ),
                                                          //  initialValue:_formData.family_id,
                                                          validator:
                                                              FormBuilderValidators
                                                                  .required(),
                                                          onChanged: (value) =>
                                                              (_formData
                                                                      .description =
                                                                  value ?? ''),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom:
                                                      kDefaultPadding * 0.2),
                                              child: FormBuilderFilterChip(
                                                  name: 'subject',
                                                  spacing:
                                                      kDefaultPadding * 0.5,
                                                  runSpacing:
                                                      kDefaultPadding * 0.5,
                                                  selectedColor:
                                                      appColorScheme.warning,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Select Element',
                                                    helperText: 'Mandatory',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  options: optionElement,
                                                  onChanged: (value) => {
                                                        g = value,
                                                        amount = [],
                                                        totalScores = 0,
                                                        for (var ae in g!)
                                                          {
                                                            for (var l in item)
                                                              {
                                                                if (l['id'] ==
                                                                    ae)
                                                                  {
                                                                    amount.add(l[
                                                                        'amount']),
                                                                  }
                                                              }
                                                          },
                                                        for (var a in amount)
                                                          {
                                                            totalScores += a,
                                                          },
                                                        setState(() {
                                                          _products.add(value!);
                                                        }),
                                                        _formData.totalAmount =
                                                            totalScores
                                                                .toString()
                                                      }),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40.0,
                                                  child: ElevatedButton(
                                                    style: themeData
                                                        .extension<
                                                            AppButtonTheme>()!
                                                        .secondaryElevated,
                                                    onPressed: () => GoRouter
                                                            .of(context)
                                                        .go(RouteUri
                                                            .structure_screen),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              right:
                                                                  kDefaultPadding *
                                                                      0.5),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_circle_left_outlined,
                                                            size: (themeData
                                                                    .textTheme
                                                                    .button!
                                                                    .fontSize! +
                                                                4.0),
                                                          ),
                                                        ),
                                                        Text(lang.crudBack),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  height: 40.0,
                                                  child: ElevatedButton(
                                                    style: themeData
                                                        .extension<
                                                            AppButtonTheme>()!
                                                        .primaryElevated,
                                                    onPressed: () =>
                                                        GoRouter.of(context).go(
                                                            RouteUri
                                                                .crudDetail),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              right:
                                                                  kDefaultPadding *
                                                                      0.5),
                                                          child: Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            size: (themeData
                                                                    .textTheme
                                                                    .button!
                                                                    .fontSize! +
                                                                4.0),
                                                          ),
                                                        ),
                                                        const Text(
                                                            "Add Element"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // SizedBox(
                                            //   height: 40.0,
                                            //   child: ElevatedButton(
                                            //     style: themeData
                                            //         .extension<
                                            //             AppButtonTheme>()!
                                            //         .secondaryElevated,
                                            //     onPressed: () =>
                                            //         GoRouter.of(context).go(
                                            //             RouteUri.structure_screen),
                                            //     child: Row(
                                            //       mainAxisSize:
                                            //           MainAxisSize.min,
                                            //       crossAxisAlignment:
                                            //           CrossAxisAlignment.center,
                                            //       children: [
                                            //         Padding(
                                            //           padding: const EdgeInsets
                                            //                   .only(
                                            //               right:
                                            //                   kDefaultPadding *
                                            //                       0.5),
                                            //           child: Icon(
                                            //             Icons
                                            //                 .arrow_circle_left_outlined,
                                            //             size: (themeData
                                            //                     .textTheme
                                            //                     .button!
                                            //                     .fontSize! +
                                            //                 4.0),
                                            //           ),
                                            //         ),
                                            //         Text(lang.crudBack),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding),
                                child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CardHeader(
                                              title: "Select Element"),
                                          CardBody(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: kDefaultPadding),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .only(
                                                          bottom:
                                                              kDefaultPadding),
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: ((constraints
                                                                            .maxWidth *
                                                                        0.1) -
                                                                    (kDefaultPadding *
                                                                        0.1)),
                                                                child: const Text(
                                                                    'Sno.',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      kDefaultPadding),
                                                              SizedBox(
                                                                width: ((constraints
                                                                            .maxWidth *
                                                                        0.3) -
                                                                    (kDefaultPadding *
                                                                        0.3)),
                                                                child: const Text(
                                                                    'ELEMENT NAME',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      kDefaultPadding),
                                                              SizedBox(
                                                                width: ((constraints
                                                                            .maxWidth *
                                                                        0.2) -
                                                                    (kDefaultPadding *
                                                                        0.2)),
                                                                child: const Text(
                                                                    'AMOUNT',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      kDefaultPadding),
                                                              SizedBox(
                                                                width: ((constraints
                                                                            .maxWidth *
                                                                        0.2) -
                                                                    (kDefaultPadding *
                                                                        0.2)),
                                                                child: const Text(
                                                                    'ACTION',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      kDefaultPadding),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          kDefaultPadding),
                                              child:
                                                  Column(children: const [])),
                                          Card(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom:
                                                              kDefaultPadding),
                                                  child: LayoutBuilder(builder:
                                                      (context, constraints) {
                                                    return Row(children: [
                                                      const SizedBox(
                                                          width:
                                                              kDefaultPadding),
                                                      SizedBox(
                                                        width: ((constraints
                                                                    .maxWidth *
                                                                0.5) -
                                                            (kDefaultPadding *
                                                                0.5)),
                                                        child: const Text(
                                                            'Total Amount',
                                                            textAlign: TextAlign
                                                                .start),
                                                      ),
                                                      SizedBox(
                                                        width: ((constraints
                                                                    .maxWidth *
                                                                0.4) -
                                                            (kDefaultPadding *
                                                                0.4)),
                                                        child: Text(
                                                            '$totalScores.00',
                                                            textAlign: TextAlign
                                                                .start),
                                                      ),
                                                    ]);
                                                  }))),
                                        ]))),
                            SizedBox(
                              height: 40.0,
                              child: ElevatedButton(
                                style: themeData
                                    .extension<AppButtonTheme>()!
                                    .successElevated,
                                onPressed: () =>
                                    {_doSubmit(context, totalScores, g)},
                                // doSubmit(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: kDefaultPadding * 0.5),
                                      child: Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: (themeData
                                                .textTheme.button!.fontSize! +
                                            4.0),
                                      ),
                                    ),
                                    Text(lang.submit),
                                  ],
                                ),
                              ),
                            ),
                          ]);
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
}

// class CreateStructure extends StatefulWidget {
//   const CreateStructure({Key? key}) : super(key: key);
//
//   @override
//   _CreateStructureState createState() => _CreateStructureState();
// }
// class Products extends StatefulWidget {
//   var fees_element_data;
//
//   var products;
//
//   var g;
//
//   Products(List<Object> products, fees_element_data, List<Object?>? g,
//       {Key? key})
//       : super(key: key);
//
//   @override
//   State<Products> createState() => _Products(fees_element_data, products, g);
// }
//
// class _Products extends State<Products> {
//   var products;
//
//   var fees_element_data;
//
//   var g;
//
//   _Products(this.products, this.fees_element_data, this.g);
//   //var products1 = products;
//   // final _formKey = GlobalKey<FormBuilderState>();
//   final _formData = FormData();
//   // var fees_element_data;
//   // var g = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // print(widget.products);
//     // products = widget.products;
//     // fees_element_data = widget.fees_element_data;
//     // g = widget.g;
//     //_products.add("No Element Selected");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     // _products.removeLast();
//   }
//
//   Widget _buildProductItem(
//     BuildContext context,
//     int index1,
//     int index,
//   ) {
//     var k = index + 1;
//     var item = fees_element_data['rows'];
//     Map<int, Object> n = {};
//     var tags = g != null ? List.from(g) : [{}];
//     var tags2 = item != null ? List.from(item) : [{}];
//     List name = [];
//     List amount = [];
//     List am = [];
//     print(g);
//     var condition = true;
//
//     Map<int, String> someMap = {};
//     for (var ae in tags) {
//       for (var l in tags2) {
//         if (l['id'] == ae) {
//           n.putIfAbsent(ae, () => l);
//           name.add(l['name']);
//           amount.add(l['amount']);
//         }
//       }
//     }
//     return g != null
//         ? Padding(
//             padding: const EdgeInsets.only(bottom: kDefaultPadding),
//             child: Card(child: LayoutBuilder(builder: (context, constraints) {
//               return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                         padding: const EdgeInsets.only(bottom: kDefaultPadding),
//                         child: Row(children: [
//                           const SizedBox(width: kDefaultPadding),
//                           SizedBox(
//                             width: ((constraints.maxWidth * 0.1) -
//                                 (kDefaultPadding * 0.1)),
//                             child: Text(textAlign: TextAlign.start, "#$k"),
//                           ),
//                           const SizedBox(width: kDefaultPadding),
//                           SizedBox(
//                               width: ((constraints.maxWidth * 0.2) -
//                                   (kDefaultPadding * 0.1)),
//                               child: Text(name[index],
//                                   textAlign: TextAlign.start)),
//                           const SizedBox(width: kDefaultPadding),
//                           SizedBox(
//                             width: ((constraints.maxWidth * 0.2) -
//                                 (kDefaultPadding * 0.1)),
//                             child: FormBuilderTextField(
//                                 name: 'E_amount',
//                                 readOnly: condition,
//                                 decoration: InputDecoration(
//                                   labelText: amount[index].toString(),
//                                   suffixIcon: IconButton(
//                                     icon: const Icon(Icons.edit),
//                                     color: Colors.green,
//                                     tooltip: 'Edit',
//                                     onPressed: () => {
//                                       setState(() {}),
//                                     },
//                                   ),
//                                   border: const OutlineInputBorder(),
//                                   // floatingLabelBehavior: FloatingLabelBehavior.always,
//                                 ),
//
//                                 ///valueTransformer:tags[index]["amount"] ,
//                                 initialValue: amount[index].toString(),
//                                 validator: FormBuilderValidators.required(),
//                                 onChanged: (value) => {
//                                       print(value)
//                                       // someMap[index] = value.toString(),
//                                       // am.add(someMap),
//                                       // //  _formData.E_amount = someMap ?? '',
//                                       // print(am),
//                                     }),
//                           ),
//                           const SizedBox(width: kDefaultPadding),
//                           const SizedBox(width: kDefaultPadding),
//                           const SizedBox(width: kDefaultPadding),
//                           const SizedBox(width: kDefaultPadding),
//                           SizedBox(
//                             height: 25.0,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   right: kDefaultPadding / 2),
//                               child: SizedBox(
//                                 width: ((constraints.maxWidth * 0.2) -
//                                     (kDefaultPadding * 0.1)),
//                                 child: IconButton(
//                                   alignment: Alignment.center,
//                                   icon: const Icon(Icons.delete),
//                                   color: Colors.red,
//                                   tooltip: 'Delete',
//                                   onPressed: () => {},
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ])),
//                   ]);
//             })))
//         : Padding(
//             padding: const EdgeInsets.only(bottom: kDefaultPadding),
//             child: LayoutBuilder(builder: (context, constraints) {
//               return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Card(
//                       child: SizedBox(
//                           width: ((constraints.maxWidth * 0.2) -
//                               (kDefaultPadding * 0.1)),
//                           child: const Text('No Selected Element',
//                               textAlign: TextAlign.start)),
//                     )
//                   ]);
//             }));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var distinctIds = products.toSet().toList();
//
//     return g == null
//         ? Row(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: const <Widget>[
//                 Card(
//                     child: Text('No Selected Element',
//                         textAlign: TextAlign.center)),
//                 // )
//               ])
//         : ListView.builder(
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemBuilder: (context, index) {
//               if (g == null) {
//                 return Row(
//                     // crossAxisAlignment: CrossAxisAlignment.center,
//                     children: const <Widget>[
//                       Card(
//                           child: Text('No Selected Element',
//                               textAlign: TextAlign.center))
//                     ]);
//               } else {
//                 return _buildProductItem(context, g[index], index);
//               }
//             },
//             itemCount: g.length);
//   }
// }

class FormData {
  String stactureName = '';
  String description = '';
  String totalAmount = '';
  // Object E_amount = {} ;
  Map<String, dynamic> toJson() => {
        "structureName": stactureName,
        'Description': description,
        // "feesModifiedElement" :E_amount,
        'totalAmount': totalAmount
      };
}
