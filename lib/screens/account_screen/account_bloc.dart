import 'dart:convert';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/account_screen/account_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc extends BaseNetwork {
  // ignore: close_sinks
  PublishSubject<ResponseVO> accountController = PublishSubject();

  Stream<ResponseVO> accountStream() => accountController.stream;

   getAccountData(Map<String, String> map) {

     SharedPref.getData(key: SharedPref.account).then((value) {
       if(value!=null && value.toString() != 'null'){
         ResponseVO resp = ResponseVO();

         if(AccountResponse.fromJson(json.decode(value)).errorCode == SESSION_EXPIRE)
           {
             resp.message = MsgState.error;
             accountController.sink.add(resp);
           }
         else{
           resp.data = AccountResponse.fromJson(json.decode(value)).data;
           resp.message = MsgState.success;
           accountController.sink.add(resp);
         }

       }
     });

     SharedPref.getData(key: SharedPref.token).then((value) {
       if(value != null) {
         postReq(ACCOUNT_URL,
             token: json.decode(value),
             params: map,
             onDataCallBack: (ResponseVO resp) {
               SharedPref.setData(SharedPref.account, json.encode(resp.data));

               if (resp.data['status'] == 'Success') {
                 resp.data = AccountResponse.fromJson(resp.data).data;
                 //test
                 resp.message = MsgState.success;
               }
               accountController.sink.add(resp);
             },
             onErrorCallBack: (ResponseVO resp) {
               accountController.sink.add(resp);
             });
       }

     });
   
  }

  dispose(){
     accountController.close();
  }
}
