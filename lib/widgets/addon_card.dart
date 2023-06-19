import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minecraft/view/content_screen.dart';
import 'package:minecraft/models/addons_full_model.dart';
import 'package:path_provider/path_provider.dart';

class CardAddon extends StatefulWidget {
  final String? title;
  final String? image;
  final AddonsFull addon;
  final List<AddonsFull> addons;

  const CardAddon(
      {Key? key,
      required this.title,
      required this.image,
      required this.addon,
      required this.addons})
      : super(key: key);

  @override
  State<CardAddon> createState() => CardAddonState();
}

class CardAddonState extends State<CardAddon> {
  bool downloaded = true;

  @override
  void didChangeDependencies() {
    _colors();
    super.didChangeDependencies();
  }

  void _colors() async {
    final directory = await getExternalStorageDirectory();
    final iosDirectory = await getApplicationDocumentsDirectory();
    String filePath;
    if (widget.addon.extension == 'mcpack') {
      filePath = '${directory?.path ?? iosDirectory.path}/mods/${widget.title}';
    } else if (widget.addon.extension == 'mcaddon') {
      filePath = '${directory?.path ?? iosDirectory.path}/behavior_packs/${widget.title}';
    } else if (widget.addon.extension == 'texture') {
      filePath = '${directory?.path ?? iosDirectory.path}/resource_packs/${widget.title}';
    } else {
      filePath = '${directory?.path ?? iosDirectory.path}/skin_packs/${widget.title}';
    }
    bool fileExists = await File(filePath).exists();
    if (fileExists) {
      setState(() {
        downloaded = false;
        print(downloaded);
      });
    }
  }

  void onReturn() {
    _colors();
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Padding(
      padding: EdgeInsets.only(
          left: 16 * scaleFactorWidth,
          right: 16 * scaleFactorWidth,
          bottom: 8 * scaleFactorHeight,
          top: 8 * scaleFactorHeight),
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
                    return ContentScreen(
                      addon: widget.addon,
                      addons: widget.addons,
                      onReturn: onReturn,
                    );
                  }));
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5 * scaleFactorWidth,
                  offset: Offset(1, 1 * scaleFactorHeight),
                ),
              ],
              color: const Color.fromRGBO(7, 128, 49, 1.0),
              borderRadius: BorderRadius.circular(20 * scaleFactorWidth)),
          width: MediaQuery.of(context).size.width - 32 * scaleFactorWidth,
          height: 155 * scaleFactorHeight,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17 * scaleFactorHeight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2 * scaleFactorWidth,
                      offset: Offset(1, 1 * scaleFactorHeight),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 32 * scaleFactorWidth,
                height: 110 * scaleFactorHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                  child: widget.image != ''
                      ? Image.network(
                          widget.image ?? '',
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          'assets/images/dirt.png',
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              Positioned(
                right: 20 * scaleFactorWidth,
                bottom: 8 * scaleFactorHeight,
                child: Container(
                  width: 33 * scaleFactorWidth,
                  height: 33 * scaleFactorHeight,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5 * scaleFactorWidth,
                          offset: Offset(1, 1 * scaleFactorHeight),
                        ),
                      ],
                      shape: BoxShape.circle,
                      color:
                          downloaded ? const Color.fromRGBO(20, 255, 0, 1) : Colors.orangeAccent),
                  child: Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 18 * scaleFactorHeight,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              Positioned(
                  left: 20 * scaleFactorWidth,
                  bottom: 10 * scaleFactorHeight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 100 * scaleFactorWidth,
                    child: Text(
                      widget.title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18 * scaleFactorHeight,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "Minecraft"),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
