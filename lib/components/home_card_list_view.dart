import 'package:flutter/material.dart';
import 'package:hasanat/components/home_card.dart';
import 'package:hasanat/core/app_asset.dart';
import 'package:hasanat/core/app_strings.dart';
import 'package:hasanat/screens/quiz/tournment_home.dart';

import '../screens/azkar_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/tasbeh_counter_screen.dart';

class HomeCardListView extends StatelessWidget {
   HomeCardListView({
    super.key,
  });

  final List<String> images = [
    AppAsset.home1,
    "assets/images/logo.png",

    AppAsset.home2,
    AppAsset.home3,
  ];
  final List<String> titles = [
    AppStrings.holyQuran,
    "مسابقه حسنات",

    AppStrings.azkar,
    AppStrings.sebha,

  ];

  final List<Widget> screens = [
    const QuranScreen(),
    const TournmentHomeScreen(),
    const AzkarScreen(),
    const TasbehCounterScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: ListView.builder(

          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return screens[index];
                },),);
              },
              child: HomeCard(
                image: images[index],
                text: titles[index],
              ),
            );
          },
          itemCount: 4,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}