import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/screens/quiz/legendray_board_screen.dart';
import 'package:hasanat/screens/quiz/quiz_screen.dart';
import 'package:hasanat/screens/quiz/show_reward_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournmentHomeScreen extends StatefulWidget {
  const TournmentHomeScreen({super.key});

  @override
  State<TournmentHomeScreen> createState() => _TournmentHomeScreenState();
}

class _TournmentHomeScreenState extends State<TournmentHomeScreen> {
  final _auth = FirebaseAuth.instance;

  bool isAllowed = true;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/tour_images/BG.png',
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 18.0),
                  child: Center(child: SizedBox(width: 320, height: 50, child: BannerAds())),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: InkWell(
                    onTap: () async {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(),));
                      User? user = _auth.currentUser;
                      if (user != null) {
                        String userId = user.uid;
                        DateTime? lastAccessDate = await LocalStorageUtil
                            .getLastAccessDate(userId);
                        DateTime currentDate = DateTime.now();
                        if (lastAccessDate == null || lastAccessDate.day != currentDate.day) {
                          await LocalStorageUtil.setLastAccessDate(userId, currentDate);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const QuizScreen()),
                        );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('لقد اديت اختبارك لليوم بالفعل'),
                                content: const Text('من فضلك عد غدا للمذيد من الاساله'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                    },
                    child: Image.asset(
                        "assets/images/tour_images/20240306_100644_٠٠٠٠.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const LegendrayBoardScreen();
                          },
                        ),
                      );
                    },
                    child: Image.asset(
                        "assets/images/tour_images/20240306_100644_٠٠٠١.png"),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const ShowRewardScreen();
                          },
                        ),
                      );
                    },
                    child: Image.asset(
                        "assets/images/tour_images/20240306_100645_٠٠٠٢.png"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class LocalStorageUtil {
  static Future<DateTime?> getLastAccessDate(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('lastAccessDate_$userId');
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> setLastAccessDate(String userId, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastAccessDate_$userId', date.toIso8601String());
  }
}