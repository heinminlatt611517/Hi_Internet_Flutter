import 'dart:convert';

import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

import 'check_create_user_response.dart';

class CheckCreateUserBloc extends BaseNetwork {
  // ignore: close_sinks
  PublishSubject<ResponseVO> checkCreateUserController = PublishSubject();

  Stream<ResponseVO> checkCreateUserStream() =>
      checkCreateUserController.stream;

  checkCreateUser(Map<String, String> map) {

    SharedPref.getData(key: SharedPref.token).then((value) {
      if (value != null) {
        postReq(SERVICE_CREATE_USER_URL, token: json.decode(value), params: map,
            onDataCallBack: (ResponseVO resp) {


          if (resp.data['status'] == 'Success') {

            resp.data = CreateUserResponse.fromJson(resp.data);
            CreateUserResponse createUserResponseVO = resp.data;

            if(createUserResponseVO.checkCreateduser == 'fail'){
              resp.message = MsgState.error;
            }
            else if(createUserResponseVO.checkCreateduser == 'success'){
              resp.message = MsgState.success;
            }
            print(resp.message);
          }

          checkCreateUserController.sink.add(resp);
        }, onErrorCallBack: (ResponseVO resp) {
          checkCreateUserController.sink.add(resp);
        });
      }
    });
  }

  dispose() {
    checkCreateUserController.close();
  }
}
