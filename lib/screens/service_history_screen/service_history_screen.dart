import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hiinternet/screens/home_screen/check_create_user_bloc.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/providers/service_history_ticket.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_bloc.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_response.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_screen.dart';
import 'package:hiinternet/widgets/service_history_item.dart';
import 'package:provider/provider.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class ServiceHistoryScreen extends StatefulWidget {
  static const routeName = '/service_history';

  @override
  _ServiceHistoryScreenState createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {

  final _serviceHistoryBloc = ServiceHistoryBloc();
  final _checkCreateUserBloc = CheckCreateUserBloc();
  var userId;

  int changePageIndex = 0;

  @override
  void initState() {

    changePageIndex = 0;

    SharedPref.getData(key: SharedPref.user_id).then((value) {
      if (value != null && value.toString() != 'null') {
        userId = json.decode(value).toString();
        Map<String, String> map = {
          'user_id': userId,
          'app_version': app_version,
        };
        _serviceHistoryBloc.getServiceHistory(map);
      }
    });

    _checkCreateUserBloc.checkCreateUserStream().listen((ResponseVO resp) {
      if(resp.message == MsgState.error){
        showCheckCreateUserDialog(context, 'fail');
      }
      else if(resp.message == MsgState.success){
        setState(() {
          changePageIndex = 1;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  changePageIndex == 1 ? ServiceIssueScreen() : Scaffold(
      /*
        appBar: AppBar(
        title: Text(
          'My Complain',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),*/
      body: StreamBuilder<ResponseVO>(
        stream: _serviceHistoryBloc.serviceHistoryStream(),
        initialData: ResponseVO(message: MsgState.loading),
        builder: (context, snapshot) {
          ResponseVO resp = snapshot.data;
          if (resp.message == MsgState.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(resp.message == MsgState.error){
            return Center(
              //child: Text('Something wrong,try again...'),
              child: Text((SharedPref.IsSelectedEng()) ? StringsEN.something_wrong : StringsMM.something_wrong),
            );
          }
          else {
            List<ServiceHistoryVO> list = resp.data;
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return ServiceHistoryItems(
                  list[index],
                );
              },
              itemCount: list.length,
              //scrollDirection:Axis.horizontal,
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        //heroTag: 'service issue',
        heroTag: (SharedPref.IsSelectedEng()) ? StringsEN.service_issue : StringsMM.service_issue,
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          //Navigator.pushReplacementNamed(context, ServiceIssueScreen.routeName);
            checkCreateUser();

        },
      ),
    );
  }

  void showCheckCreateUserDialog(BuildContext context, String status) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
          child: Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(4),
            child: Material(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/error_big.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Fail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Ticket can\'t be created as we are working\nfor your current ticket',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Container(
                        width: 300,
                        child: RaisedButton(
                            color: Colors.blueAccent,
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              if (status == 'success') {
                                setState(() {
                                  changePageIndex = 1;
                                });
                                Navigator.of(context).pop();
                              }
                              else{
                                Navigator.of(context).pop();
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void checkCreateUser() {
    SharedPref.getData(key: SharedPref.user_id).then((value) {
      if (value != null && value.toString() != 'null') {
        userId = json.decode(value).toString();
        Map<String, String> map = {
          'user_id': userId,
          'app_version': app_version,
        };
        _checkCreateUserBloc.checkCreateUser(map);
      }
    });
  }

  @override
  void dispose() {
    _serviceHistoryBloc.dispose();
    _checkCreateUserBloc.dispose();
    super.dispose();
  }
}
