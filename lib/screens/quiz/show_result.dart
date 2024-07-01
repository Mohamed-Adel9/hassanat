import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/ad_mob/reward_ad.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowResult extends StatefulWidget {
  const ShowResult({super.key,required this.score,required this.isZero});

  final int score ;
  final bool isZero ;






  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {

  bool dialogShowed = true ;
  bool adShowed = false ;
  bool youtubeShowed = false ;
  bool dataLoaded = false ;

  String ? youtubeUrl ;

  List<Map<String,dynamic>> allTimeData = [];

  Future<List<Map<String, dynamic>>> fetchData() async {


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
    setState(() {
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('points')
          .where('username', isEqualTo: name)
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
    setState(() {
      dataLoaded = true;
    });
  }

  late CollectionReference _collectionReference;

  Future<Map<String, dynamic>?> getLastDocument() async {
    try {
      QuerySnapshot snapshot = await _collectionReference
          .orderBy('timestamp', descending: true) // Assuming 'timestamp' is the field indicating the time the document was added
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Extract data from the last document
        Map<String, dynamic>? data = snapshot.docs.first.data() as Map<String, dynamic>?;
        youtubeUrl = data!['link'];
        return data;
      } else {
        return null; // No documents found in the collection
      }
    } catch (error) {
      throw ("Failed to get last document: $error");
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
    int endDate = DateTime.now().day +7;


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

      if(DateTime.timestamp().day == endDate){
        await docRef.set({
          'points':0,
          'startDate':startDate,
          'endDate':endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      }
      else{
        await docRef.set({
          'points': FieldValue.increment(5),
          'startDate':startDate,
          'endDate':endDate,
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
    int endDate = DateTime.now().month +1;


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

      if(DateTime.timestamp().month == endDate){
        await docRef.set({
          'points':0,
          'startDate':startDate,
          'endDate':endDate,
          'username': name,
          'userId': user.uid,
        }, SetOptions(merge: true));
      }
      else {
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


  Future<void> _launchYoutube() async {
    if (await canLaunchUrl(Uri.parse(youtubeUrl!))) {
      await launchUrl(Uri.parse(youtubeUrl!));
    } else {
      throw 'Could not launch $youtubeUrl';
    }
  }

  @override
  void initState() {
    fetchData();
    getAllData();
    _collectionReference = FirebaseFirestore.instance.collection('youtube');
    getLastDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConditionalBuilder(
        builder: (context) =>  dialogShowed?  Dialog(
          shadowColor: Colors.black54,
          elevation: 10,
          backgroundColor: Colors.deepPurple,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){
                        setState(() {
                          dialogShowed = false ;
                        });
                      }, icon: const Icon(Icons.close),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 90,
                    height: 40,

                    decoration:BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${allTimeData[0]['points']}",style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),),
                        Image.asset("assets/images/coin.png"),
                      ],
                    ),
                  ),
                ),
                const Text("ذد من حسناتك مرتين يوميا",style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      adShowed ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle,color: Colors.black54,size: 50,),
                            Text("5 حسنات ")
                          ],
                        ),
                      ):
                      InkWell(
                        onTap: (){
                          RewardedExample().loadAd();
                          updateFieldValue();
                          updateWeekFieldValue();
                          updateMonthFieldValue();
                          setState(() {
                            adShowed = true;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle,color: Colors.black54,size: 50,),
                              Text("5 حسنات +")
                            ],
                          ),
                        ),
                      ),
                      youtubeShowed ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle,color: Colors.black54,size: 50,),
                            Text("5 حسنات ")
                          ],
                        ),
                      ): InkWell(
                        onTap: (){
                          _launchYoutube();
                          updateFieldValue();
                          updateWeekFieldValue();
                          updateMonthFieldValue();
                          setState(() {
                            youtubeShowed = true;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle,color: Colors.black54,size: 50,),
                              Text("5 حسنات +")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
         : SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "assets/images/results.png",
                fit: BoxFit.cover,
              ),
               Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80,right: 80,top: 110),
                  child: Row(
                    children: [
                      Text(
                        widget.isZero? "حاول اكثر": "احسنت",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0,top: 30),
                        child: Text(
                          widget.score.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 650.0),
                child: Center(child: SizedBox(width: 320, height: 50, child: BannerAds())),
              )
            ],
          ),
        ),
        condition: dataLoaded,
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      )
    );
  }
}
