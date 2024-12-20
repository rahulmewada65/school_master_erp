import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:school_master_erp/services/class_api_service.dart';
import 'package:school_master_erp/views/screens/classes_screen/subject_modal_class.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/class_profile_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';
import 'classes_profile_modal.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class ClassProfileScreen extends StatefulWidget {
  final String id;
  const ClassProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ClassProfileScreen> createState() => _ClassProfileScreenState();
}

class _ClassProfileScreenState extends State<ClassProfileScreen> {
  var _rowsPerPage = 5;
  var _source;
  var _source2;
  var _sortIndex = 0;
  var selectedIdsData = [];
  var _sortAsc = true;
  var _visible1 = true;
  final _visible2 = true;
  final _visible3 = true;
  var _visible4 = false;
  var _visible5 = true;

  final _searchController1 = TextEditingController();
  final _searchController2 = TextEditingController();
  final _searchController3 = TextEditingController();
  final _customFooter = false;
  final _scrollController1 = ScrollController();
  final _scrollController3 = ScrollController();
  final _scrollController4 = ScrollController();
  final _scrollController5 = ScrollController();
  final _scrollController6 = ScrollController();
  final _scrollController7 = ScrollController();
  final _formKey1 = GlobalKey<FormBuilderState>();
  final _formKey2 = GlobalKey<FormBuilderState>();
  final _formKey3 = GlobalKey<FormBuilderState>();
  final ApiService apiService = ApiService();
  final ClassApiService _classApiService = ClassApiService();
  final ClassProfileApiService _classStudentApiService = ClassProfileApiService();
  final SubjectApiService apiSubjectService = SubjectApiService();
  final ClassApiService apiClassService = ClassApiService();
  List classData = [];
  List studentList = [];
  List<bool> selectedRowsTable1 = [];
  List<bool> selectedRowsTable2 = [];

  // late DataSource _dataSource
  @override
  initState() {
    super.initState();
    _searchController1.text = '';
    _searchController2.text = '';
    _searchController3.text = '';
    _source = ExampleSource(widget.id);
    _source2 = ExampleSource2(widget.id);
    _getDataAsync();

  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController3.dispose();
    _scrollController4.dispose();
    _scrollController5.dispose();
    _scrollController6.dispose();
    _scrollController7.dispose();
    super.dispose();
  }

