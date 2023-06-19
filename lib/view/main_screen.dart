import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:minecraft/generated/locale_keys.g.dart';
import 'package:minecraft/widgets/card.dart';

import '../models/categories_model.dart';
import '../utils/shaders.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final InAppReview inAppReview = InAppReview.instance;
  late AnimationController _animationController;
  late PageController _controller;
  int _currentPage = 0;
  List<String> list = [
    'assets/images/main1.png',
    'assets/images/main2.png',
    'assets/images/main3.png',
    'assets/images/main4.png',
    'assets/images/main5.png',
    'assets/images/main6.png'
  ];

  List<String> listPreview = [
    "assets/images/main_preview_1.png",
    "assets/images/main_preview_2.jpg",
    "assets/images/main_preview_3.jpg"
  ];

  void requestReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Stream<List<Categories>> getCategoryStream() {
    return firestore.collection('categories').snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Categories.fromJson(doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 0,
            child: Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: Image.asset(
                  "assets/images/background_on1.png",
                  fit: BoxFit.fill,
                ),
              ),
            )),
        Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height / 2,
            child: Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: Image.asset(
                  "assets/images/background_on2.png",
                  fit: BoxFit.fill,
                ),
              ),
            )),
        Positioned(
            top: 0,
            child: Align(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 294 * scaleFactorHeight,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      controller: _controller,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            double scaleFactor = 0;
                            if (_controller.position.haveDimensions) {
                              scaleFactor = (_controller.page! - index).abs().clamp(0.0, 1.0);
                            }
                            scaleFactor = 1 - scaleFactor * 0.2; // уменьшение на 10%
                            return Transform.scale(
                              scale: scaleFactor,
                              child: Image.asset(
                                listPreview[index],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10 * scaleFactorHeight),
                    width: MediaQuery.of(context).size.width,
                    height: 500 * scaleFactorHeight,
                    child: StreamBuilder<List<Categories>>(
                      stream: getCategoryStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(
                                  top: 5 * scaleFactorHeight, bottom: 5 * scaleFactorHeight),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final category = snapshot.data![index];
                                return CardWidget(
                                  title: category.title,
                                  image: list[index],
                                  shader: listShader[index],
                                );
                              });
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20 * scaleFactorHeight),
                    width: MediaQuery.of(context).size.width - 80 * scaleFactorWidth,
                    height: 50 * scaleFactorHeight,
                    color: Colors.grey,
                    child: Center(
                        child: Text(
                      "реклама",
                      style: TextStyle(fontSize: 20 * scaleFactorHeight, fontFamily: 'Minecraft'),
                    )),
                  )
                ],
              ),
            )),
        Positioned(
            top: 274 * scaleFactorHeight,
            left: MediaQuery.of(context).size.width / 2 - 24 * scaleFactorWidth,
            child: Row(
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: EdgeInsets.only(
                            right: 4 * scaleFactorWidth, left: 4 * scaleFactorWidth),
                        child: Container(
                          height: 10 * scaleFactorHeight,
                          width: 10 * scaleFactorWidth,
                          decoration: BoxDecoration(
                              color: _currentPage == index ? Colors.green : Colors.white),
                        ),
                      )),
            )),
        Positioned(
            top: 60 * scaleFactorHeight,
            right: 20 * scaleFactorWidth,
            child: GestureDetector(
              onTap: () {
                _showBottomSheet();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green,
                ),
                width: 40 * scaleFactorWidth,
                height: 40 * scaleFactorHeight,
                child: Icon(
                  size: 18 * scaleFactorHeight,
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }

  void _showBottomSheet() {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.0 * scaleFactorHeight,
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55 * scaleFactorHeight,
                  color: const Color(0xffe1e1e1),
                  child: Center(
                    child: Text(
                      LocaleKeys.SETTINGS.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * scaleFactorHeight,
                          fontFamily: "Minecraft"),
                    ),
                  ),
                ),
                Positioned(
                  top: 16 * scaleFactorHeight,
                  right: 16 * scaleFactorWidth,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 24 * scaleFactorHeight,
                      color: const Color.fromRGBO(20, 255, 0, 1),
                    ),
                  ),
                )
              ]),
              GestureDetector(
                onTap: () {
                  requestReview();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 16 * scaleFactorWidth,
                      right: 16 * scaleFactorWidth,
                      top: 20 * scaleFactorHeight,
                      bottom: 20 * scaleFactorHeight),
                  child: Text(
                    LocaleKeys.Restore_purchases.tr(),
                    style: TextStyle(fontSize: 10 * scaleFactorHeight, fontFamily: "Minecraft"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                width: MediaQuery.of(context).size.width,
                height: 2 * scaleFactorHeight,
                color: const Color(0xffe1e1e1),
              ),
              GestureDetector(
                onTap: () {
                  requestReview();
                  print('asdas');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 16 * scaleFactorWidth,
                      right: 16 * scaleFactorWidth,
                      top: 20 * scaleFactorHeight,
                      bottom: 20 * scaleFactorHeight),
                  child: Text(
                    LocaleKeys.Rate_app.tr(),
                    style: TextStyle(fontSize: 10 * scaleFactorHeight, fontFamily: "Minecraft"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                width: MediaQuery.of(context).size.width,
                height: 2 * scaleFactorHeight,
                color: const Color(0xffe1e1e1),
              ),
            ],
          ),
        );
      },
    );
  }
}
