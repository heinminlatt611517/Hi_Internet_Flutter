import 'dart:convert';
import 'dart:io';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/payment_screen/payment_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc extends BaseNetwork {
  // ignore: close_sinks
  PublishSubject<ResponseVO> paymentController = PublishSubject();

  Stream<ResponseVO> paymentStream() => paymentController.stream;

  getPayment(Map<String, String> map) {
    SharedPref.getData(key: SharedPref.payment).then((value) {
      if(value!=null && value.toString() != 'null'){
        ResponseVO resp = ResponseVO();

        if(PaymentListsResponse.fromJson(json.decode(value)).errorCode == SESSION_EXPIRE)
        {
          resp.message = MsgState.error;
          paymentController.sink.add(resp);
        }
        else{
          resp.data = PaymentListsResponse.fromJson(json.decode(value)).list;
          resp.message = MsgState.success;
          paymentController.sink.add(resp);

        }

      }
    });

     SharedPref.getData(key: SharedPref.token).then((value) {
       if(value != null){
         postReq(PAYMENT_URL,
             token: json.decode(value),
             params: map, onDataCallBack: (ResponseVO resp) {

               SharedPref.setData(SharedPref.payment,json.encode(resp.data));

               if (resp.data['status'] == 'Success') {
                 resp.data = PaymentListsResponse.fromJson(resp.data).list;
                 resp.message = MsgState.success;//payment list
               } else {
                 print("FAIL");
                 print(resp.data.toString());
               }
               paymentController.sink.add(resp);
             }, onErrorCallBack: (ResponseVO resp) {
               paymentController.sink.add(resp);
             });
       }
     });
     
  }

  dispose() {
    paymentController.close();
  }
}
