import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';

class ExamApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();

  var studentProfileUrl =
      '${Constants.BASE_URL}/studentFeesStructure/getByStudentId/';
  var feeurl = '${Constants.BASE_URL}/feesElement/';
  var strucurl = '${Constants.BASE_URL}/feesStructure/';
  var suburl = '${Constants.BASE_URL}/subject';
  var examurl = '${Constants.BASE_URL}/exam';

  // /api/studentFeesStructure/getByStudentId/2/2022-24

  Future<Response> getExamList() async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http('localhost:8080', '/api/subject');
    final res = await get(requestUri, headers: headers);
    print(res.body);
    return res;
  }

  Future<Response> getExamById(String id) async {
    var token = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var userUrl =
        Uri.parse('${Constants.BASE_URL}/exam/$id');
    final res = await get(userUrl, headers: headers);
    return res;
  }


  Future<Response?> addExamApi(
      Map<String, dynamic> formData,
      ) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    var userUrl = Uri.parse(examurl);
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }
}
