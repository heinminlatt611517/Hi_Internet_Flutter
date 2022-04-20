import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/login_screen/login_bloc.dart';
import 'package:hiinternet/screens/account_screen/account_screen.dart';
import 'package:hiinternet/screens/home_screen/check_create_user_bloc.dart';
import 'package:hiinternet/screens/home_screen/check_create_user_response.dart';
import 'package:hiinternet/screens/home_screen/home_screen.dart';
import 'package:hiinternet/screens/notification_screen/notification_screen.dart';
import 'package:hiinternet/screens/payment_screen/payment_screen.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_screen.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_screen.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'package:hiinternet/data/database_util.dart';
import 'package:hiinternet/data/notification_model.dart';

//import 'package:flutter/'
import 'dart:math' as math;

class TabScreen extends StatefulWidget {
  static const routeName = '/tab_screen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _pages;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedLang = 'ENG';

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Animation<double> _rotateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  bool _validate = false;
  var userIdController = TextEditingController();

  final _loginBloc = LoginBloc();
  final _checkCreateUserBloc = CheckCreateUserBloc();
  var userId;

  GlobalKey<PopupMenuButtonState<int>> _FabPopupKey = GlobalKey();

  FirebaseMessaging messaging;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {}
      }));

    _rotateButton = Tween<double>(
      begin: 0,
      end: math.pi / 4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    // check change

    initializeFirebaseMsg();

    _checkCreateUserBloc.checkCreateUserStream().listen((ResponseVO resp) {
      if(resp.message == MsgState.error){
        showCheckCreateUserDialog(context, 'fail');
      }
      else if(resp.message == MsgState.success){
        setState(() {
          changePageIndex = 6;
          isOpened = false;
        });
      }
    });

    super.initState();
  }

  int _selectedPageIndex = 0;
  int changePageIndex = 0;

  void _selectPage(int index) {
    SharedPref.getData(key: SharedPref.token).then((value) {
      if (value != null && value.toString() != 'null') {
        setState(() {
          if (isOpened) {
            closeFabPopup();
          }

          changePageIndex = 0;
          _selectedPageIndex = index;
        });
      } else {
        showUserLoginDialog(context);
      }
    });
  }

  Widget getSelectedPage() {
    int PageIndex = 0;

    PageIndex = (changePageIndex == 5 || changePageIndex == 6)
        ? changePageIndex
        : _selectedPageIndex;

    switch (PageIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return PaymentScreen();
      case 3:
        return NotificationScreen();
      case 4:
        return AccountScreen();
      case 5:
        return ServiceHistoryScreen();
      case 6:
        return ServiceIssueScreen();
    }

    return HomeScreen();
  }

  Widget getFabBtn() {
    return PopupMenuButton<int>(
        key: _FabPopupKey,
        offset: (selectedLang == 'ENG') ? Offset(50, -180) : Offset(72, -180),
        onCanceled: closeFabPopup,
        onSelected: onSelectFabPopupItem,
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/call.png',
                        width: 24, height: 24),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      (selectedLang == "ENG")
                          ? StringsEN.phone
                          : StringsMM.phone,
                      style: TextStyle(
                          fontSize: (selectedLang == "ENG") ? 14 : 12),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/Service-Issues.png',
                                width: 24, height: 24),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              (selectedLang == "ENG")
                                  ? StringsEN.service_issue
                                  : StringsMM.service_issue,
                              style: TextStyle(
                                fontSize: (selectedLang == "ENG") ? 14 : 12,
                              ),
                            ),
                          ],
                        )

              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/Service-History.png',
                        width: 24, height: 24),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      (selectedLang == "ENG")
                          ? StringsEN.service_history
                          : StringsMM.service_history,
                      style: TextStyle(
                          fontSize: (selectedLang == "ENG") ? 14 : 12),
                    ),
                  ],
                ),
              ),
            ],
        child: ElevatedButton(
          child: Image.asset('assets/images/floating_icon.png'),
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
                side: BorderSide(color: Colors.blueGrey, width: 1.0),
              ))),
          onPressed: onPopupFabPressed,
        ));
  }

  onPopupFabPressed() {
    _FabPopupKey.currentState.showButtonMenu();

    if (isOpened == false)
      _animationController.forward();
    else
      _animationController.reverse();

    isOpened = !isOpened;
  }

  closeFabPopup() {
    _animationController.reverse();
    isOpened = false;
  }

  onSelectFabPopupItem(int index) {
    closeFabPopup();
    if (index == 1) {
      SharedPref.getData(key: SharedPref.home).then((value) {
        if (value != null && value.toString() != 'null') {
          String hotline_ph =
              HomeDataResponse.fromJson(json.decode(value)).hotlinePhone;
          launch("tel://" + hotline_ph);
        }
      });
    } else if (index == 2) {
      // pressed service_issue

      SharedPref.getData(key: SharedPref.token).then((value) {
        if (value != null && value.toString() != 'null') {
          checkCreateUser();
          // SharedPref.getData(key: SharedPref.create_user_status).then((value) {
          //
          //   if (value != null && value.toString() != 'null') {
          //     var  status = json.decode(value).toString();
          //     print('Main :' + status);
          //     if(status == 'success'){
          //       setState(() {
          //         changePageIndex = 6;
          //         isOpened = false;
          //         SharedPref.setData(SharedPref.create_user_status,'');
          //       });
          //
          //     }
          //     else if(status == 'fail'){
          //       showCheckCreateUserDialog(context, status);
          //     }
          //   }
          // });
        } else {
          showUserLoginDialog(context);
        }
      });
    } else if (index == 3) {
      SharedPref.getData(key: SharedPref.token).then((value) {
        if (value != null && value.toString() != 'null') {
          setState(() {
            changePageIndex = 5;
            isOpened = false;
          });
        } else {
          showUserLoginDialog(context);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    SharedPref.getData(key: SharedPref.language_status).then((value) {
      if (value != null && value.toString() != 'null') {
        if (value == 'ENG') {
          setState(() {
            selectedLang = 'ENG';
          });
        } else {
          setState(() {
            selectedLang = 'မြန်မာ';
          });
        }
      } else {
        selectedLang = 'ENG';
        SharedPref.setData(SharedPref.language_status, selectedLang);
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 110,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 50),
                width: 100,
                child: Image.asset(
                  'assets/images/hi_internet_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            height: 50,
            width: 80,
            margin: EdgeInsets.only(bottom: 37, right: 30, top: 33),
            padding: EdgeInsets.all(2),
            child: Neumorphic(
              style: NeumorphicStyle(
                  color: Colors.white,
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  depth: -4,
                  lightSource: LightSource.topLeft),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedLang,
                items: ["မြန်မာ", "ENG"]
                    .map((label) => DropdownMenuItem(
                          child: Text(
                            label,
                            style: TextStyle(fontSize: 12),
                          ),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLang = value;
                    SharedPref.setData(SharedPref.language_status, value);
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10, bottom: 12)),
              ),
            ),
          ),
        ],
      ),
      body: getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Color(0xFFEEEEEE),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: (selectedLang == "ENG") ? 12 : 10,
        unselectedFontSize: (selectedLang == "ENG") ? 12 : 10,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Image.asset(
              'assets/images/home.png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/images/home-1.png',
              width: 20,
              height: 20,
            ),
            label: (selectedLang == "ENG") ? StringsEN.home : StringsMM.home,
            //'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Image.asset(
              'assets/images/Payment (2).png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/images/Payment (1).png',
              width: 20,
              height: 20,
            ),
            label:
                (selectedLang == "ENG") ? StringsEN.payment : StringsMM.payment,
            //'Payment',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.notifications,
              size: 5.0,
              color: Color(0x00FFFFFF),
            ),
            label: "",
            //'Payment',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Image.asset(
              'assets/images/notifications.png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/images/notifications-1.png',
              width: 20,
              height: 20,
            ),
            label: (selectedLang == "ENG")
                ? StringsEN.notification
                : StringsMM.notification,
            //'Notification',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Image.asset(
              'assets/images/Account (1).png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/images/Account (2).png',
              width: 20,
              height: 20,
            ),
            label: (selectedLang == "ENG")
                ? StringsEN.my_account
                : StringsMM.my_account,
            //'My Account',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
                angle: _rotateButton.value,
                child:
                    Container(height: 70.0, width: 70.0, child: getFabBtn()))),
      ),
    );
  }

  void showContainer(BuildContext context) {
    Center(
      child: Container(
        height: 50,
        width: 50,
        color: Colors.black,
      ),
    );
  }

  void showUserLoginDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Center(
              child: Container(
                height: 300,
                width: 250,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.cancel_presentation)),
                          ],
                        ),
                        Text(
                          //'Please sign in to unlock all\naccount features',
                          (selectedLang == "ENG")
                              ? StringsEN.ned_to_login_first
                              : StringsMM.ned_to_login_first,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: (selectedLang == "ENG") ? 14 : 12,
                              decoration: TextDecoration.none,
                              color: Colors.grey),
                        ),
                        Container(
                          width: 100,
                          child: TextField(
                            controller: userIdController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 15),
                                hintText: (selectedLang == "ENG")
                                    ? StringsEN.userID
                                    : StringsMM.userID, //'User ID',
                                errorText: _validate ? 'Empty' : null,
                                hintStyle: TextStyle(
                                    fontSize:
                                        (selectedLang == "ENG") ? 15 : 13)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        loginButton(context),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              //'need help?',
                              (selectedLang == "ENG")
                                  ? StringsEN.needHelp
                                  : StringsMM.needHelp,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                            Container(
                                width: 70,
                                alignment: Alignment.center,
                                child: Divider(
                                  height: 2,
                                  color: Colors.black,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  void login() {
    setState(() {
      userIdController.text.isEmpty ? _validate = true : _validate = false;
      return;
    });

    Map<String, String> map = {
      'user_id': userIdController.text,
      'app_version': app_version,
    };

    _loginBloc.login(map);
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

  Widget loginButton(BuildContext context) {
    return StreamBuilder<ResponseVO>(
        stream: _loginBloc.loginStream(),
        initialData: ResponseVO(),
        builder: (context, snapshot) {
          ResponseVO resp = snapshot.data;
          if (resp.message == MsgState.loading) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: Colors.white,
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: -3,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          } else if (resp.message == MsgState.error) {
            return Center(
              child: Text((selectedLang == "ENG")
                  ? StringsEN.something_wrong
                  : StringsMM
                      .something_wrong), //'Something wrong,try again...'),
            );
          } else if (resp.message == MsgState.success) {
            Navigator.of(context).pop();
            return Container();
          } else {
            return Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  onPressed: login,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 3, top: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Log Out (Large).png',
                          width: 33,
                          height: 33,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: new Container(
                            child: Text(
                              //'sign in',
                              (selectedLang == "ENG")
                                  ? StringsEN.signin
                                  : StringsMM.signin,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
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
                                  if (status == 'fail') {
                                    setState(() {
                                      changePageIndex = 5;
                                      _animationController.reverse();
                                      isOpened = false;
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      changePageIndex = 6;
                                      _animationController.reverse();
                                      isOpened = false;
                                    });
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

  @override
  void dispose() {
    userIdController.dispose();
    _animationController.dispose();
    _checkCreateUserBloc.dispose();
    _loginBloc.dispose();
    super.dispose();
  }

  void initializeFirebaseMsg() async {
    /*
    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //await FirebaseMessaging.instance.subscribeToTopic('hi');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });*/
  }
}
