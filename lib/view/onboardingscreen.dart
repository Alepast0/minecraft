import 'package:flutter/material.dart';
import 'package:minecraft/utils/ondoard.dart';
import 'package:minecraft/widgets/onboard_content.dart';

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
