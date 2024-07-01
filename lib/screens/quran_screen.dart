import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/components/guz_data_screen.dart';
import 'package:hasanat/components/quran_lister.dart';
import 'package:hasanat/components/surah_data_screen.dart';
import 'package:hasanat/core/app_color.dart';
import 'package:hasanat/core/app_strings.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/muslim-mosque-desert.jpg'), context);
    return Scaffold(
      body : Stack(
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const SizedBox(width: 320, height: 50, child: BannerAds()),
                      const Text(
                        AppStrings.holyQuran,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuranListenScreen(),));
                      }, child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("الاستماع الي القران",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Icon(Icons.play_arrow)
                        ],
                      ),),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 50.0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: DefaultTabController(
                          animationDuration: const Duration(milliseconds: 800),
                          length: 2,
                          child: TabBar(
                            dividerColor: AppColor.primaryLight,
                            indicatorColor: AppColor.primaryLight,
                            labelStyle: const TextStyle(fontSize: 20.0),
                            labelColor: Colors.black,
                            unselectedLabelColor: AppColor.grey,
                            tabs: const [
                              Tab(
                                text: "السور",
                              ),
                              Tab(
                                text: "الاجزاء",
                              ),
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ),

                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children:  [
                            const SurahDataScreen(),
                            GuzDataScreen(),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
