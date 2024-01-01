import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';

class ExportApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();
  var exburl1 = '${Constants.BASE_URL}/student/';

  Future<Response> exportStudentList(String suburl1) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    var requestUri = Uri.parse(exburl1+suburl1);
    print(requestUri);
    final res = await client.get(requestUri, headers: headers);
    return res;
  }
}
