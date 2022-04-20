import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hiinternet/widgets/notification_item.dart';

import 'package:hiinternet/data/database_util.dart';
import 'package:hiinternet/data/notification_model.dart';

import 'package:hiinternet/utils/eventbus_util.dart';

class NotificationScreen extends StatefulWidget {

  static const routeName = '/notification_screen';

  @override
  _NotificationScreenScreenState createState() => _NotificationScreenScreenState();
}

class _NotificationScreenScreenState extends State<NotificationScreen> with WidgetsBindingObserver {

  bool bDataRetrievedLately = false;
  List<NotiModel> SavedNotiModels = <NotiModel>[];

  StreamSubscription notiSub;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    notiSub = EventBusUtils.getInstance().on<NotiModel>().listen((event) {
      print("NOTI EVENT " + event.title);
      SavedNotiModels.add(event);
      setState(() {
        bDataRetrievedLately = true;
      });
    });

    retrieveNotiFromDatabase();
  }

  void retrieveNotiFromDatabase() {
    Future<List<NotiModel>> notimodels = DatabaseUtil().getAllNotiModels();
    notimodels.then((value) {
      SavedNotiModels = value;
      setState(() {
        bDataRetrievedLately = true;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      retrieveNotiFromDatabase();
    }
  }

  @override
  void dispose() {
    if(notiSub != null)
      notiSub.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(bDataRetrievedLately && SavedNotiModels != null) {
      bDataRetrievedLately = false;

      return Scaffold(
        body: ListView.builder(
          itemCount: SavedNotiModels.length,
          itemBuilder: (ctx,index){
            return NotificationItem(SavedNotiModels[index]);
          },
        ),
      );
    }

    return Container();
  }


}
