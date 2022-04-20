
import 'package:flutter/material.dart';
import 'package:hiinternet/data/notification_model.dart';

class NotificationItem extends StatelessWidget {

  NotiModel notiModel;

  NotificationItem(NotiModel notiModel) {
    this.notiModel = notiModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          child: Icon(
            Icons.notifications,
            color: Colors.blueAccent,
          ),
        ),
        title: Text(
          notiModel.title != null ? notiModel.title : " ",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        subtitle: Text(
          notiModel.body != null ? notiModel.body : " ",
          style: TextStyle(fontSize: 13, color: Colors.black45),
        ),
        trailing: Text(notiModel.created != null ? notiModel.created : " "),
      ),
    );
  }
}
