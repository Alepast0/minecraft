import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/view/addons_screen.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String image;
  final Shader shader;

  const CardWidget({Key? key, required this.title, required this.image, required this.shader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Padding(
      padding: EdgeInsets.only(
          right: 16 * scaleFactorWidth,
          left: 16 * scaleFactorWidth,
          top: 8 * scaleFactorHeight,
          bottom: 8 * scaleFactorHeight),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
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
                    return AddonsScreen(
                        title: title.tr(),
                        extension: title == 'cool addons'
                            ? 'mcaddon'
                            : title == 'best maps'
                            ? 'mcworld'
                            : title == 'New mods'
                            ? 'mcpack'
                            : title == 'super skins'
                            ? 'png'
                            : title == 'great seeds'
                            ? 'seed'
                            : 'texture');
                  }));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1 * scaleFactorWidth,
                    offset: Offset(1, 1 * scaleFactorHeight),
                  ),
                ],
              ),
              height: 65 * scaleFactorHeight,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                child: Image.asset(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: 10 * scaleFactorWidth,
              child: SizedBox(
                  height: 75 * scaleFactorHeight,
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Center(
                    child: Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        shadows: outlinedText(strokeColor: Colors.black),
                        foreground: Paint()..shader = shader,
                        fontFamily: 'Bolt',
                        fontWeight: FontWeight.bold,
                        fontSize: 30 * scaleFactorHeight,
                        decoration: TextDecoration.none,
                        letterSpacing: 2,
                        height: 1,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  static List<Shadow> outlinedText(
      {double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }
}