  Future<bool> _getDataAsync() async {
    Future<Response> response1 = getClassDetails();
    Future<Response> response2 = getClassStudentDetails();
    if (widget.id.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1), () {
        response2.then((value) async => {
              if (jsonDecode(value.body)['stClass'] != null)
                {
                  setState(() {
                    classData = jsonDecode("[${value.body}]");
                    studentList = jsonDecode("[${value.body}]")[0]["assignStudents"];
                    selectedRowsTable1 = List.generate(jsonDecode("[${value.body}]")[0]["assignStudents"].length, (index) => false);
                  }),
                }
              else
                {
                  await Future.delayed(const Duration(seconds: 1), () {
                    response1.then((value2) => {
                          setState(() {
                            classData = jsonDecode("[${value2.body}]");
                            studentList = jsonDecode("[${value.body}]")[0]["assignStudents"];
                            selectedRowsTable1 = List.generate(jsonDecode("[${value.body}]")[0]["assignStudents"].length, (index) => false);

                          }),
                        });
                  })
                }
            });
      });
    } else {}

    return true;
  }

  assignStudent() async {
    var id = widget.id;
    var selectedIds = ExampleSource.selectedIds;
    setState(() {
      classData =[];
      studentList = [];
    });
    var localData = {
      "classId": id,
      "assignStudents": selectedIds
    };
    var res = await _classStudentApiService.assignStudentInClass(localData);
    var statusCode = res?.statusCode;
    if (res?.statusCode == 201) {
      ExampleSource.selectedIds = [];
      Navigator.pop(context);
      _getDataAsync().then((value) => GoRouter.of(context).go('${RouteUri.class_profile}?id=$id'));
    }
  }
  assignsubject() async {
    try {
      var classId = widget.id;
      var res1 = await apiClassService.getClassById(classId);
      final res2 = await apiSubjectService.getSubjectList();
      var selectedIds = ExampleSource2.selectedIds2;
      List<dynamic> data = jsonDecode(res2.body)['rows'];
      var data2 = jsonDecode(res1.body);
      var subject = data2["subject"];
      List filteredSubjects = data.where((subject) {
            return selectedIds.contains(subject['id'].toString());
          }).toList();
      List<Map<String, dynamic>> mergedList = [...filteredSubjects, ...subject];
      data2["subject"] = mergedList;
      var res = await apiClassService.addClassApi(data2);
      if (res?.statusCode == 201) {
        ExampleSource2.selectedIds2 = [];
        Navigator.pop(context);
        _getDataAsync().then((value) => GoRouter.of(context).go('${RouteUri.class_profile}?id=$classId'));
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error as needed: show a message, log it, or take specific actions
    }
  }


  Future<Response> getClassDetails() async {
    var response = _classApiService.getClassById(widget.id);
    return response;
  }

  Future<Response> getClassStudentDetails() async {
    var response = _classStudentApiService.getClassStudentById(widget.id);
    return response;
  }

  Future showOptionsDialog2(BuildContext context) {
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
                                        _source2.filterServerSide(
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
                                              _source2.filterServerSide(
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
                                              onPressed: () => assignsubject()),
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
                                          source: _source2,
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
                                            // DataColumn(
                                            //   label: const Text('Maximum Marks'),
                                            //   onSort: setSort,
                                            // ),
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
                                  const Text('STUDENT LIST'),
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
                                              onPressed: () => assignStudent()),
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
                                              label: const Text('Roll Number'),
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Full Name'),
                                              onSort: setSort,
                                            ),
                                            DataColumn(
                                              label: const Text('Phone'),
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

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.classes,
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          // Text(
          //   '${classData.isNotEmpty ? classData[0]["stClass"]["name"] : ""} Profile',
          //   style: themeData.textTheme.headline4,
          // ),
          Visibility(
              visible: _visible2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('STUDENT LIST'),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _visible1 = !_visible1;
                                      });
                                    },
                                    //  style: appColorScheme.,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: kTextPadding),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                          ),
                                        ),
                                        //  Text('Save'),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      // const CardHeader(
                      //   title: 'STUDENT LIST',
                      // ),
                      Visibility(
                          visible: _visible1,
                          child: Column(children: [
                            const Divider(),
                            CardBody(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPadding * 1.0),
                                    child: FormBuilder(
                                      key: _formKey1,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          spacing: kDefaultPadding,
                                          runSpacing: kDefaultPadding,
                                          alignment: WrapAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 300.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right:
                                                        kDefaultPadding * 1.5),
                                                child: FormBuilderTextField(
                                                  controller: _searchController1,
                                                  name: 'search',
                                                  decoration: InputDecoration(
                                                    labelText: lang.search,
                                                    hintText: lang.search,
                                                    border:
                                                        const OutlineInputBorder(),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    isDense: true,
                                                  ),
                                                  onSubmitted: (value) {
                                                    _source.filterServerSide(
                                                        _searchController1.text);
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
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.search),
                                                        tooltip: 'Search',
                                                        onPressed: () {
                                                          // print(_source
                                                              // .selectedIds);
                                                          setState(() {
                                                            _searchController1
                                                                .text = '';
                                                          });
                                                          _source.filterServerSide(
                                                              _searchController1
                                                                  .text);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                          color: Colors.green,
                                                          icon: const Icon(
                                                              Icons.download),
                                                          tooltip:
                                                              'Import List',
                                                          onPressed: () => {
                                                                showOptionsDialog(
                                                                    context)
                                                              }
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
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                          color: Colors.red,
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          tooltip:
                                                              'Delete Selected',
                                                          onPressed: () => {}
                                                          //GoRouter.of(context).go(RouteUri.crudDetail),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                        color:
                                                            Colors.blueAccent,
                                                        icon: const Icon(Icons
                                                            .add_circle_outline),
                                                        tooltip:
                                                            'Add More Student',
                                                        onPressed: () =>
                                                            showOptionsDialog(
                                                                context),
                                                      ),
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
                                    height: 300,
                                    width: double.infinity,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final double dataTableWidth = max(
                                            kScreenWidthMd,
                                            constraints.maxWidth);
                                        return
                                          SingleChildScrollView(
                                          controller: _scrollController1,
                                            scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            controller: _scrollController4,
                                            child: SizedBox(
                                              width: dataTableWidth,
                                              child: Theme(
                                                  data: themeData.copyWith(
                                                    cardTheme: appDataTableTheme
                                                        .cardTheme,
                                                    dataTableTheme:
                                                        appDataTableTheme
                                                            .dataTableThemeData,
                                                  ),
                                                  child: DataTable(
                                                    showCheckboxColumn: true,
                                                    showBottomBorder: true,
                                                    onSelectAll: (newValue) {
                                                      setState(() {
                                                        selectedRowsTable1 = List.generate(
                                                            selectedRowsTable1.length, (index) => newValue ?? false);
                                                      });
                                                    },
                                                    columns:  const [
                                                      DataColumn(
                                                        label: Text('No.'),
                                                      ),
                                                      DataColumn(
                                                          label: Text(
                                                              'RollNumber')),
                                                      DataColumn(
                                                          label:
                                                              Text('FullName')),
                                                      DataColumn(
                                                        label:
                                                            Text('Father Name'),
                                                      ),
                                                      DataColumn(
                                                        label: Text('Action'),
                                                      ),
                                                    ],
                                                    rows: List.generate(
                                                        studentList.isNotEmpty ? studentList.length
                                                            : 0, (index) {
                                                      return DataRow.byIndex(
                                                        index: index,
                                                        selected: selectedRowsTable1[index],
                                                        onSelectChanged: (newValue) {
                                                          setState(() {
                                                            selectedRowsTable1[index] = newValue ?? false;
                                                          });
                                                        },
                                                        cells: [

                                                          DataCell(Text('#${index + 1}')),
                                                          DataCell(Text(studentList.isNotEmpty ? studentList[index]["rollNumber"] : 0)),
                                                          DataCell(Text(studentList.isNotEmpty ? studentList[index]["firstName"] : '')),
                                                          DataCell(Text(studentList.isNotEmpty ? studentList[index]["fatherName"] : '')),
                                                          DataCell(Builder(
                                                            builder: (context) {
                                                              return Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 28.0,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(right: kDefaultPadding / 2),
                                                                      child: SizedBox(
                                                                        height: 25.0,
                                                                        child: IconButton(
                                                                          icon: const Icon(Icons.delete),
                                                                          color: Colors.red,
                                                                          tooltip: 'Delete',
                                                                          onPressed: () => {

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
                                                      );
                                                    }),
                                                  )),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]))
                    ],
                  ),
                ),
              )),
          Visibility(
              visible: _visible3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                      setState(() {
                                        _visible4 = !_visible4;
                                      });
                                    },
                                    //  style: appColorScheme.,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: kTextPadding),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                          ),
                                        ),
                                        //  Text('Save'),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      // const CardHeader(
                      //   title: 'STUDENT LIST',
                      // ),
                      Visibility(
                          visible: _visible4,
                          child: Column(children: [
                            const Divider(),
                            CardBody(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: kDefaultPadding * 1.0),
                                    child: FormBuilder(
                                      key: _formKey2,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          spacing: kDefaultPadding,
                                          runSpacing: kDefaultPadding,
                                          alignment: WrapAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 300.0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right:
                                                        kDefaultPadding * 1.5),
                                                child: FormBuilderTextField(
                                                  controller: _searchController2,
                                                  name: 'search',
                                                  decoration: InputDecoration(
                                                    labelText: lang.search,
                                                    hintText: lang.search,
                                                    border:
                                                        const OutlineInputBorder(),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    isDense: true,
                                                  ),
                                                  onSubmitted: (value) {
                                                    _source.filterServerSide(
                                                        _searchController2.text);
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
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.search),
                                                        tooltip: 'Search',
                                                        onPressed: () {
                                                          // print(_source
                                                          //     .selectedIds);
                                                          setState(() {
                                                            _searchController2
                                                                .text = '';
                                                          });
                                                          _source.filterServerSide(
                                                              _searchController2
                                                                  .text);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                          color: Colors.green,
                                                          icon: const Icon(
                                                              Icons.download),
                                                          tooltip:
                                                              'Import List',
                                                          onPressed: () => {
                                                                showOptionsDialog(
                                                                    context)
                                                              }
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
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                          color: Colors.red,
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          tooltip:
                                                              'Delete Selected',
                                                          onPressed: () => {}
                                                          //GoRouter.of(context).go(RouteUri.crudDetail),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .only(
                                                        right: kDefaultPadding),
                                                    child: SizedBox(
                                                      height: 40.0,
                                                      child: IconButton(
                                                        color:
                                                            Colors.blueAccent,
                                                        icon: const Icon(Icons
                                                            .add_circle_outline),
                                                        tooltip:
                                                            'Add New Student',
                                                        onPressed: () =>
                                                            showOptionsDialog2(
                                                                context)),
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
                                        final double dataTableWidth = max(
                                            kScreenWidthMd,
                                            constraints.maxWidth);
                                        return  SingleChildScrollView(
                                          controller: _scrollController3,
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            controller: _scrollController6,
                                            child: SizedBox(
                                              width: dataTableWidth,
                                              child: Theme(
                                                data: themeData.copyWith(
                                                  cardTheme: appDataTableTheme
                                                      .cardTheme,
                                                  dataTableTheme:
                                                      appDataTableTheme
                                                          .dataTableThemeData,
                                                ),
                                                child: DataTable(
                                                  showCheckboxColumn: true,
                                                  showBottomBorder: true,
                                                  columns: [
                                                    DataColumn(
                                                        label: IconButton(
                                                      icon: Icon(_visible5
                                                          ? Icons
                                                              .check_box_outline_blank_sharp
                                                          : Icons
                                                              .check_box_sharp),
                                                      color: _visible5
                                                          ? Colors.white
                                                          : Colors.cyanAccent,
                                                      tooltip: 'Select All',
                                                      onPressed: () => {
                                                        setState(() {
                                                          _visible5 =
                                                              !_visible5;
                                                        })
                                                      },
                                                      // {operation(id.toString(), context, "EDIT")}
                                                    )),
                                                    const DataColumn(
                                                      label: Text('No.'),
                                                    ),
                                                    const DataColumn(
                                                        label: Text(
                                                            'Subject')),
                                                    const DataColumn(
                                                        label: Text(
                                                            'Subject Type')),
                                                    const DataColumn(
                                                        label: Text(
                                                            'Mini. Marks')),
                                                    const DataColumn(
                                                        label: Text(
                                                            'Max. Marks')),
                                                    const DataColumn(
                                                      label: Text('Action'),
                                                    ),
                                                  ],
                                                  rows: List.generate(
                                                      classData.isNotEmpty
                                                          ? classData[0]["stClass"]!= null ?classData[0]["stClass"]
                                                                  ["subject"]
                                                              .length:0
                                                          : 0, (index) {
                                                    return DataRow.byIndex(
                                                      index: index,
                                                      cells: [
                                                        DataCell(
                                                          FormBuilderCheckbox(
                                                            name:
                                                                'accept_terms',
                                                            initialValue: false,
                                                            onChanged:
                                                                (value) {},
                                                            title: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: '',
                                                                    style:
                                                                        TextStyle(
                                                                      color: themeData
                                                                          .colorScheme
                                                                          .onSurface,
                                                                    ),
                                                                  ),
                                                                  const TextSpan(
                                                                    text: '',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(Text(
                                                            '#${index + 1}')),
                                                        DataCell(Text(
                                                            "${classData.isNotEmpty ? classData[0]['stClass']!= null ?classData[0]['stClass']["subject"][index]["name"] :"": ''}")),
                                                        DataCell(Text(
                                                            "${classData.isNotEmpty ? classData[0]['stClass']!= null ?classData[0]['stClass']["subject"][index]["subjectType"]:"" : ''}")),
                                                        DataCell(Text(
                                                            "${classData.isNotEmpty ? classData[0]['stClass']!= null ?classData[0]['stClass']["subject"][index]["minPassingMarks"]:"" : ''}")),
                                                        DataCell(Text(
                                                            "${classData.isNotEmpty ? classData[0]['stClass']!= null ?classData[0]['stClass']["subject"][index]["maxMarks"]:"" : ''}")),
                                                        DataCell(Builder(
                                                          builder: (context) {
                                                            return Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 28.0,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(right: kDefaultPadding / 2),
                                                                    child: SizedBox(
                                                                      height: 25.0,
                                                                      child: IconButton(
                                                                        icon: const Icon(Icons.delete),
                                                                        color: Colors.red,
                                                                        tooltip: 'Delete',
                                                                        onPressed: () => {

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
                                ],
                              ),
                            ),
                          ]))
                    ],
                  ),
                ),
              )),
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


