import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minecraft/generated/locale_keys.g.dart';
import 'package:minecraft/models/addons_full_model.dart';
import 'package:minecraft/view/report.dart';
import 'package:minecraft/widgets/addon_card.dart';
import 'package:path_provider/path_provider.dart';

class ContentScreen extends StatefulWidget {
  final AddonsFull addon;
  final List<AddonsFull> addons;
  final Function onReturn;

  const ContentScreen({Key? key, required this.addon, required this.addons, required this.onReturn}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String downloadURL = "";

  @override
  void initState() {
    url();
    super.initState();
  }

  Future<void> url() async {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    final DatabaseEvent event =
        await databaseRef.child('fulls/${widget.addon.id}/downloadUrl').once();
    final DataSnapshot snapshot = event.snapshot;
    setState(() {
      downloadURL = snapshot.value.toString();
    });
  }

  Future<void> downloadFile(String url, String fileName) async {
    Dio dio = Dio();
    try {
      final directory = await getExternalStorageDirectory();
      final iosDirectory = await getApplicationDocumentsDirectory();
      String filePath;
      if (widget.addon.extension == 'mcpack') {
        filePath = '${directory?.path ?? iosDirectory.path}/mods/$fileName';
      } else if (widget.addon.extension == 'mcaddon') {
        filePath = '${directory?.path ?? iosDirectory.path}/behavior_packs/$fileName';
      } else if (widget.addon.extension == 'texture') {
        filePath = '${directory?.path ?? iosDirectory.path}/resource_packs/$fileName';
      } else {
        filePath = '${directory?.path ?? iosDirectory.path}/skin_packs/$fileName';
      }
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            double progress = receivedBytes / totalBytes * 100;
            print('Downloaded $progress%');
          }
        },
      );

