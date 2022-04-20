import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class OurApplicationItems extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String color;
  final String titleTextColor;
  final String descTextColor;
  final String url;

  OurApplicationItems(this.image, this.title, this.description, this.color,
      this.titleTextColor, this.descTextColor, this.url);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapApp(),
      child: Container(
        padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: HexColor(descTextColor)),
                ),
              ),
              SizedBox(height: 15,),
              Expanded(
                child: Image.network(
                  image,
                  height: 60,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 15,),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: HexColor(titleTextColor)
                  ),
                ),
              ),
            ],
          ),
        decoration: BoxDecoration(
          color: HexColor(color),
          borderRadius: BorderRadius.circular(15),
        ),
      )
    );
  }

  void onTapApp() {
    launch(url);
  }

}
