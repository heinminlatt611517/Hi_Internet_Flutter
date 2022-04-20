import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';

enum RequestType {
  GET,
  POST,
}

class BaseNetwork {
  void getReq(String url,
      {Map<String, String> params,
        String token,
        Function onDataCallBack,
        Function onErrorCallBack}) async {

    requestData(RequestType.GET,
        url: url,
        params: params,
        token: token,
        onDataCallBack: onDataCallBack,
        onErrorCallBack: onErrorCallBack);
  }

  void postReq(String url,
      {Map<String, String> params,
        FormData fd,
        String token,
        Function onDataCallBack,
        Function onErrorCallBack}) async {

    requestData(RequestType.POST, url: url,
        params: params,
        fd: fd,
        token: token,
        onDataCallBack: onDataCallBack,
        onErrorCallBack: onErrorCallBack);
  }

  Future<void> requestData(RequestType requestType,
      {@required String url,
        Map<String, String> params,
        FormData fd,
        String token,
        Function onDataCallBack,
        Function onErrorCallBack}) async {

    // String token = await SharedPref.getData(key: SharedPref.token);

    BaseOptions options = BaseOptions();
    options.connectTimeout = 10000;
    options.receiveTimeout = 10000;
    options.headers['content-Type'] = 'application/json';
    options.headers["token"] = token;


    Dio dio = Dio(options);


    try {
      Response response;

      if (requestType == RequestType.GET) {
        if (params == null) {
          response = await dio.get(url);
        } else {
          response = await dio.get(url, queryParameters: params);
        }
      }

      if (requestType == RequestType.POST) {
        if (params != null || fd != null) {
          response = await dio.post(url, data: fd ?? params);
        } else {
          response = await dio.post(url);
        }
      }

      int statusCode = response.statusCode;

      ResponseVO responseVO = new ResponseVO();
      if (statusCode == 200) {
        responseVO.data = response.data;
        responseVO.message = MsgState.data;
        onDataCallBack(responseVO);
      } else {
        responseVO.message = MsgState.error;
        responseVO.error = ErrorState.serverError;
        onErrorCallBack(responseVO);
        //error
      }
    } catch (error) {
      ResponseVO responseVO = new ResponseVO();
      responseVO.message = MsgState.error;
      responseVO.error = ErrorState.serverError;
      onErrorCallBack(responseVO);
    }
  }
}
