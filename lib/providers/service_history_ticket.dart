import 'package:flutter/material.dart';
import 'package:hiinternet/helpers/base_network.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/service_history_screen/service_history_response.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:provider/provider.dart';

class ServiceHistoryTicket with ChangeNotifier,BaseNetwork{

    List<ServiceHistoryVO> _data = [];

    List<ServiceHistoryVO> get ticketData{
      return [..._data];
    }

}