import 'dart:convert';
import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/service_issue_screen/service_complain_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hiinternet/helpers/shared_pref.dart';


class SendServiceComplainBloc extends BaseNetwork{


  // ignore: close_sinks
  PublishSubject<ResponseVO> sendComplainController = PublishSubject();

  Stream<ResponseVO> serviceComplainStream() => sendComplainController.stream;


  sendServiceComplain(Map<String,String> map){

    ResponseVO resp = ResponseVO(message: MsgState.loading);
    sendComplainController.sink.add(resp);

    SharedPref.getData(key: SharedPref.token).then((value) {
      if(value != null) {
        print('MAP: ' + map.toString());
        postReq(SAVE_SERVICE_TICKET_URL, params: map, token: json.decode(value), onDataCallBack:(ResponseVO resp) {
          print("SERVICE_COMPLAIN");
          print(json.encode(resp.data));
          print(resp.toString());

          ServiceComplainResponseVO serviceComplainVO = ServiceComplainResponseVO.fromJson(resp.data);

          print("STATUS: " + serviceComplainVO.status);
          print("RESP STATUS: " + resp.data['status']);

          if (serviceComplainVO != null && serviceComplainVO.status == 'Success') {
            print("ON S Success");
            resp.data = ServiceComplainResponseVO.fromJson(resp.data);
            resp.message = MsgState.success;
          }
          else {
            print("ON S Fail");
            resp.message = MsgState.error;
          }

          sendComplainController.sink.add(resp);

        }, onErrorCallBack: (ResponseVO resp) {
          sendComplainController.sink.add(resp);
        });

      }
    });

  }

  dispose(){
    sendComplainController.close();
  }

}

