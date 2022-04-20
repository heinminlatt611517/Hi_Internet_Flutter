import 'dart:convert';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class ServiceIssueBloc extends BaseNetwork {
  // ignore: close_sinks
  PublishSubject<ResponseVO> serviceIssueController = PublishSubject();

  Stream<ResponseVO> serviceIssueStream() => serviceIssueController.stream;

  getServiceIssueCategory(Map<String, String> map) {


    SharedPref.getData(key: SharedPref.complain_category).then((value) {
      if(value!=null && value.toString() != 'null'){
        ResponseVO resp = ResponseVO();
        resp.data = ServiceIssueResponse.fromJson(json.decode(value)).list;
        serviceIssueController.sink.add(resp);
      }
    });


    SharedPref.getData(key: SharedPref.token).then((value){
      postReq(COMPLAIN_CATEGORY_URL,
          params: map,
          token: json.decode(value),
          onDataCallBack: (ResponseVO resp) {

            SharedPref.setData(SharedPref.complain_category,json.encode(resp.data));

            if (resp.data['status'] == 'Success') {
              resp.data = ServiceIssueResponse.fromJson(resp.data).list;
            }
            serviceIssueController.sink.add(resp);
            print(resp.data);

          }, onErrorCallBack: (ResponseVO resp) {
            serviceIssueController.sink.add(resp);
          });
    });

  }

  dispose() {
    serviceIssueController.close();
  }
}
