import 'dart:convert';
import 'dart:math';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:school_master_erp/services/fees_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/class_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../theme/theme_extensions/app_button_theme.dart';
import '../../../theme/theme_extensions/app_color_scheme.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';
import '../subject_screen/subject_modal.dart';
import 'exam_profile_modal.dart';



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
  final _formKey3 = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  final _searchController3 = TextEditingController();
  final _customFooter = false;
  var _rowsPerPage = 5;
  var _source;
  var _sortIndex = 0;
  var selectedIdsData = [];
  var _sortAsc = true;
  final _scrollController7 = ScrollController();
  var subjectList1;
  var element = [];
  List res = [];

  final SubjectApiService apiService = SubjectApiService();
  final ClassApiService apiClassService = ClassApiService();
  _getDataAsync() async {
    final response = await apiService.getSubjectList();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["rows"];
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
    _searchController3.text = '';
    _source = ExampleSource();
  }
  Future showOptionsDialog(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    final scrollController2 = ScrollController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding * 10,
                  right: kDefaultPadding * 10,
                  top: kDefaultPadding * 6,
                  bottom: kDefaultPadding * 3),
              children: [
                Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(children: [
                      SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('SUBJECT LIST'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    //  style: appColorScheme.,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: kTextPadding),
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            size: 25,
                                          ),
                                        ),
                                        //  Text('Save'),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: kDefaultPadding * 1.0,
                            left: kDefaultPadding * 1.0),
                        child: FormBuilder(
                          key: _formKey3,
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
                                SizedBox(
                                  width: 300.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: kDefaultPadding * 1.5),
                                    child: FormBuilderTextField(
                                      controller: _searchController3,
                                      name: 'search',
                                      decoration: InputDecoration(
                                        labelText: lang.search,
                                        hintText: lang.search,
                                        border: const OutlineInputBorder(),
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        isDense: true,
                                      ),
                                      onSubmitted: (value) {
                                        _source.filterServerSide(
                                            _searchController3.text);
                                      },
                                    ),
                                  ),
                                ),
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
                                            icon: const Icon(Icons.search),
                                            tooltip: 'Search',
                                            onPressed: () {
                                              // print(_source.selectedIds);
                                              setState(() {
                                                _searchController3.text = '';
                                              });
                                              _source.filterServerSide(
                                                  _searchController3.text);
                                            },
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
                                              color: Colors.green,
                                              icon: const Icon(Icons.download),
                                              tooltip: 'Import List',
                                              onPressed: () =>
                                              {showOptionsDialog(context)}
                                            // GoRouter.of(context)
                                            //     .go(RouteUri
                                            //         .form),
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
                                              tooltip: 'Add New Student',
                                              onPressed: () => {}),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double dataTableWidth =
                            max(kScreenWidthMd, constraints.maxWidth);
                            return Scrollbar(
                                controller: scrollController2,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: scrollController2,
                                  child: SizedBox(
                                    width: dataTableWidth,
                                    height: 310,
                                    child: Theme(
                                      data: themeData.copyWith(
                                        cardTheme: appDataTableTheme.cardTheme,
                                        dataTableTheme: appDataTableTheme
                                            .dataTableThemeData,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        controller: _scrollController7,
                                        child:
                                        AdvancedPaginatedDataTable(
                                          // header: const Text(''),
                                          addEmptyRows: false,
                                          source: _source,
                                          showHorizontalScrollbarAlways: true,
                                          sortAscending: _sortAsc,
                                          sortColumnIndex: _sortIndex,
                                          showFirstLastButtons: true,
                                          rowsPerPage: _rowsPerPage,
                                          availableRowsPerPage: const [
                                            5,
                                            10,
                                            20,
                                            30,
                                            50
                                          ],

                                          onRowsPerPageChanged:
                                              (newRowsPerPage) {
                                            if (newRowsPerPage != null) {
                                              setState(() {
                                                _rowsPerPage = newRowsPerPage;
                                              });
                                              Navigator.pop(context);
                                              showOptionsDialog(context);
                                            }
                                          },
                                          columns: [
                                            DataColumn(
                                              label: const Text('ID'),
                                              numeric: true,
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Subject Name'),
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Subject Type'),
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Minimum Marks'),
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Maximum Marks'),
                                              onSort: setSort,
                                            ),
                                          ],
                                          //Optician override to support custom data row text / translation
                                          getFooterRowText: (startRow,
                                              pageSize,
                                              totalFilter,
                                              totalRowsWithoutFilter) {
                                            final localizations =
                                            MaterialLocalizations.of(
                                                context);
                                            var amountText =
                                            localizations.pageRowsInfoTitle(
                                              startRow,
                                              pageSize,
                                              totalFilter ??
                                                  totalRowsWithoutFilter,
                                              false,
                                            );
                                            if (totalFilter != null) {
                                              //Filtered data source show additional information
                                              amountText +=
                                              ' filtered from ($totalRowsWithoutFilter)';
                                            }
                                            return amountText;
                                          },
                                          customTableFooter: _customFooter
                                              ? (source, offset) {
                                            const maxPagesToShow = 6;
                                            const maxPagesBeforeCurrent =
                                            3;
                                            final lastRequestDetails =
                                            source.lastDetails!;
                                            final rowsForPager =
                                                lastRequestDetails
                                                    .filteredRows ??
                                                    lastRequestDetails
                                                        .totalRows;
                                            final totalPages =
                                                rowsForPager ~/
                                                    _rowsPerPage;
                                            final currentPage =
                                                (offset ~/ _rowsPerPage) +
                                                    1;
                                            final List<int> pageList = [];
                                            if (currentPage > 1) {
                                              pageList.addAll(
                                                List.generate(
                                                    currentPage - 1,
                                                        (index) => index + 1),
                                              );
                                              //Keep up to 3 pages before current in the list
                                              pageList.removeWhere(
                                                    (element) =>
                                                element <
                                                    currentPage -
                                                        maxPagesBeforeCurrent,
                                              );
                                            }
                                            pageList.add(currentPage);
                                            //Add reminding pages after current to the list
                                            pageList.addAll(
                                              List.generate(
                                                maxPagesToShow -
                                                    (pageList.length - 1),
                                                    (index) =>
                                                (currentPage + 1) +
                                                    index,
                                              ),
                                            );
                                            pageList.removeWhere(
                                                    (element) =>
                                                element > totalPages);

                                            return Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    // style: appColorScheme,
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
                                                                .cancel_outlined,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        //  Text('Save'),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: pageList
                                                        .map(
                                                          (e) =>
                                                          TextButton(
                                                            onPressed: e !=
                                                                currentPage
                                                                ? () {
                                                              //Start index is zero based
                                                              source
                                                                  .setNextView(
                                                                startIndex:
                                                                (e - 1) * _rowsPerPage,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                              showOptionsDialog(
                                                                  context);
                                                            }
                                                                : null,
                                                            child: Text(
                                                              e.toString(),
                                                            ),
                                                          ),
                                                    )
                                                        .toList(),
                                                  )
                                                ]);
                                          }
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                      )
                    ])),
              ],
            );
          });
        });
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
                // print(res?.statusCode);
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
  Widget build(BuildContext context ) {

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

  Widget _content(BuildContext context,  ) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    ButtonStyle buttonStyle = const ButtonStyle();
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
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
            child: Align(
              alignment: Alignment.centerRight, // or Alignment.bottomRight
              child: TextButton(
                onPressed: ()   {showOptionsDialog(context);},
                style: buttonStyle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: kTextPadding),
                      child: Icon(Icons.add_box_outlined),
                    ),
                    Text('Add Subject'),
                  ],
                ),
              ),
            ),
          ),

          Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
              child: FormBuilderFilterChip(
                name: 'Theory_Subject',
                spacing: kDefaultPadding * 0.5,
                runSpacing: kDefaultPadding * 0.5,
                selectedColor: appColorScheme.warning,
                decoration: const InputDecoration(
                  labelText: 'Subject List',
                  //helperText: 'Theory Subject',
                  border: OutlineInputBorder(),
                ),
                options: subjectList1 ?? [],
                // options:
                // optionElement,
               onSaved: (value) => (_formData.examSubjectDetails = value ?? []),
              )),
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
  void setSort(int i, bool asc) {
    setState(() {
      _sortIndex = i;
      _sortAsc = asc;
    });
    Navigator.pop(context);
    showOptionsDialog(context);
  }
}
typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);

