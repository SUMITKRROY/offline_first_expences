

import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient(){
    dio = Dio(
      BaseOptions(
        baseUrl: "",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        }

      )
    );
    _setupInterceptors;
  }


  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authentication token here
          // options.headers['Authorization'] = 'Bearer $token';

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

}