import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hiinternet/utils/app_constants.dart';
import 'package:hiinternet/helpers/response_vo.dart';
import 'package:hiinternet/screens/home_screen/home_bloc.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';
import 'package:hiinternet/widgets/middle_feature_item.dart';
import 'package:hiinternet/widgets/our_application_item.dart';
import 'package:hiinternet/widgets/top_promotion_item.dart';
import 'package:provider/provider.dart';

import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/res/strings_eng.dart';
import 'package:hiinternet/res/strings_mm.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = HomeBloc();

  List<UpImagesVO> upImageLists;
  List<MiddleImagesVO> middleImageLists;
  List<DownImagesVO> downImageLists;

  double itemHeight = 0;
  double itemWidth = 0;

  @override
  void initState() {
    Map<String, String> map = {
      'user_id': 'WL07898',//'u_123',
      'app_version': app_version,
      'type' : 'ios',
    };
    _homeBloc.getHomeData(map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    itemHeight = (size.height - kToolbarHeight - 24) / 4;
    itemWidth = size.width / 2;

    return Container(
      alignment: FractionalOffset.center,
      color: Colors.white,
      child: StreamBuilder(
        builder: (context, snapshot) {
          ResponseVO resp = snapshot.data;
          if (resp.message == MsgState.loading) {
            return Center(
              child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: CircularProgressIndicator()),
            );
          } else if (resp.message == MsgState.error) {
            return Center(
              child: Text((SharedPref.IsSelectedEng()) ? StringsEN.something_wrong : StringsMM.something_wrong),
            );
          } else {
            HomeDataVO data = resp.data;
            upImageLists = data.upImages;
            middleImageLists = data.middleImages;
            downImageLists = data.downImages;

            return body(context);
          }
        },
        stream: _homeBloc.homeStream(),
        initialData: ResponseVO(message: MsgState.loading),
      ),
    );
  }

  Widget body(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                //MediaQuery.of(context).size.height,
                  constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight, maxHeight: double.infinity),
                  child: Column(
                    children: <Widget>[
                      TopPromotionItems(upImageLists),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          (SharedPref.IsSelectedEng()) ? StringsEN.feature : StringsMM.feature,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      MiddleFeatureItems(middleImageLists),
                      SizedBox(
                        height: 10,
                      ),
                      // Center(
                      //   child: Text(
                      //     (SharedPref.IsSelectedEng()) ? StringsEN.our_applicatijon : StringsMM.our_applicatijon,
                      //     style: TextStyle(
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // GridView(
                      //   shrinkWrap:true,
                      //   physics: new NeverScrollableScrollPhysics(),
                      //   primary: false,
                      //   padding: const EdgeInsets.all(10),
                      //   children: downImageLists
                      //       .map((imgData) =>
                      //       OurApplicationItems(
                      //           imgData.imageV1,
                      //           imgData.title,
                      //           imgData.description,
                      //           imgData.backgroundColor,
                      //           imgData.titleTextColor,
                      //           imgData.descriptionTextColor,
                      //           imgData.link))
                      //       .toList(),
                      //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      //       maxCrossAxisExtent: 200,
                      //       mainAxisSpacing: 20,
                      //       crossAxisSpacing: 20,
                      //       childAspectRatio: (itemWidth /
                      //           itemHeight)),
                      // )
                    ],
                  )
              )
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }
}
