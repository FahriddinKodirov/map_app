import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_app/data/api/custom_excaptions.dart';

class ApiClient {
 
 ApiClient(){
  _init();
 }

 late Dio dio;

 _init(){
  dio = Dio(
    BaseOptions(
      baseUrl: "https://geocode-maps.yandex.ru/1.x/",
      connectTimeout: 25000,
      receiveTimeout: 20000,
    )
  );
  dio.interceptors.add(InterceptorsWrapper(
   
   onError: (error, handler) {
    print('ERRORga KIRDI');
    switch(error.type){
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      throw DeadlineExceededException(error.requestOptions);
      case DioErrorType.receiveTimeout:
      throw DeadlineExceededException(error.requestOptions);
      case DioErrorType.response:
        switch(error.response?.statusCode){
           case 400:
            throw BadRequestException(error.response?.data['message']);
           case 401:
            throw UnauthorizedException(error.requestOptions);
           case 404:
            throw NotFoundException(error.requestOptions);
           case 409:
            throw ConflictException(error.requestOptions);
           case 500:
           case 501:
           case 503:
            throw InternalServerErrorException(error.requestOptions);
         }
       break;
      case DioErrorType.cancel:
       break;
      case DioErrorType.other:
       throw NoInternetConnectionException(error.requestOptions);
     }     
       debugPrint('Error Status Code:${error.response?.statusCode}');
       return handler.next(error);
     
   },
   onRequest: (options, handler) {
        print('SOROV YUBORILDI');
        String currentLocal = 'uz';
        options.headers['Accept'] = 'application/json';
        options.headers['Accept-language'] = 
        currentLocal.isEmpty ? 'ru' :currentLocal;
    return handler.next(options);
   },
   onResponse: (e, handler) {
     print('RESPONS KELDI');
     return handler.next(e);
   }, 

  ));
 }
}