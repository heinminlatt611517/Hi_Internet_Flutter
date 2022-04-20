import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_response.dart';
import 'package:hiinternet/utils/app_constants.dart';

// ignore: must_be_immutable
class ServiceHistoryItems extends StatelessWidget {
  ServiceHistoryVO _serviceHistoryVO;

  ServiceHistoryItems(this._serviceHistoryVO);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Color(0x90FF0000);
    switch(_serviceHistoryVO.status) {
      case SERVICETICKET_STATUS_SOLVED:
        buttonColor = Color(0xff00ff00);
        break;
      case SERVICETICKET_STATUS_PENDING:
        buttonColor = Color(0x90FF0000);
        break;
      case SERVICETICKET_STATUS_CLAIM:
        buttonColor = Color(0xffff9100);
        break;
      case SERVICETICKET_STATUS_NOC:
        buttonColor = Color(0xff00ff00);
        break;
      case SERVICETICKET_STATUS_CLOSED:
        buttonColor = Color(0xffff9100);
        break;
    }

    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _serviceHistoryVO.ticketId,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: buttonColor,
                      border: Border.all(color: buttonColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        _serviceHistoryVO.status,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        _serviceHistoryVO.topic != null ?  _serviceHistoryVO.topic : '',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _serviceHistoryVO.message,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Solved Date --${_serviceHistoryVO.reslovedTime}',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
