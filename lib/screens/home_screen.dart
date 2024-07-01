import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hasanat/ad_manger.dart';

import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/core/app_color.dart';
import 'package:hasanat/core/app_strings.dart';
import 'package:hasanat/screens/admin/admin_screen.dart';
import 'package:hasanat/screens/azkar_screen.dart';
import 'package:hasanat/screens/drawer_item_builder.dart';
import 'package:hasanat/screens/login_screen.dart';
import 'package:hasanat/screens/quiz/tournment_home.dart';
import 'package:hasanat/screens/tasbeh_counter_screen.dart';
import 'package:hasanat/screens/user_screen.dart';
import 'package:hasanat/screens/quran_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;
  final String specificUserUID = "6LFX3HDpqOVFnDYKL4zOLzlJZ613";

  final String facebookPageUrl = "https://www.facebook.com/hassanatapp";
  final String facebookContactPageUrl = "https://www.facebook.com/hassan.esam1";

  final String storeUrl =
      "https://play.google.com/store/apps/details?id=hasanat.app.com";

  Future<void> _launchFacebookPage() async {
    if (await canLaunchUrl(Uri.parse(facebookPageUrl))) {
      await launchUrl(Uri.parse(facebookPageUrl));
    } else {
      throw 'Could not launch $facebookPageUrl';
    }
  }
  Future<void> _launchContactFacebookPage() async {
    if (await canLaunchUrl(Uri.parse(facebookContactPageUrl))) {
      await launchUrl(Uri.parse(facebookContactPageUrl));
    } else {
      throw 'Could not launch $facebookContactPageUrl';
    }
  }

  Future<void> _rateApp() async {
    if (await canLaunchUrl(Uri.parse(storeUrl))) {
      await launchUrl(Uri.parse(storeUrl));
    } else {
      throw 'Could not launch $storeUrl';
    }
  }

  void _shareApp(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    const String text =
        'اكتشف تطبيق حسنات، الجوهر في عالم التطبيقات الإسلامية، حيث تجمع بين بساطته وتوفير مميزات التطبيقات الدينية في تجربة واحدة. أوصي بتجربته عبر الرابط:https://play.google.com/store/apps/details?id=hasanat.app.com'; // Your sharing message

    Share.share(text,
        subject: 'Share App',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  // late AppLifecycleReactor _appLifecycleReactor;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  final _auth = FirebaseAuth.instance;
  late User signedUser;

  int currentIndex = 0;
  late String name = '';

  late List<Widget> screens = [
    const UserScreen(),
    const QuranScreen(),
    const TasbehCounterScreen(),
    const AzkarScreen(),
  ];

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedUser = user;
      }
    } catch (e) {
      throw("error:$e");
    }
  }

  Future<void> getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('username')
            .where('userId', isEqualTo: user!.uid)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;

    name = await documents[0]['username'];
    setState(() {})
    ;
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdManger.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isInterstitialAdReady = false;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    getCurrentUser();
    setState(() {
      getUsername();
    });
    super.initState();


    _loadInterstitialAd();

    // Set up a timer to display the interstitial ad every 5 minutes
    Timer.periodic(const Duration(minutes: 3), (timer) {
      if (_isInterstitialAdReady && _interstitialAd != null) {
        _interstitialAd!.show();
        _loadInterstitialAd();
      } else {
      }
    });

    // check if the admin signed in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.uid == specificUserUID) {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _interstitialAd
        ?.dispose(); // Dispose the interstitial ad when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 230, 207, .5),
        title: Text(
          " ${AppStrings.alslamalykom} , $name",
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _auth.signOut();
                setState(() {

                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ));
              },
              child: const Text(
                "SignOut",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ))
        ],
      ),
      body: Stack(
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
          screens[currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.white,
        selectedIconTheme: const IconThemeData(color: AppColor.primaryLight),
        unselectedIconTheme: const IconThemeData(color: AppColor.grey),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0.0,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: "quran",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "salah",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: "sebha",
          ),
        ],
      ),
      bottomSheet: const SizedBox(width: 320, height: 50, child: BannerAds()),
      drawer: Drawer(
          backgroundColor: Colors.white,
          semanticLabel: "Hasant App",
          surfaceTintColor: Colors.amber,
          child: isAdmin
              ? Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          color: Colors.brown.shade600,
                          width: 450,
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 160.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                     const TournmentHomeScreen(),
                                  ));
                                },
                                child: const Text(
                                  "مسابقه حسنات",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.amber),
                                ),
                              ),
                              // Icon(Icons.arrow_forward_ios,size: 30,color: Colors.brown.shade600,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Center(
                              child: Image.asset(
                            "assets/images/حسنات.png",
                            width: 120,
                            height: 120,
                          )),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِنْ مُدَّكِرٍ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DrawerItemBuilder(
                      title: "صفحتنا علي فيس بوك",
                      icon: Icons.facebook,
                      onPressed: () {
                        _launchFacebookPage();
                      },
                    ),
                    DrawerItemBuilder(
                      title: "شارك الاجر مع اصدقاءك",
                      icon: Icons.share,
                      onPressed: () {
                        _shareApp(context);
                      },
                    ),
                    DrawerItemBuilder(
                      title: "تقييم التطبيق",
                      icon: Icons.star_border,
                      onPressed: () {
                        _rateApp();
                      },
                    ),
                    DrawerItemBuilder(
                      title: "مراسله او اقتراح",
                      icon: Icons.question_mark,
                      onPressed: () {
                        _launchContactFacebookPage();
                      },
                    ),

                    DrawerItemBuilder(
                      title: "صفحه الادمن",
                      icon: Icons.account_circle_outlined,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AdminScreen(),
                        ));
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          color: Colors.brown.shade600,
                          width: 450,
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 160.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                         const TournmentHomeScreen(),
                                  ));
                                },
                                child: const Text(
                                  "مسابقه حسنات",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.amber),
                                ),
                              ),
                              // Icon(Icons.arrow_forward_ios,size: 30,color: Colors.brown.shade600,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: Center(
                              child: Image.asset(
                            "assets/images/حسنات.png",
                            width: 120,
                            height: 120,
                          )),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِنْ مُدَّكِرٍ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    DrawerItemBuilder(
                      title: "صفحتنا علي فيس بوك",
                      icon: Icons.facebook,
                      onPressed: () {
                        _launchFacebookPage();
                      },
                    ),
                    DrawerItemBuilder(
                      title: "شارك الاجر مع اصدقاءك",
                      icon: Icons.share,
                      onPressed: () {
                        _shareApp(context);
                      },
                    ),
                    DrawerItemBuilder(
                      title: "تقييم التطبيق",
                      icon: Icons.star_border,
                      onPressed: () {
                        _rateApp();
                      },
                    ),
                    DrawerItemBuilder(
                      title: "مراسله او اقتراح",
                      icon: Icons.question_mark,
                      onPressed: () {
                        _launchContactFacebookPage();
                      },
                    ),

                  ],
                )),
    );
  }
}
