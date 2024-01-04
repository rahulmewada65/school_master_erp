import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html; // Import dart:html
import 'dart:math';
import 'dart:ui';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app_router.dart';
import '../../../constants/dimens.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';
import '../../../services/export_api_service.dart';
import '../../../theme/theme_extensions/app_data_table_theme.dart';
import '../../../utils/app_focus_helper.dart';
import '../../widgets/card_elements.dart';
import '../../widgets/portal_master_layout/portal_master_layout.dart';
import 'company_contact.dart';



class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class CrudScreen extends StatefulWidget {
  const CrudScreen({Key? key}) : super(key: key);

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  var _rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final _source = ExampleSource();
  var _sortIndex = 0;
  var _sortAsc = true;
  final _searchController = TextEditingController();
  final _customFooter = false;
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiService apiService = ApiService();
  final ExportApiService exportApiService = ExportApiService();
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
    ButtonStyle buttonStyle = const ButtonStyle();
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
                    title: 'STUDENT LIST',
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
                                        onSubmitted: (value) {
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
                                                // print(_source.selectedIds);
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
                                              icon: const Icon(Icons.picture_as_pdf),
                                              tooltip: 'Export as PDF',
                                              onPressed: () =>{
                                              exportData("pdf")
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          exportData("excel");
                                        },
                                        style: buttonStyle,
                                        child: SizedBox(
                                          height: 40.0,
                                          child: Tooltip(
                                            message: 'Export as Excel',
                                            child: SvgPicture.string(
                                              '''<?xml version="1.0" ?><!DOCTYPE svg  PUBLIC '-//W3C//DTD SVG 1.1//EN'  'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'><svg enable-background="new 0 0 0 0" height="30px" id="Layer_1" version="1.1" viewBox="0 0 30 30" width="30px" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g><path clip-rule="evenodd" d="M28.705,7.506l-5.461-6.333l-1.08-1.254H9.262   c-1.732,0-3.133,1.403-3.133,3.136V7.04h1.942L8.07,3.818c0.002-0.975,0.786-1.764,1.758-1.764l11.034-0.01v5.228   c0.002,1.947,1.575,3.523,3.524,3.523h3.819l-0.188,15.081c-0.003,0.97-0.79,1.753-1.759,1.761l-16.57-0.008   c-0.887,0-1.601-0.87-1.605-1.942v-1.277H6.138v1.904c0,1.912,1.282,3.468,2.856,3.468l17.831-0.004   c1.732,0,3.137-1.41,3.137-3.139V8.966L28.705,7.506" fill="black" fill-rule="evenodd"/><path d="M20.223,25.382H0V6.068h20.223V25.382 M1.943,23.438h16.333V8.012H1.943" fill="green"/><polyline fill="green" points="15.73,20.822 12.325,20.822 10.001,17.538 7.561,20.822 4.14,20.822 8.384,15.486 4.957,10.817    8.412,10.817 10.016,13.355 11.726,10.817 15.242,10.817 11.649,15.486 15.73,20.822  "/></g></svg>''',
                                              width: 20,
                                              height: 20,
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
                                              onPressed: () =>
                                                  GoRouter.of(context)
                                                      .go(RouteUri.form),
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
                                            label: const Text('Roll Number'),
                                            onSort: setSort,
                                          ),
                                          DataColumn(
                                            label: const Text('First name'),
                                            onSort: setSort,
                                          ),
                                          // DataColumn(
                                          //   label: const Text('Last name'),
                                          //   onSort: setSort,
                                          // ),
                                          // const DataColumn(
                                          //   label: Text('WhatsApp'),
                                          // ),
                                          DataColumn(
                                            label: const Text('Phone'),
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
                                            //Filtered data source show addtional information
                                            amountText +=
                                                ' filtered from ($totalRowsWithoutFilter)';
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

  Future<void> exportData(type) async {
    final response = await exportApiService.exportStudentList(type);
    if (response.statusCode == 200) {
      var fileName = "";
      if(type=="excel"){
         fileName = 'students.xlsx';
      }else{
         fileName = 'students.pdf';
      }
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName) // Set the file name
        ..click(); // Simulate a click to start the download
      // Revoke the object URL when done to release browser memory
      html.Url.revokeObjectUrl(url);
    } else {
      // Handle unsuccessful response (e.g., show an error message)
    }
  }

}

typedef SelectedCallBack = Function(String id, bool newSelectState);
typedef OperationCallBack = Function(
    String id, BuildContext context, String oprationType);

class ExampleSource extends AdvancedDataTableSource<CompanyContact> {
  List<String> selectedIds = [];
  String lastSearchTerm = '';
  final storage = const FlutterSecureStorage();
  ApiService apiService = ApiService();
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

  @override
  Future<RemoteDataSourceDetails<CompanyContact>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    //the remote data source has to support the pagaing and sorting
    final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      if (lastSearchTerm.isNotEmpty) 'companyFilter': lastSearchTerm,
    };

    final response = await apiService.getStudentList(queryParameter);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RemoteDataSourceDetails(
        int.parse(data['totalRows'].toString()),
        (data['rows'] as List<dynamic>)
            .map(
              (json) => CompanyContact.fromJson(json as Map<String, dynamic>),
            )
            .toList(),
        filteredRows: lastSearchTerm.isNotEmpty
            ? (data['rows'] as List<dynamic>).length
            : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}

