import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/screens/quiz/show_result.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> fetchData() async {
    int today = DateTime.now().day;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quiz')
          .where('date', isEqualTo: today)
          .get();

      List<DocumentSnapshot> documents = snapshot.docs;
      List<Map<String, dynamic>> dataList = [];

      documents.forEach((document) {
        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          dataList.add(data);
        }
      });

      return dataList;
    } catch (error) {
      throw ("'Failed to fetch data: $error'");
    }
  }

  Future<void> updateFieldValue() async {
    late String name = '';

    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('username')
            .where('userId', isEqualTo: user!.uid)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;

    name = await documents[0]['username'];
    setState(() {});

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      DocumentReference docRef =
          fireStore.collection('points').doc(auth.currentUser!.uid);

      await docRef.set({
        'points': FieldValue.increment(5),
        'username': name,
      }, SetOptions(merge: true));

    } catch (error) {
      throw('Error updating field value: $error');
    }
  }

  Future<void> updateWeekFieldValue() async {
    int startDate = DateTime.now().day;
    int endDate = DateTime.now().day + 7;

    late String name = '';

    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('username')
            .where('userId', isEqualTo: user!.uid)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;

    name = await documents[0]['username'];
    setState(() {});

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      DocumentReference docRef =
          fireStore.collection('week_points').doc(auth.currentUser!.uid);

      if (DateTime.timestamp().day == endDate) {
        await docRef.set({
          'points': 0,
          'startDate': startDate,
          'endDate': endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      } else {
        await docRef.set({
          'points': FieldValue.increment(5),
          'startDate': startDate,
          'endDate': endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      }

    } catch (error) {
      throw('Error updating field value: $error');
    }
  }

  Future<void> updateMonthFieldValue() async {
    int startDate = DateTime.now().month;
    int endDate = DateTime.now().month + 1;

    late String name = '';

    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('username')
            .where('userId', isEqualTo: user!.uid)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;

    name = await documents[0]['username'];
    setState(() {});

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      DocumentReference docRef =
          fireStore.collection('month_points').doc(auth.currentUser!.uid);

      if (DateTime.timestamp().month == endDate) {
        await docRef.set({
          'points': 0,
          'startDate': startDate,
          'endDate': endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      } else {
        await docRef.set({
          'points': FieldValue.increment(5),
          'startDate': startDate,
          'endDate': endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      }
    } catch (error) {
      throw('Error updating field value: $error');
    }
  }

  int trueAns = 0;

  int currentIndex = 0;
  int pointsToday = 0;

  bool dataCame = false;
  bool timeOut = false;
  bool isSolved = false;
  int questionNum = 1;
  double persentage = 1;
  int time = 25;
  List<bool> rightAns = [
    false,
    false,
    false,
    false,
  ];

  late Timer _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          time--;
          setState(() {
            persentage = time / 25;
          });
        } else {
          setState(() {
            isSolved = false;
            rightAns = [
              false,
              false,
              false,
              false,
            ];
            Timer(const Duration(seconds: 2), () {
              updateIndex();
            });
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                ShowResult(score: pointsToday, isZero: pointsToday == 0),
          ));
          _timer.cancel();
        }
      });
    });
  }

  void startTimeOut() {
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        timeOut = true;
      });
    });
  }

  void setOneTrue(List<bool> boolList, int index) {
    // Set all elements to false
    for (int i = 0; i < boolList.length; i++) {
      boolList[i] = false;
    }

    // Set the specified index to true
    if (index >= 0 && index < boolList.length) {
      boolList[index] = true;
    } else {
      throw ArgumentError('Index out of range');
    }
  }

  getData() async {
    data = await fetchData();
    if (data.isNotEmpty) {
      setState(() {
        dataCame = true;
      });
    } else {
      setState(() {
        dataCame = false;
      });
    }
  }

  showSuccessfulToast() {
    return MotionToast.success(
      title: const Text("احسنت"),
      description: const Text("اجابه صحيحه"),
    ).show(context);
  }

  showFailedToast() {
    return MotionToast.error(
            title: const Text("حاول مره اخري"),
            description: const Text("لا تياس"))
        .show(context);
  }

  void updateIndex() {
    setState(() {
      currentIndex = (currentIndex + 1) % data.length;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    startTimeOut();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(225, 220, 215, 1),
      body: ConditionalBuilder(
        condition: dataCame,
        builder: (context) => Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height) * (2 / 5),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Image.asset(
                    "assets/images/quizBG.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      Text(
                        "السوال  رقم $questionNum",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black54),
                        child: Center(
                            child: Text("$questionNum/${data.length}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 185, left: 18.0, right: 18),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            data[currentIndex]['qusetions']["qusetion"],
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 130.0),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: CircularPercentIndicator(
                            backgroundColor: Colors.grey,
                            animationDuration: 3,
                            radius: 50.0,
                            lineWidth: 8.0,
                            percent: persentage,
                            center: Text(
                              time.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0,
                              ),
                            ),
                            progressColor: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                        child: SizedBox(
                            width: 320, height: 50, child: BannerAds()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (rightAns[index] == false) {
                                    setState(() {
                                      isSolved = true;
                                      rightAns[index] = true;
                                      setOneTrue(rightAns, index);
                                    });
                                  } else {
                                    setState(() {
                                      isSolved = false;
                                      rightAns[index] = false;
                                    });
                                  }
                                },
                                icon: rightAns[index]
                                    ? const Icon(
                                        Icons.circle,
                                        size: 30,
                                        color: Colors.deepPurple,
                                      )
                                    : const Icon(
                                        Icons.circle_outlined,
                                        size: 30,
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                data[currentIndex]['qusetions']["ansewr"]
                                    [index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                  itemCount: 4),
            ),
            isSolved
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: double.infinity,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            if (currentIndex == (data.length) - 1) {
                              Timer(const Duration(seconds: 2), () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ShowResult(
                                      score: pointsToday,
                                      isZero: pointsToday == 0),
                                ));
                              });
                            }

                            if (rightAns[(data[currentIndex]['qusetions']
                                        ["trueAnsIndex"]) -
                                    1] ==
                                true) {
                              updateFieldValue();
                              updateMonthFieldValue();
                              updateWeekFieldValue();
                              pointsToday += 5;
                              trueAns++;
                              showSuccessfulToast();
                              Timer(const Duration(seconds: 2), () {
                                updateIndex();
                              });
                            } else {
                              showFailedToast();
                              Timer(const Duration(seconds: 2), () {
                                updateIndex();
                              });
                            }
                            questionNum++;
                          }),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: double.infinity,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            if (time == 0) {
                              updateIndex();
                            }
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        fallback: (context) => timeOut
            ? const Center(
                child: Text("لم تضف الاساله اليوميه بعد",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
