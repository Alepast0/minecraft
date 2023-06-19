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