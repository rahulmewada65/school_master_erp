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
import 'package:school_master_erp/services/fees_api_service.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';
import '../fees_screen/fees_modal.dart';
import 'teacher_modal.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  var _rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final _source = ExampleSource();
  var _sortIndex = 0;
  var _sortAsc = true;
  final _searchController = TextEditingController();
  final _customFooter = false;
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();
  final FeesApiService apiService = FeesApiService();
  // late DataSource _dataSource;

  @override
  initState() {
    super.initState();
    _searchController.text = '';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          // Text(
          //   'STUDENT LIST',
          //   style: themeData.textTheme.headline4,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'Fees Structure List',
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: kDefaultPadding * 2.0),
                          child: FormBuilder(
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
                                  SizedBox(
                                    width: 300.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: kDefaultPadding * 1.5),
                                      child: FormBuilderTextField(
                                        controller: _searchController,
                                        name: 'search',
                                        decoration: InputDecoration(
                                          labelText: lang.search,
                                          hintText: lang.search,
                                          border: const OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          isDense: true,
                                        ),
                                        onSubmitted: (vlaue) {
                                          _source.filterServerSide(
                                              _searchController.text);
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
                                                print(_source.selectedIds);
                                                setState(() {
                                                  _searchController.text = '';
                                                });
                                                _source.filterServerSide(
                                                    _searchController.text);
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
                                                  GoRouter.of(context)
                                                      .go(RouteUri.form),
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
                                              onPressed: () => {},
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
                                              tooltip: 'Add New Fees Element',
                                              onPressed: () =>
                                                  GoRouter.of(context).go(
                                                      RouteUri.classScreen),
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
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double dataTableWidth =
                                  max(kScreenWidthMd, constraints.maxWidth);

                              return Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  child: SizedBox(
                                    width: dataTableWidth,
                                    child: Theme(
                                      data: themeData.copyWith(
                                        cardTheme: appDataTableTheme.cardTheme,
                                        dataTableTheme: appDataTableTheme
                                            .dataTableThemeData,
                                      ),
                                      child: AdvancedPaginatedDataTable(
                                        // header: const Text(''),
                                        addEmptyRows: false,
                                        source: _source,
                                        showHorizontalScrollbarAlways: true,
                                        sortAscending: _sortAsc,
                                        sortColumnIndex: _sortIndex,
                                        showFirstLastButtons: true,
                                        rowsPerPage: _rowsPerPage,
                                        availableRowsPerPage: const [
                                          10,
                                          20,
                                          30,
                                          50
                                        ],
                                        onRowsPerPageChanged: (newRowsPerPage) {
                                          if (newRowsPerPage != null) {
                                            setState(() {
                                              _rowsPerPage = newRowsPerPage;
                                            });
                                          }
                                        },
                                        columns: [
                                          DataColumn(
                                            label: const Text('ID'),
                                            numeric: true,
                                            onSort: setSort,
                                          ),
                                          DataColumn(
                                            label: const Text('Class'),
                                            onSort: setSort,
                                          ),
                                          DataColumn(
                                            label: const Text('Amount'),
                                            onSort: setSort,
                                          ),
                                          const DataColumn(
                                            label: Text('Action'),
                                          ),
                                        ],
                                        //Optianl override to support custom data row text / translation
                                        getFooterRowText: (startRow,
                                            pageSize,
                                            totalFilter,
                                            totalRowsWithoutFilter) {
                                          final localizations =
                                              MaterialLocalizations.of(context);
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
                                                'filtered from ($totalRowsWithoutFilter)';
                                          }
                                          return amountText;
                                        },
                                        customTableFooter: _customFooter
                                            ? (source, offset) {
                                                const maxPagesToShow = 6;
                                                const maxPagesBeforeCurrent = 3;
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
                                                      MainAxisAlignment.end,
                                                  children: pageList
                                                      .map(
                                                        (e) => TextButton(
                                                          onPressed:
                                                              e != currentPage
                                                                  ? () {
                                                                      //Start index is zero based
                                                                      source
                                                                          .setNextView(
                                                                        startIndex:
                                                                            (e - 1) *
                                                                                _rowsPerPage,
                                                                      );
                                                                    }
                                                                  : null,
                                                          child: Text(
                                                            e.toString(),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                );
                                              }
                                            : null,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setSort(int i, bool asc) => setState(() {
        _sortIndex = i;
        _sortAsc = asc;
      });
}

typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);

class ExampleSource extends AdvancedDataTableSource<teacherModal> {
  List<String> selectedIds = [];
  String lastSearchTerm = '';
  final storage = const FlutterSecureStorage();
  final FeesApiService apiService = FeesApiService();
  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds, doOperations);
  @override
  int get selectedRowCount => selectedIds.length;

  // ignore: avoid_positional_boolean_parameters
  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void _doDelete(BuildContext context, id) {
    final FeesApiService apiService = FeesApiService();
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
            apiService
                .deletefeesElementRow(id)
                .whenComplete(() => setNextView());
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
      GoRouter.of(context).go('${RouteUri.crudDetail}?id=$id');
      print('EDIT');
    }
    if (operationType == 'DETAILS') {
      print('DETAILS');
    }
    if (operationType == 'DELETE') {
      print('DELETE');
      _doDelete(context, id);
      // deleteConfirmationDialog(context, id);
    }
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<teacherModal>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    //the remote data source has to support the pagaing and sorting
    /*final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
    };*/
    final response = await apiService.getFeesSturctureList();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var le = data.length;
      return RemoteDataSourceDetails(
        int.parse(le.toString()),
        (data as List<dynamic>)
            .map(
              (json) => teacherModal.fromJson(json as Map<String, dynamic>),
            )
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty ? (data).length : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}
