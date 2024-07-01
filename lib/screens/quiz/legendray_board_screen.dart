import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';

class LegendrayBoardScreen extends StatefulWidget {
  const LegendrayBoardScreen({super.key});

  @override
  State<LegendrayBoardScreen> createState() => _LegendrayBoardScreenState();
}

class _LegendrayBoardScreenState extends State<LegendrayBoardScreen> {

  bool dataFetched = false;

  List<Map<String,dynamic>> monthlyData = [];
  List<Map<String,dynamic>> weeklyData = [];
  List<Map<String,dynamic>> allTimeData = [];
  List<Map<String,dynamic>> data = [];
  List<Map<String,dynamic>> data3 = [];



  Future<List<Map<String, dynamic>>> fetchData() async {


    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('points')
          .orderBy('points', descending: true)
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
  Future<List<Map<String, dynamic>>> fetchWeekData() async {


    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('week_points')
          .orderBy('points', descending: true)
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
  Future<List<Map<String, dynamic>>> fetchMonthData() async {


    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('month_points')
          .orderBy('points', descending: true)
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

  getAllData() async{
    allTimeData = await fetchData();
    weeklyData = await fetchWeekData();
    monthlyData = await fetchMonthData();
    setState(() {
      data  = weeklyData.skip(3).toList();
      data3 = weeklyData.take(3).toList();
      if(data.isNotEmpty && data3.length == 3){
        dataFetched = true;

      }
    });
  }


  @override
  void initState() {
    getAllData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConditionalBuilder(
        builder:(context) =>  Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
          ),
          child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .4,
                  color: Colors.deepPurple,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        "assets/images/leader.png",
                        fit: BoxFit.cover,
                      ),
                       Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Center(
                          child: Text(
                            data3[0]['username'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data3[1]['username'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              data3[2]['username'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                       Padding(
                        padding: const EdgeInsets.only(top: 300.0, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data3[1]['points'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Text(
                              data3[0]['points'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Text(
                              data3[2]['points'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 200.0),
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
                                size: 30,
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  data3 = weeklyData.take(3).toList();
                                 data = weeklyData.skip(3).toList();

                                });
                              },
                              child: const Text(
                                "اسبوعي",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  data3 = monthlyData.take(3).toList();
                                  data = monthlyData.skip(3).toList();

                                });
                              },
                              child: const Text(
                                "شهري",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  data3 = allTimeData.take(3).toList();
                                  data = allTimeData.skip(3).toList();
                                });
                              },
                              child: const Text(
                                "كل الاوقات",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        color: Colors.white),
                    child: ListView.separated(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (index + 4).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700],
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              data[index]["username"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.deepPurple.shade50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index]["points"].toString(),
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Image.asset(
                                    "assets/images/coin.png",
                                    width: 35,
                                    height: 35,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemCount: data.length,
                    ),
                  ),
                ),
                const SizedBox(width: 320, height: 50, child: BannerAds())
              ],
            ),
        ),
        condition: dataFetched,
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }


}
