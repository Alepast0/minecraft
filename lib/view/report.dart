import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../generated/locale_keys.g.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();

  void sendEmail() async {
    final Email email = Email(
      body: 'Проблема в приложении...',
      subject: 'Проблема в приложении',
      recipients: ['sahkushnerev@gmail.com'],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
      print('Письмо отправлено');
    } catch (e) {
      print('Ошибка отправки письма: $e');
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
                          child: Text(LocaleKeys.REPORT_A_PROBLEM.tr(),
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
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Describe your problem...',
                      border: OutlineInputBorder(),
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
                      sendEmail();
                    },
                    child: Container(
                      height: 50 * scaleFactorHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17 * scaleFactorWidth),
                          color: Colors.grey),
                      child: Center(
                        child: Text(
                          'Send',
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
              ],
            ),
          ],
        ),
      ],
    ));
  }
}
