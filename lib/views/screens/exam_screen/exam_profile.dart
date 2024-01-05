import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:school_master_erp/services/class_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/class_profile_api_service.dart';
import '../../../services/exam_api_service.dart';
import '../../../services/subject_api_service.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';
import 'exam_profile_modal.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class ExamProfileScreen extends StatefulWidget {
  final String id;
  const ExamProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ExamProfileScreen> createState() => _ExamProfileScreenState();
}

class _ExamProfileScreenState extends State<ExamProfileScreen> {
  var _rowsPerPage = 5;
  var _source;
  var _sortIndex = 0;
  var selectedIdsData = [];
  var _sortAsc = true;
  var _visible1 = true;
  final _visible2 = true;


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
  final ExamApiService examApiService = ExamApiService();
  final SubjectApiService subjectApiService = SubjectApiService();
  final ClassProfileApiService _classStudentApiService = ClassProfileApiService();


  List subjectList = [];
  List<String> selectedIds2 = [];
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
    Future<Response> response = getExamDetails();
    if (widget.id.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1), () {
        response.then((value) async => {
          if ( jsonDecode(value.body)["examSubjectDetails"].length>0){
            setState(() {
              subjectList = jsonDecode(value.body)["examSubjectDetails"];
              selectedRowsTable1 = List.generate(jsonDecode(value.body)["examSubjectDetails"].length, (index) => false);
              })
          }
        });
      });
    } else {}

    return true;
  }

  assignsubject() async {
    var examId = widget.id;
   var selectedIds = ExampleSource.selectedIds;
    var response1 = await subjectApiService.getSubjectList();
    var response2 = await examApiService.getExamById(examId);
    final data1 = jsonDecode(response1.body)["rows"];
    final data2 = jsonDecode(response2.body).cast<String, dynamic>();

    List<dynamic> filteredData = data1
        .where((item) => selectedIds.contains(item["id"].toString()))
        .map((item) => {
      "name": item["name"],
      "subjectType": item["subjectType"],
      "minPassingMarks": item["minPassingMarks"],
      "maxMarks": item["maxMarks"],
      "subjectId": item["id"],
    })
        .toList();

    List<dynamic> transformedData = [
      {
        "id":examId,
        "name": data2["name"],
        "examType": data2["examType"],
        "subjectDetails": [
          ...(data2["examSubjectDetails"] as List<dynamic>?)?.map((item) => {
            "name": item?["subject"]?["name"],
            "subjectType": item?["subject"]?["subjectType"],
            "minPassingMarks": item?["subject"]?["minPassingMarks"],
            "maxMarks": item?["subject"]?["maxMarks"],
            "subjectId": item?["subject"]?["id"],
          })?.toList() ?? [],
          ...filteredData,
        ],
      }
    ];

     var res = await examApiService.addExamApi(transformedData[0]);
     var statusCode = res?.statusCode;
     GoRouter.of(context).go('${RouteUri.exam_profile}?id=$examId');
    _getDataAsync();
    Navigator.pop(context);
   // _getDataAsync();
    //  .then((value) => GoRouter.of(context).go('${RouteUri.class_profile}?id=$id'));
    //GoRouter.of(context).go('${RouteUri.class_profile}?id=$id');
  }

  Future<Response> getExamDetails() async {
    var response = examApiService.getExamById(widget.id);
    return response;
  }

  Future<Response> getClassStudentDetails() async {
    var response = _classStudentApiService.getClassStudentById(widget.id);
    return response;
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

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    return PortalMasterLayout(
      selectedMenuUri: RouteUri.exam_screen,
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
                                  const Text('SUBJECT LIST'),
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
                                                        'Add More Subject',
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
                                                      // onSelectAll: (newValue) {
                                                      //   setState(() {
                                                      //     selectedRowsTable1 = List.generate(
                                                      //         selectedRowsTable1.length, (index) => newValue ?? false);
                                                      //   });
                                                      // },
                                                      columns:  const [
                                                        DataColumn(
                                                          label: Text('No.'),
                                                        ),
                                                        DataColumn(
                                                            label: Text(
                                                                'Subject Name')),
                                                        DataColumn(
                                                            label:
                                                            Text('Subject Type')),
                                                        DataColumn(
                                                            label:
                                                            Text('Minimum Marks')),
                                                        DataColumn(
                                                          label:
                                                          Text('Maximum Marks'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Action'),
                                                        ),
                                                      ],
                                                      rows: List.generate(
                                                          subjectList.isNotEmpty ? subjectList.length
                                                              : 0, (index) {
                                                        return DataRow.byIndex(
                                                          index: index,
                                                          //selected: selectedRowsTable1[index],
                                                          // onSelectChanged: (newValue) {
                                                          //   setState(() {
                                                          //     selectedRowsTable1[index] = newValue ?? false;
                                                          //   });
                                                          // },
                                                          cells: [
                                                            DataCell(Text('#${index + 1}')),
                                                            DataCell(Text(subjectList.isNotEmpty ? subjectList[index]["subject"]["name"] : 0)),
                                                            DataCell(Text(subjectList.isNotEmpty ? subjectList[index]["subject"]["subjectType"] : '')),
                                                            DataCell(Text(subjectList.isNotEmpty ? subjectList[index]["subject"]["minPassingMarks"].toString() : '')),
                                                            DataCell(Text(subjectList.isNotEmpty ? subjectList[index]["subject"]["maxMarks"].toString()  : '')),
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
  String examId = '';
  ExampleSource(String id) {
    examId = id;
  }


  final ExamApiService examApiService = ExamApiService();
  final SubjectApiService apiService = SubjectApiService();

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

  @override
  Future<RemoteDataSourceDetails<ExamProfileModal>> getNextPage(NextPageRequest pageRequest) async {
    try {
      // final queryParameter = <String, dynamic>{
      //   'offset': pageRequest.offset.toString(),
      //   'pageSize': pageRequest.pageSize.toString(),
      //   'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      //   'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      //   if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
      // };
      var response = await examApiService.getExamById(examId);
      var response2 = await apiService.getSubjectList();
      final data = jsonDecode(response.body).cast<String, dynamic>();
      final data1 = jsonDecode(response2.body)["rows"];
      List<Map<String, dynamic>> data2 = (data['examSubjectDetails'] as List)
          .map((item) => (item['subject'] as Map<String, dynamic>).cast<String, dynamic>())
          .toList();
      Set<int> idsInData2 = Set.from(data2.map((item) => item["id"]));
      List<dynamic> result = data1.where((item1) => !idsInData2.contains(item1["id"])).toList();
      var length = result.length;
      final List<ExamProfileModal> paginatedData = result
          .map((json) => ExamProfileModal.fromJson(json))
          .toList();
      final List<ExamProfileModal> paginatedList = paginatedData
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList();

      return RemoteDataSourceDetails(
        int.parse(length.toString()),
        paginatedList,
        filteredRows: lastSearchTerm.isNotEmpty ? paginatedData.length : null,
      );
    } catch (e) {
      // Handle exceptions or errors here
      print("Error in getNextPage: $e");
      return RemoteDataSourceDetails(0, []);
    }


  }

}
