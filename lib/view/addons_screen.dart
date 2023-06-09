import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/generated/locale_keys.g.dart';
import 'package:minecraft/models/addons_full_model.dart';
import 'package:minecraft/widgets/addon_card.dart';

class AddonsScreen extends StatefulWidget {
  final String title;
  final String extension;

  const AddonsScreen({Key? key, required this.title, required this.extension}) : super(key: key);

  @override
  State<AddonsScreen> createState() => _AddonsScreenState();
}

class _AddonsScreenState extends State<AddonsScreen> {
  final CollectionReference addonsRef = FirebaseFirestore.instance.collection('addons-fulls');
  final int _perPage = 30;
  DocumentSnapshot? _lastDocument;
  final List<AddonsFull> _addons = [];
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  List<AddonsFull> _filteredAddons = [];

  @override
  void initState() {
    _loadAddons();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadAddons();
    }
  }

  void _loadAddons() async {
    Query query = addonsRef.where('extension', isEqualTo: widget.extension).limit(_perPage);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    QuerySnapshot snapshot = await query.get();
    List<AddonsFull> addons = snapshot.docs
        .map((doc) => AddonsFull.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    if (_searchQuery.isNotEmpty) {
      _filteredAddons = addons
          .where((addon) => addon.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      _filteredAddons.addAll(addons);
    }
    setState(() {
      _addons.addAll(addons);
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    });
  }

  void _searchAddons() {
    List<AddonsFull> filteredAddons = _addons
        .where((addon) => addon.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    setState(() {
      _filteredAddons = filteredAddons;
      _lastDocument = null;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                height: 160 * scaleFactorHeight,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(widget.title.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22 * scaleFactorHeight,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Minecraft")),
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
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 16 * scaleFactorWidth,
                          right: 16 * scaleFactorWidth,
                          top: 16 * scaleFactorHeight),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      height: 40 * scaleFactorHeight,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: LocaleKeys.Search.tr(),
                                  hintStyle:
                                      const TextStyle(fontFamily: "Minecraft", fontSize: 12)),
                              onChanged: (text) {
                                setState(() {
                                  _searchQuery = text;
                                });
                              },
                            ),
                          ),
                          Container(
                            color: const Color(0xffe1e1e1),
                            width: 2 * scaleFactorWidth,
                            height: 40 * scaleFactorHeight,
                          ),
                          GestureDetector(
                            onTap: () {
                              _searchAddons();
                            },
                            child: SizedBox(
                              width: 40 * scaleFactorWidth,
                              child: Icon(
                                Icons.search,
                                size: 26 * scaleFactorHeight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: addonsRef
                    .where('extension', isEqualTo: widget.extension)
                    .limit(_perPage)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    List<AddonsFull> addons = snapshot.data!.docs
                        .map((doc) => AddonsFull.fromJson(doc.data() as Map<String, dynamic>))
                        .toList();

                    if (_searchQuery.isNotEmpty) {
                      addons = addons
                          .where((addon) =>
                              addon.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
                          .toList();
                    }
                    addons = _filteredAddons;
                    if (addons.isEmpty) {
                      return Text(LocaleKeys.Empty.tr(),
                          style: TextStyle(
                              fontSize: 22 * scaleFactorHeight,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Minecraft"));
                    }

                    return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                            top: 5 * scaleFactorHeight, bottom: 5 * scaleFactorHeight),
                        itemCount: addons.length,
                        itemBuilder: (context, index) {
                          final addon = addons[index];
                          return CardAddon(
                              title: addon.title,
                              image: addon.previewUrl,
                              addon: addon,
                              addons: addons.sublist(index + 1));
                        });
                  }
                },
              )),
              Container(
                height: 30 * scaleFactorHeight,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffe1e1e1),
              )
            ],
          ),
        ],
      ),
    );
  }
}
