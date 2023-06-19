import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
        title: const Text('LocaleKeys.title.tr()'),
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
