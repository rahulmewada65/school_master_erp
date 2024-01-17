
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';
import 'package:http/http.dart' as http;

class DocumentApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();

  // var studentProfileUrl =
  //     '${Constants.BASE_URL}/studentFeesStructure/getByStudentId/';
  // var feeurl = '${Constants.BASE_URL}/feesElement/';
  // var strucurl = '${Constants.BASE_URL}/feesStructure/';
  // var suburl = '${Constants.BASE_URL}/subject';

  // /api/studentFeesStructure/getByStudentId/2/2022-24

  // Future<Response> getSubjectList() async {
  //   var tokan = await storage.read(key: "accessToken");
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $tokan'
  //   };
  //   //var userUrl = Uri.parse('${studentUrl}get',);
  //   final requestUri = Uri.http('localhost:8080', '/api/subject');
  //   final res = await get(requestUri, headers: headers);
  //  // print(res.body);
  //   return res;
  // }
  //


  Future<Response> deleteDocumentById(String id) async {
    var userUrl = Uri.parse('${Constants.BASE_URL}/subject/$id');
    final res = await client.delete(userUrl);
    return res;
  }


  Future<Response> getDocumentById(
      String id) async {
    var token = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Autvar ': 'Bearer $token'
    };
    var userUrl =
        Uri.parse('${Constants.BASE_URL}/getDocumentByStudentId/$id');
    final res = await get(userUrl, headers: headers);
    return res;
  }



  Future<void> uploadDocument({
    required filesData,
    required String studentId,
  }) async {
    var url = Uri.parse('${Constants.BASE_URL}/upload-document');
    var request = MultipartRequest('POST', url);
    request.fields['studentId'] =  studentId ;
    if (filesData.containsKey('fileBytes') && filesData['fileBytes'] is Uint8List) {
      var fileBytes = filesData['fileBytes'] as Uint8List;
      var multipartFile = MultipartFile.fromString(
        'files',
        filesData,
      );
      request.files.add(multipartFile);
    } else {
      print('Invalid or missing file data');
      return;
    }

    try {
      print("ok-1");
      var streamedResponse = await request.send();
      print(streamedResponse);
      var response = await Response.fromStream(streamedResponse);
      print(response.statusCode);
      print(response.body);
    } catch (e, stackTrace) {
      print('Error uploading file: $e');
      print('Stack trace: $stackTrace');
    }

  }


  // Future<Response?> upLoadDocument(
  // List<Map<String, dynamic>> formData, id
  //     ) async {
  //   var tokan = await storage.read(key: "accessToken");
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $tokan'
  //   };
  //
  //   print(formData);
  //   print(id);
  //   var userUrl = Uri.parse('${Constants.BASE_URL}/upload-document/studentId?$id');
  //   var res = await post(
  //     userUrl,
  //     body:jsonEncode(formData),
  //     headers: headers,
  //   );
  //
  //   print(res);
  //   return res;
  // }


  // Future<http.Response?> uploadDocument(String filePath, String id) async {
  //   var token = await storage.read(key: "accessToken");
  //   var headers = {
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('${Constants.BASE_URL}/upload-document/studentId?$id'),
  //   );
  //
  //   var file = File(filePath);
  //   var stream = ByteStream(file.openRead());
  //   var length = await file.length();
  //   var multipartFile = MultipartFile(
  //     'file',
  //     stream,
  //     length,
  //     filename: file.path.split('/').last, // Extract file name
  //   );
  //
  //   request.files.add(multipartFile);
  //   request.headers.addAll(headers);
  //
  //   try {
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //     print(response.statusCode);
  //     print(response.body);
  //     return response;
  //   } catch (e) {
  //     print('Error uploading document: $e');
  //     return null;
  //   }
  // }
  // Future<Response?> uploadDocument(List<Map<String, dynamic>> formData, String id) async {
  //   var token = await storage.read(key: "accessToken");
  //   var headers = {
  //     'Content-Type': 'multipart/form-data',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   var request = MultipartRequest(
  //     'POST',
  //     Uri.parse('${Constants.BASE_URL}/upload-document'),
  //   );
  //
  //   // Assuming 'formData' contains information about the files to be uploaded
  //   for (var item in formData) {
  //     if (item.containsKey('file')) {
  //       var file = File(item['file']); // Assuming 'file' key contains file path
  //       var stream = ByteStream(file.openRead());
  //       var length = await file.length();
  //       var multipartFile = MultipartFile(
  //         'file', // Field name for the file in the form data
  //         stream,
  //         length,
  //         filename: basename(file.path),
  //       );
  //       request.files.add(multipartFile);
  //     } else {
  //       // If there are other form fields to be added
  //       request.fields[item['fieldName']] = item['fieldValue'];
  //     }
  //   }
  //
  //   request.headers.addAll(headers);
  //
  //   try {
  //     var response = await Response.fromStream(await request.send());
  //     print(response.statusCode);
  //     print(response.body);
  //     return response;
  //   } catch (e) {
  //     print('Error uploading document: $e');
  //     return null;
  //   }
  // }
}