class ExampleSource extends AdvancedDataTableSource<ExamProfileModal> {
  static List<String> selectedIds = [];
  String lastSearchTerm = '';
  String classId = '';

  final storage = const FlutterSecureStorage();
  ApiService apiService = ApiService();
  SubjectApiService apiService2 = SubjectApiService();

  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds, doOperations);
  @override
  int get selectedRowCount => selectedIds.length;

  void selectedRow(
      String id,
      bool newSelectState,
      ) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void _doDelete(BuildContext context, id) {
    ApiService apiService = ApiService();
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
          btnOkOnPress: () {
            apiService.deleteRow(id).whenComplete(() => setNextView());
          },
        );
        d.show();
      },
      btnCancelText: lang.cancel,
      btnCancelOnPress: () {},
    );
    dialog.show();
  }

  Future<void> doOperations(
      String id, BuildContext context, String operationType) async {
    if (operationType == 'EDIT') {
      AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      await storage.write(
          key: "student_id", value: id, aOptions: getAndroidOptions()
        //iOptions: _getIOSOptions(),
      );
      GoRouter.of(context).go('${RouteUri.form}?id=$id');
      // print('EDIT');
    }
    if (operationType == 'DETAILS') {
      GoRouter.of(context).go('${RouteUri.student}?id=$id');
    }
    if (operationType == 'DELETE') {
      // print('DELETE');
      _doDelete(context, id);
      // deleteConfirmationDialog(context, id);
    }
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  Future<RemoteDataSourceDetails<ExamProfileModal>> getNextPage(NextPageRequest pageRequest) async {

    final response = await apiService2.getSubjectList();
    final data = jsonDecode(response.body);
    print("okk");
    print(data);
    final List<ExamProfileModal> paginatedData = (data['rows'] as List<dynamic>)
        .map((json) => ExamProfileModal.fromJson(json as Map<String, dynamic>))
        .toList();
    final List<ExamProfileModal> paginatedList = paginatedData
        .skip(pageRequest.offset)
        .take(pageRequest.pageSize)
        .toList();
    return RemoteDataSourceDetails(
      int.parse(data['totalRows'].toString()),
      paginatedList,
      filteredRows: lastSearchTerm.isNotEmpty ? paginatedData.length : null,
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