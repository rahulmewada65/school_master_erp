import 'package:flutter/material.dart';
import 'package:school_master_erp/root_app.dart';
import 'environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Environment.init(
    apiBaseUrl: 'https://example.com',
  );

  runApp(const RootApp());
}
