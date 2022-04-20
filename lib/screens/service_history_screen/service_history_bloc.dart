import 'dart:convert';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class ServiceHistoryBloc extends BaseNetwork {
  // ignore: close_sinks
  PublishSubject<ResponseVO> serviceHistoryController = PublishSubject();

  Stream<ResponseVO> serviceHistoryStream() => serviceHistoryController.stream;

  getServiceHistory(Map<String, String> map) {

    SharedPref.getData(key: SharedPref.complain_ticket).then((value) {
      if(value!=null && value.toString() != 'null'){
        ResponseVO resp = ResponseVO();
        resp.data = ServiceHistoryResponse.fromJson(json.decode(value)).data;
        serviceHistoryController.sink.add(resp);
      }
    });

    SharedPref.getData(key: SharedPref.token).then((value) {
      postReq(SERVICE_TICKET_RUL,
          token: json.decode(value),
          params: map, onDataCallBack: (ResponseVO resp) {

            SharedPref.setData(SharedPref.complain_ticket,json.encode(resp.data));

            if (resp.data['status'] == 'Success') {
              resp.data = ServiceHistoryResponse.fromJson(resp.data)
                  .data; // return history list
            }
            serviceHistoryController.sink.add(resp);
          }, onErrorCallBack: (ResponseVO resp) {
            serviceHistoryController.sink.add(resp);
          });
    });

  }

  dispose() {
    serviceHistoryController.close();
  }
}
