import 'dart:convert';
import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseNetwork{
  // ignore: close_sinks
  PublishSubject<ResponseVO> homeController = PublishSubject();

  Stream<ResponseVO> homeStream() => homeController.stream;

  getHomeData(Map<String,String> map){
    SharedPref.getData(key: SharedPref.home).then((value) {
      if(value!=null && value.toString() != 'null'){

        ResponseVO resp = ResponseVO();
        resp.data = HomeDataResponse.fromJson(json.decode(value)).list;
        homeController.sink.add(resp);
      }
    });


      postReq(PROMO_SLIDER_URL,
          token: '',
          params: map,
          onDataCallBack: (ResponseVO resp) {
            SharedPref.setData(SharedPref.home, json.encode(resp.data));
            if(resp.data['status'] == 'Success'){
              resp.data = HomeDataResponse.fromJson(resp.data).list;
            }

            homeController.sink.add(resp);

          },
          onErrorCallBack: (ResponseVO resp) {
            homeController.sink.add(resp);
          });

  }

  dispose(){
    homeController.close();
  }

}