import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';

// ignore: must_be_immutable
class TopPromotionItems extends StatelessWidget {

  List<UpImagesVO> images;

  TopPromotionItems(this.images);
  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(
      height: MediaQuery.of(context).size.width * 0.5,//180.0,
      width: MediaQuery.of(context).size.width,
      child: Carousel(
        boxFit: BoxFit.fill,
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 6.0,
        dotIncreasedColor: Color(0xFFFF335C),
        dotBgColor: Colors.transparent,
        dotColor: Colors.grey,
        dotPosition: DotPosition.bottomCenter,
        dotVerticalPadding: 10.0,
        showIndicator: true,
        indicatorBgPadding: 7.0,
        images: images.map((imgData) =>
          NetworkImage(
              (SharedPref.IsSelectedEng()) ? imgData.image : imgData.imageMm
              )).toList(),
      ),
    ),);
  }

}
