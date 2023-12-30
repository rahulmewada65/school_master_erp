import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import '../helpers/constants.dart';
import 'apiinterceptor.dart';

class FeesApiService {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  final storage = const FlutterSecureStorage();

  var studentUrl = '${Constants.BASE_URL}/student/';
  var feeurl = '${Constants.BASE_URL}/feesElement/';
  var strucurl = '${Constants.BASE_URL}/feesStructure/';

  Future<Response> getMyProfile() async {
    var myProfileUri = Uri.parse('${Constants.BASE_URL}/auth/user/me');
    final res = await client.get(myProfileUri);
    return res;
  }

  Future<Response> getFeesElementList(
      Map<String, dynamic> queryParameter) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http(
      'localhost:8080',
      '/api/feesElement/get',
      queryParameter,
    );
    final res = await get(requestUri, headers: headers);
    return res;
  }

  Future<Response> getFeesSturctureList() async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http('localhost:8080', '/api/feesStructure/getAll');
    final res = await get(requestUri, headers: headers);
    return res;
  }

  Future<Response> getExamList() async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http('localhost:8080', '/api/exam');
    final res = await get(requestUri, headers: headers);
    return res;
  }

  Future<Response> getFeesElementList2() async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    //var userUrl = Uri.parse('${studentUrl}get',);
    final requestUri = Uri.http('localhost:8080', '/api/feesElement/get');
    final res = await get(requestUri, headers: headers);
    return res;
  }

  Future<Response> getStudentById(String id) async {
    var token = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var userUrl = Uri.parse('${Constants.BASE_URL}/student/getById?id=$id');
    final res = await get(userUrl, headers: headers);
    return res;
  }

  Future<void> deletefeesElementRow(String id) async {
    const storage = FlutterSecureStorage();
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    var requestUri =
        Uri.parse('${Constants.BASE_URL}/feesElement/delete?id=$id');
    final response = await delete(requestUri, headers: headers);
    if (response.statusCode == 200) {
      print("Deleted Successfully.");
    }
  }

  Future<void> deletefeeStacture(String id) async {
    const storage = FlutterSecureStorage();
    //  /api/feesStructure/deleteFeesModifiedElement/{id}
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    var requestUri = Uri.parse(
        '${Constants.BASE_URL}/feesStructure/deleteFeesModifiedElement/$id');
    print(requestUri);
    final response = await delete(requestUri, headers: headers);
    if (response.statusCode == 200) {
      print("Deleted Successfully.");
    }
  }

  Future<Response?> addFeesElement(
    Map<String, dynamic> formData,
  ) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };
    var userUrl = Uri.parse('${feeurl}save');
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }

  Future<Response?> addFeesStucture(Map<String, dynamic> formData) async {
    var tokan = await storage.read(key: "accessToken");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokan'
    };

    var userUrl = Uri.parse('${strucurl}save');
    print(tokan);
    print(userUrl);
    // print( type of formData);
    var res = await post(
      userUrl,
      body: jsonEncode(formData),
      headers: headers,
    );
    return res;
  }

  Future<Response> updateStudent(
      int? id, int roleId, String email, String fullname, String phone) async {
    var userUrl = Uri.parse('${Constants.BASE_URL}/users/$id');
    final res = await client.put(userUrl, body: {
      "role_id": roleId.toString(),
      "email": email,
      "fullname": fullname,
      "phone": phone
    });
    return res;
  }

  Future<Response> deleteStudent(String id) async {
    var userUrl = Uri.parse('${Constants.BASE_URL}/users/$id');
    final res = await client.delete(userUrl);
    return res;
  }

  Future<Response> getRoleList() async {
    var rolerUrl = Uri.parse('${Constants.BASE_URL}/roles');
    final res = await client.get(rolerUrl);
    return res;
  }

  Future<Response> getRoleById(String id) async {
    var rolerUrl = Uri.parse('${Constants.BASE_URL}/roles/$id');
    final res = await client.get(rolerUrl);
    return res;
  }

  Future<Response> addRole(String roleName, String roleDescription) async {
    var rolerUrl = Uri.parse('${Constants.BASE_URL}/roles');
    final res = await client.post(rolerUrl,
        body: {"role_name": roleName, "role_description": roleDescription});
    return res;
  }

  Future<Response> updateRole(
      int? id, String roleName, String roleDescription) async {
    var rolerUrl = Uri.parse('${Constants.BASE_URL}/roles/$id');
    final res = await client.put(rolerUrl,
        body: {"role_name": roleName, "role_description": roleDescription});
    return res;
  }

  Future<Response> deleteRole(String id) async {
    var rolerUrl = Uri.parse('${Constants.BASE_URL}/roles/$id');
    final res = await client.delete(rolerUrl);
    return res;
  }

  Future<Response> addPermissiontoRole(int? id, List<int?> permissions) async {
    var permissionUrl =
        Uri.parse('${Constants.BASE_URL}/roles/permissions/$id');
    final res = await client
        .post(permissionUrl, body: {"permissions": jsonEncode(permissions)});
    return res;
  }

  Future<Response> getPermissionList() async {
    var permissionUrl = Uri.parse('${Constants.BASE_URL}/permissions');
    final res = await client.get(permissionUrl);
    return res;
  }

  Future<Response> getPermissionById(String id) async {
    var permissionUrl = Uri.parse('${Constants.BASE_URL}/permissions/$id');
    final res = await client.get(permissionUrl);
    return res;
  }

  Future<Response> addPermission(
      String permName, String permDescription) async {
    var permissionUrl = Uri.parse('${Constants.BASE_URL}/permissions');
    final res = await client.post(permissionUrl,
        body: {"perm_name": permName, "perm_description": permDescription});
    return res;
  }

  Future<Response> updatePermission(
      int id, String permName, String permDescription) async {
    var permissionUrl = Uri.parse('${Constants.BASE_URL}/permissions/$id');
    final res = await client.put(permissionUrl,
        body: {"perm_name": permName, "perm_description": permDescription});
    return res;
  }

  Future<Response> deletePermission(String id) async {
    var permissionUrl = Uri.parse('${Constants.BASE_URL}/permissions/$id');
    final res = await client.delete(permissionUrl);
    return res;
  }

  Future<Response> getProductList() async {
    var productUrl = Uri.parse('${Constants.BASE_URL}/products');
    final res = await client.get(productUrl);
    return res;
  }

  Future<Response> getProductById(String id) async {
    var productUrl = Uri.parse('${Constants.BASE_URL}/products/$id');
    final res = await client.get(productUrl);
    return res;
  }

  Future<Response> addProduct(String prodName, String prodDescription,
      String prodImage, String prodPrice) async {
    var productUrl = Uri.parse('${Constants.BASE_URL}/products');
    final res = await client.post(productUrl, body: {
      "prod_name": prodName,
      "prod_description": prodDescription,
      "prod_image": prodImage,
      "prod_price": prodPrice
    });
    return res;
  }

  Future<Response> updateProduct(int? id, String prodName,
      String prodDescription, String prodImage, String prodPrice) async {
    var productUrl = Uri.parse('${Constants.BASE_URL}/products/$id');
    final res = await client.put(productUrl, body: {
      "prod_name": prodName,
      "prod_description": prodDescription,
      "prod_image": prodImage,
      "prod_price": prodPrice
    });
    return res;
  }

  Future<Response> deleteProduct(String id) async {
    var productUrl = Uri.parse('${Constants.BASE_URL}/products/$id');
    final res = await client.delete(productUrl);
    return res;
  }

  Future<String?> getTokan() async {
    var tokan = await storage.read(key: "accessToken");

    return tokan;
  }
}
