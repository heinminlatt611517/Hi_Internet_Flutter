import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hiinternet/helpers/shared_pref.dart';
import 'package:hiinternet/screens/home_screen/home_response.dart';
import 'package:video_player/video_player.dart';

class MiddleFeatureItems extends StatefulWidget {
  List<MiddleImagesVO> images;

  MiddleFeatureItems(this.images);

  @override
  _MiddleFeatureItemsState createState() => _MiddleFeatureItemsState(images);
}

class _MiddleFeatureItemsState extends State<MiddleFeatureItems> {
  List<MiddleImagesVO> images;
  Map<String, VideoPlayerController> videoPlayerCtrls = new Map.identity();

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  _MiddleFeatureItemsState(this.images);

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://horizoninternet.myanmaronlinecreations.com/sites/default/files/promo_slide/usage_video.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Carousel(
            boxFit: BoxFit.fill,
            autoplay: false,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 800),
            dotSize: 6.0,
            dotIncreasedColor: Color(0xFFFF335C),
            dotBgColor: Colors.transparent,
            dotColor: Colors.grey,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            images: images
                .map((imgData) => CreateCarouselItem(
                    (SharedPref.IsSelectedEng())
                        ? imgData.image
                        : imgData.imageMm,
                    imgData.videoUrl))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget CreateCarouselItem(String imgUrl, String videoUrl) {
    if (imgUrl != null && imgUrl.isNotEmpty) {
      return Image.network(
        imgUrl,
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
      );
    }

    if (videoUrl != null && videoUrl.isNotEmpty) {
      // VideoPlayerController _controller = VideoPlayerController.network(
      //   videoUrl,
      // );
      //
      // videoPlayerCtrls[videoUrl] = _controller;
      // Future<void> _initializeVideoPlayerFuture = _controller.initialize();

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // return Center(
                //   child: AspectRatio(
                //     aspectRatio: _controller.value.aspectRatio,
                //     child: VideoPlayer(_controller),
                //   ),
                // );
                return Stack(
                  children: <Widget>[
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size?.width ?? 0,
                          height: _controller.value.size?.height ?? 0,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    //FURTHER IMPLEMENTATION
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    }

    return Container();
  }
}
