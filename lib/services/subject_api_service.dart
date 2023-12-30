import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';

class SubjectApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();

  var studentProfileUrl =
      '${Constants.BASE_URL}/studentFeesStructure/getByStudentId/';
  var feeurl = '${Constants.BASE_URL}/feesElement/';
  var strucurl = '${Constants.BASE_URL}/feesStructure/';
  var suburl = '${Constants.BASE_URL}/subject';

  // /api/studentFeesStructure/getByStudentId/2/2022-24

  Future<Response> getSubjectList() async {
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

  Future<Response> deleteSubject(String id) async {
    var userUrl = Uri.parse('${Constants.BASE_URL}/subject/$id');
    final res = await client.delete(userUrl);
    return res;
  }

  Future<Response> getFeeDetailsBySessionAndStudentId(
      String id, String session) async {
    var token = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var userUrl =
        Uri.parse('${Constants.BASE_URL}/payFees/getByStudentId/$id/$session');
    final res = await get(userUrl, headers: headers);
    return res;
  }

  Future<Response?> addSubjectApi(
    Map<String, dynamic> formData,
  ) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    print(suburl);
    print(formData);
    var userUrl = Uri.parse(suburl);
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }

  Future<Response?> addStudentFeeSturcture_WithSession(
    Map<String, dynamic> formData,
  ) async {
    // print("Rahul----------{$formData}");
    var tokan = await storage.read(key: "accessToken");
    print(tokan);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };

    var userUrl = Uri.parse('${Constants.BASE_URL}/studentFeesStructure/save');
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }

  Future<Response?> submitFee(formData) async {
    // print("Rahul----------{$formData}");
    var tokan = await storage.read(key: "accessToken");
    print(formData);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };

    var userUrl = Uri.parse('${Constants.BASE_URL}/payFees/save');
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }
}
