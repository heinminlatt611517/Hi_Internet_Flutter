
import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';

class FirebaseTokenSenderBloc extends BaseNetwork{

  sendFirebaseTokenToServer(Map<String,String> map){

    postReq(LOGIN_URL, params: map, onDataCallBack:(ResponseVO resp){
      print("FirebaseTokenSenderBloc: Success");
    },onErrorCallBack: (ResponseVO resp){
      print("FirebaseTokenSenderBloc: Error");
    });

  }

}

