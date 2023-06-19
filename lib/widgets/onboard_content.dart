import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/generated/locale_keys.g.dart';
import 'package:minecraft/view/main_screen.dart';
import 'package:minecraft/utils/ondoard.dart';

class OnBoardContent extends StatelessWidget {
  final OnBoard body;
  final PageController controller;
  final int currentPage;

  const OnBoardContent(
      {Key? key, required this.body, required this.controller, required this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Container(
      decoration: const BoxDecoration(color: Color(0xff1f2120)),
      child: Stack(
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
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: body.heightImage * scaleFactorHeight,
                child: Image.asset(
                  body.image,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 2.6,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 40 * scaleFactorWidth, right: 40 * scaleFactorWidth),
                    height: 180 * scaleFactorHeight,
                    child: Center(
                        child: Text(
                      body.title.tr(),
                      style: TextStyle(
                          fontSize: 22 * scaleFactorHeight,
                          color: const Color(0xff41c81e),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Minecraft"),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              )),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 40 * scaleFactorHeight,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 230 * scaleFactorHeight,
              padding: EdgeInsets.only(
                  left: 40 * scaleFactorWidth, top: 0, right: 40 * scaleFactorWidth),
              child: body.content.length <= 3
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          body.content.length,
                          (index) => Padding(
                                padding: EdgeInsets.only(top: 10 * scaleFactorHeight),
                                child: _card(
                                    body.content[index],
                                    MediaQuery.of(context).size.width - 90 * scaleFactorWidth,
                                    context),
                              )),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 40 * scaleFactorWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                                3,
                                (index) => Padding(
                                      padding: EdgeInsets.only(
                                          top: 10 * scaleFactorHeight, left: 30 * scaleFactorWidth),
                                      child: _card(
                                          body.content[index], 100 * scaleFactorWidth, context),
                                    )),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 40 * scaleFactorWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                                3,
                                (index) => Padding(
                                      padding: EdgeInsets.only(
                                          top: 10 * scaleFactorHeight, left: 20 * scaleFactorWidth),
                                      child: _card(body.content[index + 3], 100, context),
                                    )),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 160 * scaleFactorHeight,
            child: Container(
              padding: EdgeInsets.only(right: 20 * scaleFactorWidth, left: 20 * scaleFactorWidth),
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  if (currentPage == demoData.length - 1) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 200),
                            transitionsBuilder: (BuildContext context, Animation<double> animation,
                                Animation<double> secondaryAnimation, Widget child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context, Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return const MainScreen();
                            }));
                  } else {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.ease);
                  }
                },
                child: Container(
                  height: 70 * scaleFactorHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      gradient: const LinearGradient(
                        begin: Alignment(-1.446, -1),
                        end: Alignment(0.965, 1.537),
                        colors: <Color>[Color(0xff14ff00), Color(0xfff9ff00)],
                        stops: <double>[0, 1],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffbcff00),
                          offset: Offset(0, 0),
                          blurRadius: 7,
                        )
                      ]),
                  child: Center(
                    child: Text(
                      LocaleKeys.NEXT.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22 * scaleFactorHeight,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Minecraft"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body.subTitle != null
              ? Positioned(
                  top: MediaQuery.of(context).size.height - 80 * scaleFactorHeight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(right: 30 * scaleFactorWidth, left: 30 * scaleFactorWidth),
                    child: Text(
                      body.subTitle!.tr(),
                      style: TextStyle(
                          fontSize: 8 * scaleFactorHeight,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff686868),
                          fontFamily: "Minecraft"),
                      softWrap: true,
                    ),
                  ))
              : const SizedBox(),
          body.dop != null
              ? Positioned(
                  left: 0,
                  top: 93 * scaleFactorHeight,
                  child: Align(
                    child: SizedBox(
                      width: 173 * scaleFactorWidth,
                      height: 245.08 * scaleFactorHeight,
                      child: body.dop != null
                          ? Image.asset(
                              body.dop!,
                              fit: BoxFit.fill,
                            )
                          : const SizedBox(),
                    ),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _card(String text, double width, BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          width: 10 * scaleFactorWidth,
          height: 10 * scaleFactorHeight,
          color: const Color(0xff14ff00),
        ),
        SizedBox(
            width: width,
            child: Text(
              text.tr(),
              softWrap: true,
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 14 * scaleFactorHeight,
                  fontFamily: "Minecraft"),
            ))
      ],
    );
  }
}
