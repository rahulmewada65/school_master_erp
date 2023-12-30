import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';

class ClassProfileApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();

  var studentProfileUrl =
      '${Constants.BASE_URL}/studentFeesStructure/getByStudentId/';
  var feeurl = '${Constants.BASE_URL}/feesElement/';
  var strucurl = '${Constants.BASE_URL}/feesStructure/';
  var clsurl = '${Constants.BASE_URL}/class';
  var clsurl2 = '${Constants.BASE_URL}/classAssign/students';

  // /api/studentFeesStructure/getByStudentId/2/2022-24

  Future<Response> getClassStudentList() async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http('localhost:8080', '/api/class');
    final res = await get(requestUri, headers: headers);
    print(res.body);
    return res;
  }

  Future<Response> deleteClass(String id) async {
    var userUrl = Uri.parse('${Constants.BASE_URL}/class/$id');
    final res = await client.delete(userUrl);
    return res;
  }

  Future<Response> getClassStudentById(String id) async {
    var token = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var userUrl = Uri.parse('${Constants.BASE_URL}/classAssign/classId$id');
    print(userUrl);
    final res = await get(userUrl, headers: headers);
    //  print(res);
    return res;
  }

  Future<Response?> assignStudentInClass(
    Map<String, dynamic> formData,
  ) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    print(clsurl);
    print(formData);
    var userUrl = Uri.parse(clsurl2);
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }
}
