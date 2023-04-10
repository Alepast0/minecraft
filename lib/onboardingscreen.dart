import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/generated/locale_keys.g.dart';
import 'package:minecraft/main_screen.dart';

class OnBoard {
  final String image;
  final String title;
  final String? subTitle;
  final List<String> content;
  final String? dop;
  final double heightImage;

  OnBoard(
      {required this.image,
      required this.title,
      this.subTitle,
      required this.content,
      this.dop,
      required this.heightImage});
}

final List<OnBoard> demoData = [
  OnBoard(
      image: "assets/images/onboarding1.png",
      title: "YOU_CAN_CHOOSE_ANY_KIND_OF_ADDITIONS_IN_OUR_APP",
      dop: "assets/images/noob.png",
      content: ["Maps", "Skins", "Mods", "Addons", "Seeds", "Textures"],
      heightImage: 329),
  OnBoard(
      image: "assets/images/onboarding2.png",
      title: "BEST_COLLECTION_OF_SKINS",
      content: ["Unique_skins", "Quick_import_into_the_game", "Large_selection_of_packs"],
      heightImage: 329),
  OnBoard(
      image: "assets/images/onboarding3.png",
      title: "START_PLAYING_WITH_NEW_MAPS_MODS_AND_SKINS",
      subTitle:
          "Lorem_ipsum_dolor_sit_amet_consectetur_adipiscing_elit_Praesent_lorem_a_tincidunt_etiam_iaculis_Ipsum_magna_facilisis_aliquet_nec_integer_cras_sit_gravida_Magna_risus_in_tincidunt_feugiat_risus_tortor_mollis_vitae",
      content: [
        "new_and_popular_mods",
        "best_skins_and_great_packs",
        "Lots_of_cool_additions_for_your_favorite_game"
      ],
      heightImage: 329),
  // OnBoard(
  //     image: "assets/images/onboarding4.png",
  //     title: "PREMIUM IS BETTER",
  //     subTitle:
  //         "Subscription Terms: After free trial, Mods & Skins for Minecraft PE, weekly subscription costs 849,00 rubles. Subscription automatically ....",
  //     content: ["Acces to all content", "Updates every week", "Without advertising"],
  //     heightImage: 270)
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: demoData.length,
                itemBuilder: (BuildContext context, int index) {
                  return OnBoardContent(
                    body: demoData[index],
                    controller: _controller,
                    currentPage: _currentPage,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

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
