import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/payment_screen/payment_response.dart';
import 'package:hiinternet/screens/payment_screen/payment_bloc.dart';
import 'package:hiinternet/screens/tabs_screen/tab_screen.dart';
import 'package:hiinternet/widgets/payment_item.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment_screen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  var allPayment = false;
  var paidPayment = false;
  var unPaidPayment = false;
  var userId;
  bool showErrorMessage = true;

  final _paymentBloc = PaymentBloc();

  @override
  void initState() {

    SharedPref.getData(key: SharedPref.user_id).then((value) {
        if (value != null && value.toString() != 'null') {
          userId = json.decode(value).toString();

          Map<String, String> map = {
            'user_id': userId,
            'app_version': app_version,
          };

         _paymentBloc.getPayment(map);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    allPayment = true;
    paidPayment = false;
    unPaidPayment = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Scaffold(
          body: paymentBar()
        ),
      ),
    );
  }

  Widget paymentBar() {
    return Column(
      children: [
        Container(
          height: 80,
          color: Colors.blueGrey,
          padding: EdgeInsets.all(20),
          child: GestureDetector(
            onTap: availablePaymentMethods,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment),
                    Text((SharedPref.IsSelectedEng()) ? StringsEN.btn_availablePayment : StringsMM.btn_availablePayment),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          //'Payment',
          (SharedPref.IsSelectedEng()) ? StringsEN.payment : StringsMM.payment,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: allPayment ?  Color(0xFF181848) : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.all : StringsMM.all,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12,color: Colors.grey )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = true;
                      paidPayment = false;
                      unPaidPayment = false;
                    });
                  }),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: paidPayment ?  Color(0xFF181848) : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.paid : StringsMM.paid,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12,color: Colors.grey )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = false;
                      paidPayment = true;
                      unPaidPayment = false;
                    });
                  }),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ActionChip(
                  backgroundColor: unPaidPayment ?  Color(0xFF181848) : Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  label: Text(
                      (SharedPref.IsSelectedEng()) ? StringsEN.unpaid : StringsMM.unpaid,
                      style: TextStyle(fontSize: (SharedPref.IsSelectedEng()) ? 14 : 12,color: Colors.grey )
                  ),
                  onPressed: () {
                    setState(() {
                      allPayment = false;
                      paidPayment = false;
                      unPaidPayment = true;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        paymentItemsList(),
      ],
    );

  }

  Widget paymentItemsList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: StreamBuilder<ResponseVO>(
          builder: (context, snapshot) {
            ResponseVO resp = snapshot.data;
            if (resp.message == MsgState.loading) {
              return Center(
                child: Container(
                    margin: EdgeInsets.only(top: 10,),
                    child: CircularProgressIndicator()),
              );
            } else if (resp.message == MsgState.error) {

              showSessionExpireDialog(true,'Fail','Session Expire');
              showErrorMessage = false;
              return Center(
                child: Text((SharedPref.IsSelectedEng())
                    ? StringsEN.something_wrong
                    : StringsMM
                    .something_wrong), //'Something wrong,try again...'),
              );
            } else if(resp.message == MsgState.success) {
              List<PaymentVO> list = resp.data;
              return //Expanded(
                //child: Padding(
                //padding: const EdgeInsets.only(bottom: 100),
                //child: ListView.builder(
                Container(
                  margin: EdgeInsets.only(bottom: 40,),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return PaymentItems(list
                        .where((element) =>
                    allPayment ? true : paidPayment
                        ? element.paidStatus == 'Paid'
                        : element.paidStatus == 'UnPaid')
                        .toList()[index]);
                  },
                  itemCount: list
                      .where((element) =>
                  allPayment ? true : paidPayment
                      ? element.paidStatus == 'Paid'
                      : element.paidStatus == 'UnPaid')
                      .toList()
                      .length,
                  //),
                  ),
                );
            }

            else {
              return Center(
                child: Text(showErrorMessage ? StringsEN.something_wrong : ''),
              );
            }
          },
          stream: _paymentBloc.paymentStream(),
          initialData: ResponseVO(message: MsgState.loading),
        ),
      ),
    );

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

  void availablePaymentMethods() {
    SharedPref.getData(key: SharedPref.payment_method_url).then((value) {
      value = value.replaceAll('"', '').trim();
      launch(value);
    });
  }

  @override
  void dispose() {
    _paymentBloc.dispose();
    super.dispose();
  }

}
