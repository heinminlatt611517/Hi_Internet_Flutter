import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/account_screen/account_bloc.dart';
import 'package:hiinternet/screens/account_screen/account_response.dart';
import 'package:hiinternet/screens/tabs_screen/tab_screen.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account_screen';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _accountBloc = AccountBloc();
  var userId;
  bool showErrorMessage = true;

  @override
  void initState() {
    SharedPref.getData(key: SharedPref.user_id).then((value) {
      if (value != null && value.toString() != 'null') {
        userId = json.decode(value).toString();
        Map<String, String> map = {
          'user_id': userId,
          'app_version': app_version,
        };
        _accountBloc.getAccountData(map);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: StreamBuilder<ResponseVO>(
              builder: (context, snapshot) {
                ResponseVO resp = snapshot.data;

                if (resp.message == MsgState.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

               else if (resp.message == MsgState.error) {
                  showSessionExpireDialog(true,'Fail','Session Expire');
                  showErrorMessage = false;
                  return Center();
                }

                else if(resp.message == MsgState.success) {
                  AccountVO accountOb = resp.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        accountOb.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                //'Active',
                                (SharedPref.IsSelectedEng()) ? StringsEN.active : StringsMM.active,
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                                textAlign: TextAlign.center,
                              ),
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  accountOb.plan,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                                color: Colors.indigo,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child:
                                    Icon(Icons.supervised_user_circle_rounded),
                              ),
                              title: Text((SharedPref.IsSelectedEng()) ? StringsEN.userID : StringsMM.userID),//'User ID'),
                              subtitle: Text(accountOb.userId),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.phone),
                              ),
                              title: Text((SharedPref.IsSelectedEng()) ? StringsEN.phoneNo : StringsMM.phoneNo),//'Phone Number'),
                              subtitle: Text(accountOb.mobileNo),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.date_range),
                              ),
                              title: Text((SharedPref.IsSelectedEng()) ? StringsEN.activationDate : StringsMM.activationDate),//'Activation Date'),
                              subtitle: accountOb.activateDate == null
                                  ? Text('---------')
                                  : Text(accountOb.activateDate),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.location_on),
                              ),
                              title: Text((SharedPref.IsSelectedEng()) ? StringsEN.address : StringsMM.address),//'Address'),
                              subtitle: Text(accountOb.address),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.5555,
                        child: InkWell(
                          onTap: () {
                            return showDialog(
                                context: context,
                                builder: (ctx) => Center(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.4218,
                                        width: MediaQuery.of(context).size.width * 0.6388,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Container(
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(Icons
                                                          .cancel_presentation)),
                                                ],
                                              ),
                                              Text(
                                                //'Logout',
                                                (SharedPref.IsSelectedEng()) ? StringsEN.logout : StringsMM.logout,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                //'Do you want to logout\nthis application?',
                                                (SharedPref.IsSelectedEng()) ? StringsEN.want_to_logout : StringsMM.want_to_logout,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                                child: RaisedButton(
                                                    color: Colors.blueAccent,
                                                    child: Text(
                                                      //'LOGOUT',
                                                      (SharedPref.IsSelectedEng()) ? StringsEN.logout : StringsMM.logout,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10),
                                                    ),
                                                    onPressed: () {
                                                      logout(context);
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout),
                              Text((SharedPref.IsSelectedEng()) ? StringsEN.signOut : StringsMM.signOut),//'sign out'),
                            ],
                          ),
                        ),
                      )
                    ],
                  );

                }

                else {
                  return Center(
                    child: Text(showErrorMessage ? StringsEN.something_wrong : ''),
                  );
                }
              },
              stream: _accountBloc.accountStream(),
              initialData: ResponseVO(message: MsgState.loading),
            )));
  }


  Future<void> showSessionExpireDialog(bool isSuccess, String status,String message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (_) => Center(
            child: Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              //child: Material(
              //child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/dialog_card_bg.png"),
                  fit: BoxFit.fill,
                ),
                //border: Border.all(color: Colors.grey),
                //borderRadius: BorderRadius.circular(12),
              ),
              //color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(isSuccess ? 'assets/images/done_big.png' : 'assets/images/error_big.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,),
                  Center(
                    child: Text(status,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),),
                  ),
                  Center(
                    //child: Text( "Your ticket ID is $ticketID" ),
                    child: Text(message),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5555,
                      height: MediaQuery.of(context).size.height * 0.0625,
                      child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          child: Text(
                            //'OK',
                            (SharedPref.IsSelectedEng()) ? StringsEN.btn_ok : StringsMM.btn_ok,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            setState(() {
                              SharedPref.clear();
                            });
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
                            //Navigator.pop(ctx);
                          }),
                    ),
                  ),
                ],
              ),
              //),
              //),
            ),
          ));
    });
  }


  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
  }

  void logout(BuildContext context) {
    SharedPref.clear();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
  }
}
