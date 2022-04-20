import 'dart:convert';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/login_screen/login_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BaseNetwork{

  // ignore: close_sinks
  PublishSubject<ResponseVO> loginController = PublishSubject();

  Stream<ResponseVO> loginStream() => loginController.stream;
  
  login(Map<String,String> map){

    ResponseVO resp = ResponseVO(message: MsgState.loading);
    loginController.sink.add(resp);


    postReq(LOGIN_URL,params: map,onDataCallBack:(ResponseVO resp){

      if (resp.data['status'] == 'Success') {
        resp.data = LoginVO.fromJson(resp.data);
        LoginVO loginVO = resp.data;

        SharedPref.setData(SharedPref.token, json.encode(loginVO.token));

        SharedPref.setData(SharedPref.user_id, json.encode(loginVO.userId));

        SharedPref.setData(SharedPref.user_phone, json.encode(loginVO.phone));

        SharedPref.setData(SharedPref.payment_method_url, json.encode(loginVO.paymentChannel));

        resp = ResponseVO(message: MsgState.success);//payment list
      }
      loginController.sink.add(resp);

    },onErrorCallBack: (ResponseVO resp){
      loginController.sink.add(resp);
    });
  }

  dispose() {
    loginController.close();
  }



}