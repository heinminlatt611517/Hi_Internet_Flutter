import 'package:flutter/material.dart';
import 'package:hiinternet/screens/payment_screen/payment_response.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PaymentItems extends StatelessWidget {
  PaymentVO _paymentVO;

  PaymentItems(this._paymentVO);

  @override
  Widget build(BuildContext context) {

    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(left: 20, right: 20, top: 15,bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              InkWell(
                onTap: onPressedPaid,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: 50,
                  color: _paymentVO.paidStatus == 'Paid' ? Color(0xFFADD8E6) : Color(0xFF181848),
                  child: Text(
                    _paymentVO.paidStatus == 'Paid' ? 'PAID' : 'PAY NOW',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 100,
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Due Date',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 18),
                          child: Text(
                            _paymentVO.paidStatus == 'Paid' ? '${_paymentVO.paidDate.day}' : '${_paymentVO.dueDate.day}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            _paymentVO.paidStatus == 'Paid' ? '${_paymentVO.paidDate.monthYear}' : '${_paymentVO.dueDate.monthYear}',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 1,
                      height: double.maxFinite,
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 70,
                            alignment: Alignment.center,
                            color: _paymentVO.paidStatus == 'Paid'
                                ? Colors.green
                                : Colors.red,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${_paymentVO.paidStatus}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            '${_paymentVO.invoiceId}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            '${_paymentVO.amount}''  MMK',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            '${'${_paymentVO.startDate}''-''${_paymentVO.endDate}'}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void onPressedPaid() {
    launch(_paymentVO.paidUrl);
  }

}