      print('Download complete');
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      var android = const AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channelDescription',
        priority: Priority.high,
        importance: Importance.max,
        icon: 'launcher_icon',
        largeIcon: DrawableResourceAndroidBitmap('launcher_icon'),
      );
      var ios = const DarwinNotificationDetails();
      var platform = NotificationDetails(android: android, iOS: ios);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Download complete',
        'The file $fileName has been downloaded.',
        platform,
      );
    } catch (e) {
      print('Error during download: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    return Scaffold(
      body: Stack(
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
              Container(
                padding: EdgeInsets.only(top: 60 * scaleFactorHeight),
                color: const Color(0xffe1e1e1),
                width: MediaQuery.of(context).size.width,
                height: 110 * scaleFactorHeight,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: 50 * scaleFactorWidth, left: 50 * scaleFactorWidth),
                            child: Text(widget.addon.title ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22 * scaleFactorHeight,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: "Minecraft")),
                          ),
                        ),
                        Positioned(
                          top: 5 * scaleFactorHeight,
                          left: 16 * scaleFactorWidth,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onReturn.call();
                            },
                            child: Container(
                                height: 26 * scaleFactorHeight,
                                width: 26 * scaleFactorWidth,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(20, 255, 0, 1), shape: BoxShape.circle),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18 * scaleFactorHeight,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Positioned(
                          top: 5 * scaleFactorHeight,
                          right: 16 * scaleFactorWidth,
                          child: GestureDetector(
                            onTap: () {
                              _showHelp();
                            },
                            child: Container(
                                height: 26 * scaleFactorHeight,
                                width: 26 * scaleFactorWidth,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(20, 255, 0, 1), shape: BoxShape.circle),
                                child: Icon(
                                  size: 18 * scaleFactorHeight,
                                  Icons.help,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 10 * scaleFactorHeight, bottom: 20 * scaleFactorHeight),
                      width: MediaQuery.of(context).size.width - 32 * scaleFactorWidth,
                      height: 180 * scaleFactorWidth,
                      child: widget.addon.previewUrl != ''
                          ? Image.network(
                              widget.addon.previewUrl ?? '',
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'assets/images/dirt.png',
                              fit: BoxFit.fill,
                            ),
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.only(
                                right: 26 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                            child: RatingBarIndicator(
                                itemCount: 5,
                                itemSize: 30 * scaleFactorHeight,
                                rating: double.parse(widget.addon.rating.toString()),
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                })),
                        Container(
                          margin: EdgeInsets.only(left: 20 * scaleFactorWidth),
                          width: 30 * scaleFactorWidth,
                          height: 30 * scaleFactorWidth,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(
                            size: 18 * scaleFactorHeight,
                            Icons.download,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 20 * scaleFactorWidth, left: 10 * scaleFactorWidth),
                          child: Text(
                            widget.addon.countDownload.toString(),
                            style: TextStyle(
                                fontSize: 12 * scaleFactorHeight, fontFamily: "Minecraft"),
                          ),
                        ),
                        Container(
                          width: 30 * scaleFactorWidth,
                          height: 30 * scaleFactorHeight,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20 * scaleFactorHeight,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10 * scaleFactorWidth, left: 10 * scaleFactorWidth),
                          child: Text(
                            widget.addon.countLikes.toString(),
                            style: TextStyle(
                                fontSize: 12 * scaleFactorHeight, fontFamily: "Minecraft"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20 * scaleFactorHeight),
                      color: const Color(0xffe1e1e1),
                      width: MediaQuery.of(context).size.width - 32 * scaleFactorWidth,
                      height: 3 * scaleFactorHeight,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16 * scaleFactorWidth,
                            right: 16 * scaleFactorWidth,
                            top: 20 * scaleFactorHeight),
                        child: Text(
                          widget.addon.title ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22 * scaleFactorHeight,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Minecraft"),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 16 * scaleFactorWidth,
                            right: 16 * scaleFactorWidth,
                            top: 20 * scaleFactorHeight,
                            bottom: 20 * scaleFactorHeight),
                        child: Text(
                          widget.addon.description!['ru'] == null
                              ? ''
                              : EasyLocalization.of(context)?.locale.languageCode == 'ru'
                                  ? widget.addon.description!['ru']
                                  : widget.addon.description!['en'],
                          softWrap: true,
                          style:
                              TextStyle(fontSize: 12 * scaleFactorHeight, fontFamily: "Minecraft"),
                        )),
                    widget.addon.size != ''
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: 16 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                            child: GestureDetector(
                                onTap: () async {
                                  await downloadFile(downloadURL, widget.addon.title!);
                                },
                                child: Container(
                                  height: 50 * scaleFactorHeight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
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
                                      "${LocaleKeys.DOWNLOAD.tr()} (${widget.addon.size ?? ''} MB)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22 * scaleFactorHeight,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Minecraft"),
                                    ),
                                  ),
                                )),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                right: 16 * scaleFactorWidth,
                                left: 16 * scaleFactorWidth,
                                top: 10 * scaleFactorHeight),
                            child: GestureDetector(
                              onTap: () {
                                _copyToClipboard(context);
                              },
                              child: Container(
                                height: 50 * scaleFactorHeight,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                                    color: Colors.grey),
                                child: Center(
                                  child: Text(
                                    LocaleKeys.Copy.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22 * scaleFactorHeight,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: "Minecraft"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 16 * scaleFactorWidth,
                          left: 16 * scaleFactorWidth,
                          top: 10 * scaleFactorHeight),
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Container(
                          height: 50 * scaleFactorHeight,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                              color: Colors.grey),
                          child: Center(
                            child: Text(
                              LocaleKeys.REPORT_A_PROBLEM.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22 * scaleFactorHeight,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: "Minecraft"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 40 * scaleFactorHeight,
                            right: 20 * scaleFactorWidth,
                            left: 20 * scaleFactorWidth,
                            bottom: 15 * scaleFactorHeight),
                        child: Text(
                          '${LocaleKeys.FOR_YOU.tr()}:',
                          style: TextStyle(
                              fontSize: 22 * scaleFactorHeight,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Minecraft"),
                        ),
                      ),
                    ),
                    Column(
                      children: widget.addons.isEmpty
                          ? [
                              Text(
                                LocaleKeys.Empty.tr(),
                                style: TextStyle(
                                    fontSize: 12 * scaleFactorHeight, fontFamily: "Minecraft"),
                              )
                            ]
                          : List<Widget>.generate(
                              widget.addons.length,
                              (index) => CardAddon(
                                    title: widget.addons[index].title,
                                    image: widget.addons[index].previewUrl,
                                    addon: widget.addons[index],
                                    addons: widget.addons.sublist(index + 1),
                                  )),
                    )
                    // _card(widget.addons[index], widget.addons.sublist(index + 1))
                  ],
                )),
              ),
              Container(
                height: 30 * scaleFactorHeight,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffe1e1e1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    Clipboard.setData(ClipboardData(text: widget.addon.seed));
    Fluttertoast.showToast(
        msg: LocaleKeys.COPY_TEXT.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 16.0 * scaleFactorWidth);
  }

  void _showBottomSheet() {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 260 * scaleFactorHeight,
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  color: const Color(0xffe1e1e1),
                  child: Center(
                    child: Text(
                      LocaleKeys.PROBLEM.tr(),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => FeedbackScreen()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 16 * scaleFactorWidth,
                      right: 16 * scaleFactorWidth,
                      top: 20 * scaleFactorHeight,
                      bottom: 20 * scaleFactorHeight),
                  child: Text(
                    LocaleKeys.Cant_download.tr(),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => FeedbackScreen()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 16 * scaleFactorWidth,
                      right: 16 * scaleFactorWidth,
                      top: 20 * scaleFactorHeight,
                      bottom: 20 * scaleFactorHeight),
                  child: Text(
                    LocaleKeys.Content_doesnt_work.tr(),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => FeedbackScreen()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 16 * scaleFactorWidth,
                      right: 16 * scaleFactorWidth,
                      top: 20 * scaleFactorHeight,
                      bottom: 20 * scaleFactorHeight),
                  child: Text(
                    LocaleKeys.Other.tr(),
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

  void _showHelp() {
    final double scaleFactorHeight = MediaQuery.of(context).size.height / 890;
    final double scaleFactorWidth = MediaQuery.of(context).size.width / 411.4;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 100 * scaleFactorHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55 * scaleFactorHeight,
                    color: const Color(0xffe1e1e1),
                    child: Center(
                      child: Text(
                        LocaleKeys.INSTRUCTION.tr(),
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
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 16 * scaleFactorWidth,
                          right: 16 * scaleFactorWidth,
                          top: 20 * scaleFactorHeight,
                          bottom: 20 * scaleFactorHeight),
                      child: Text(
                        LocaleKeys.STEP_1.tr(),
                        style: TextStyle(
                            fontSize: 10 * scaleFactorHeight,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Minecraft"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 16 * scaleFactorWidth,
                          right: 16 * scaleFactorWidth,
                          bottom: 20 * scaleFactorHeight),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Gravida porttitor sit ultricies ut nibh dignissim.',
                        style: TextStyle(fontSize: 10 * scaleFactorHeight, fontFamily: "Minecraft"),
                      ),
                    ),
                    Container(
                        height: 180 * scaleFactorHeight,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 16 * scaleFactorWidth,
                            right: 16 * scaleFactorWidth,
                            bottom: 20 * scaleFactorHeight),
                        child: Image.asset(
                          'assets/images/instruction_1.png',
                          fit: BoxFit.fill,
                        )),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 16 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                  width: MediaQuery.of(context).size.width,
                  height: 2 * scaleFactorHeight,
                  color: const Color(0xffe1e1e1),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 16 * scaleFactorWidth,
                          right: 16 * scaleFactorWidth,
                          top: 20 * scaleFactorHeight,
                          bottom: 20 * scaleFactorHeight),
                      child: Text(
                        LocaleKeys.STEP_2.tr(),
                        style: TextStyle(
                            fontSize: 10 * scaleFactorHeight,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Minecraft"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 16 * scaleFactorWidth,
                          right: 16 * scaleFactorWidth,
                          bottom: 20 * scaleFactorHeight),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Gravida porttitor sit ultricies ut nibh dignissim.',
                        style: TextStyle(fontSize: 10 * scaleFactorHeight, fontFamily: "Minecraft"),
                      ),
                    ),
                    Container(
                        height: 180 * scaleFactorHeight,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                            left: 16 * scaleFactorWidth,
                            right: 16 * scaleFactorWidth,
                            bottom: 20 * scaleFactorHeight),
                        child: Image.asset(
                          'assets/images/instruction_2.png',
                          fit: BoxFit.fill,
                        )),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 16 * scaleFactorWidth, left: 16 * scaleFactorWidth),
                  width: MediaQuery.of(context).size.width,
                  height: 2 * scaleFactorHeight,
                  color: const Color(0xffe1e1e1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
