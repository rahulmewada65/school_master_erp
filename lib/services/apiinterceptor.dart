import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class ApiInterceptor implements InterceptorContract {
  final storage = const FlutterSecureStorage();

  Future<String> get tokenOrEmpty async {
    var token = await storage.read(key: "token");
    if (token == null) return "";
    return token;
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String token = await tokenOrEmpty;
    try {
      data.headers["Authorization"] = token;
    } catch (e) {
      print(e);
    }
    print("ok");
    print(data);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
