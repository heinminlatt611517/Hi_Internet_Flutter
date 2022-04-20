import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_screen.dart';
import 'package:hiinternet/screens/service_issue_screen/send_service_issue_complain_bloc.dart';
import 'package:hiinternet/screens/service_issue_screen/service_complain_response.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_bloc.dart';
import 'package:hiinternet/screens/service_issue_screen/service_issue_response.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class ServiceIssueScreen extends StatefulWidget {
  static const routeName = '/service_issue';

  @override
  _ServiceIssueScreenState createState() => _ServiceIssueScreenState();
}

class _ServiceIssueScreenState extends State<ServiceIssueScreen> {
  var selectedCategoryId;

  var phoneController = TextEditingController(text: "09xxxxxxx");
  var descriptionController = TextEditingController();

  final _serviceIssueBloc = ServiceIssueBloc();
  final _serviceComplainBloc = SendServiceComplainBloc();
  int changePageIndex = 0;
  var userId;

  List<CategoryVO> issueCategoryList;

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

        _serviceIssueBloc.getServiceIssueCategory(map);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return changePageIndex == 1 ? ServiceHistoryScreen() : Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                      child: Text(
                        //'Service Ticket',
                        (SharedPref.IsSelectedEng()) ? StringsEN.serviceTicket : StringsMM.serviceTicket,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(Icons.phone),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: TextField(
                                      controller: phoneController,
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(Icons.category),
                              ),
                              StreamBuilder<ResponseVO>(
                                  stream: _serviceIssueBloc
                                      .serviceIssueStream(),
                                  initialData: ResponseVO(
                                      message: MsgState.loading),
                                  builder: (context, snapshot) {
                                    ResponseVO resp = snapshot.data;
                                    if (resp.message ==
                                        MsgState.loading) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 100),
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      );
                                    } else if (resp.message == MsgState.error) {
                                      return Center(
                                        child: Text(
                                            //'Something wrong,try again...'),
                                            (SharedPref.IsSelectedEng()) ? StringsEN.something_wrong : StringsMM.something_wrong),
                                      );
                                    } else {
                                      issueCategoryList = resp.data;
                                      return Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          width: MediaQuery.of(context).size.width,
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButtonFormField<int>(
                                              onChanged: (value) {
                                              selectedCategoryId =
                                                  value;
                                              },
                                              items: issueCategoryList.map((data) {
                                                return DropdownMenuItem(
                                                  child: Text(data.name),
                                                  value: data.id,
                                                );
                                              }).toList(),
                                              hint: Text((SharedPref.IsSelectedEng()) ? StringsEN.select_category : StringsMM.select_category),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(30),
                            child: Form(
                              child: TextFormField(
                                controller: descriptionController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText:(SharedPref.IsSelectedEng()) ? StringsEN.describeProblem : StringsMM.describeProblem,
                                        //"Describe more about your problem",
                                    hintStyle: TextStyle(fontSize: 14)),
                              )
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          sendComplainButton(context),
                          //Expanded(
                          //  child: sendComplainButton(context),
                          //)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showStatusDialog(bool isSuccess, String status,String ticketID) {
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
                            child: Text(((SharedPref.IsSelectedEng()) ? StringsEN.ticket_id_is : StringsMM.ticket_id_is) + ticketID),
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
                                      changePageIndex = 1;
                                    });
                                    Navigator.of(context).pop();
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

  Widget sendComplainButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: StreamBuilder<ResponseVO>(
      initialData: ResponseVO(),
      stream: _serviceComplainBloc.serviceComplainStream(),
      builder: (context, snapshot) {
        ResponseVO resp = snapshot.data;
        if (resp.message == MsgState.loading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        } else if (resp.message == MsgState.success) {
          ServiceComplainResponseVO serviceComplainResponseVO = resp.data;
          showStatusDialog(true,
              (SharedPref.IsSelectedEng()) ? StringsEN.well_received : StringsMM.well_received,
              serviceComplainResponseVO.ticketId);
          return Center();
        } else if (resp.message == MsgState.error) {
          ServiceComplainResponseVO serviceComplainResponseVO = resp.data;
          showStatusDialog(false, 'Fail','11111112222');
          return Center();
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    //'Send',
                    (SharedPref.IsSelectedEng()) ? StringsEN.btn_send : StringsMM.btn_send,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  onPressed: () {
                    sendServiceComplain();
                  }),
            ),
          );
        }
      },
      ),
    );

  }

  void sendServiceComplain() {
    String categoryName = "";

    for(final itr in issueCategoryList) {
      if(itr.id == selectedCategoryId) {
        categoryName = itr.name;
        break;
      }
    }

    Map<String, String> map = {
      'user_id': userId,
      'app_version': app_version,
      'phone': phoneController.value.text,
      'description': descriptionController.value.text,
      'category': '[id:' + selectedCategoryId.toString() + ']',
    };

    _serviceComplainBloc.sendServiceComplain(map);
  }

  @override
  void dispose() {
    _serviceIssueBloc.dispose();
    _serviceComplainBloc.dispose();
    super.dispose();
  }
}
