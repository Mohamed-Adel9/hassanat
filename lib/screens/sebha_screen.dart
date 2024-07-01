import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/core/app_color.dart';

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  State<SebhaScreen> createState() => _SebhaScreenState();
}

class _SebhaScreenState extends State<SebhaScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController zekrController = TextEditingController();
  TextEditingController countController = TextEditingController();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  Future<void> getSebhaData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('sebha_data')
            .where('userId', isEqualTo: user!.uid)
            .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot.docs;

    for (var element in documents) {
      data.add(element);
    }
    setState(() {

    });
  }

  sendDataToDB() async {
    await _fireStore.collection('sebha_data').add({
      'zekr': zekrController.text.trim(),
      "userId": user!.uid,
      "count": int.parse(countController.text),
    });
    setState(() {});
  }

  @override
  void initState() {
    getSebhaData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 250, 252, 1),
      key: scaffoldKey,
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sebha_data')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while data is being fetched
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text(
                  'No data available'); // Show message if no data exists
            }

            // Render data on the screen
            return ListView.builder(
              itemBuilder: (context, index) {
                var userData = snapshot.data!['index'].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 10.0),
                  child: InkWell(
                    onTap: () async {
// await Navigator.push(context, MaterialPageRoute(builder: (context) {
//   return SebhaCounterScreen(data : data ,currnetIndex: index,);
// },)
// );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: AppColor.primaryLight.withOpacity(.8),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
// todo delete zekr from db
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: AppColor.white,
                              )),
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  userData['zekr'],
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.white),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      userData['count'].toString(),
                                      style: const TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                    const Text(
                                      " : عدد التسبيح",
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: data.length, //todo put db size
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState!.showBottomSheet((context) => Container(
                height: 280.0,
                width: double.infinity,
                color: AppColor.primaryLight.withOpacity(.1),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        controller: zekrController,
                        keyboardType: TextInputType.text,
                        cursorColor: AppColor.primaryLight,
                        decoration: InputDecoration(
                            label: const Text("الذكر"),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            focusColor: Colors.black,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 4.0),
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        controller: countController,
                        keyboardType: TextInputType.number,
                        cursorColor: AppColor.primaryLight,
                        decoration: InputDecoration(
                            label: const Text("عدد التسابيح"),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              sendDataToDB();
                              setState(() {});
                              Navigator.pop(context);
                              zekrController.text = '';
                              countController.text = '';
                            },
                            color: AppColor.primaryLight,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                borderSide: BorderSide.none),
                            child: const Text(
                              "اضافه",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              zekrController.text = '';
                              countController.text = '';
                            },
                            color: Colors.black45,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                                borderSide: BorderSide.none),
                            child: const Text(
                              "الغاء",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        },
        backgroundColor: AppColor.primaryLight,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
