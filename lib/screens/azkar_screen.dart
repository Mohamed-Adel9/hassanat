import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/components/azkar_card.dart';
import 'package:hasanat/models/azkar_model.dart';
import 'package:hasanat/services/get_azkar_data_services.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  List<String> azkarTitles = [];
  List<AzkarModel> azkarModel = [];

  Future<void> populateAzkarTitles() async {
    await getDistinctCategories();
  }

  getDistinctCategories() async {
    azkarModel = await AzkarDataServices().getAzkarData();
    setState(() {});

    for (var i = 0; i < azkarModel.length; i++) {
      if (!azkarTitles.contains(azkarModel[i].category)) {
        azkarTitles.add(azkarModel[i].category!);
      }
    }
  }

  @override
  void initState() {
    populateAzkarTitles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/muslim-mosque-desert.jpg'), context);
    return Scaffold(
      body:Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/muslim-mosque-desert.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay with opacity
          Container(
            color: Colors.white.withOpacity(0.7), // Adjust opacity here
          ),
          // Other Widgets on top of the background image
          SafeArea(
            child: Container(
              color:   Colors.transparent,

              width: (MediaQuery.of(context).size.width),

              child:  Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return AzkarCard(
                          title: azkarTitles[index],
                          number: (index+1).toString(),
                        );
                      },
                      itemCount: azkarTitles.length,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                  const SizedBox(width: 320, height: 50, child: BannerAds())
                ],
              ),
              // child: ,
            ),
          ),
        ],
      ),

    );
  }
}
