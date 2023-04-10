import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:minecraft/firebase_options.dart';
import 'package:minecraft/onboardingscreen.dart';

import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(EasyLocalization(
    saveLocale: false,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      assetLoader: const CodegenLoader(),
      path: 'assets/translations',
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (BuildContext context) {
        return const OnBoardingScreen();
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LocaleKeys.title.tr()'),
        leading: IconButton(
            onPressed: () {
              context.setLocale(const Locale('ru'));
              setState(() {});
            },
            icon: const Icon(Icons.add)),
        actions: [
          IconButton(
              onPressed: () {
                context.setLocale(const Locale('en'));
                setState(() {});
              },
              icon: const Icon(Icons.ac_unit))
        ],
      ),
      body: Center(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Text("Pusto");
          } else {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index].get('title')),
                  );
                });
          }
        },
      )),
    );
  }
}
