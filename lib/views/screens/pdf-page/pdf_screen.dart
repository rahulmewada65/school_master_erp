import 'package:flutter/material.dart';
import 'package:school_master_erp/views/screens/pdf-page/pages/invoices.dart';



class PdfScreen extends StatelessWidget {
  const PdfScreen ({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InvoicePage(),
    );
  }
}
