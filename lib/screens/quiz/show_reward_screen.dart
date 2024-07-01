
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowRewardScreen extends StatefulWidget {
  const ShowRewardScreen({super.key});

  @override
  State<ShowRewardScreen> createState() => _ShowRewardScreenState();
}

class _ShowRewardScreenState extends State<ShowRewardScreen> {
  late CollectionReference _collectionReference;
  late Future<DocumentSnapshot?> _firstDocumentFuture;

  Future<DocumentSnapshot?> _getFirstDocumentWithFields() async {
    try {
      QuerySnapshot snapshot = await _collectionReference
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        return null; // No document found with the specified fields
      }
    } catch (error) {
      throw ("Failed to get first document: $error");
    }
  }

  @override
  void initState() {
    _collectionReference = FirebaseFirestore.instance.collection('images');
    _firstDocumentFuture = _getFirstDocumentWithFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot?>(
        future: _firstDocumentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return SafeArea(
              child: Center(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/images/نسخة من White Giveaway Winner Announcement Mobile Video_20240307_000717_٠٠٠٠.png',
                      fit: BoxFit.fill,
                    ),
                    // Other Widgets on top of the background image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(bottom: 500.0),
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("الجوائز الشهريه",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                Container(
                                  width: MediaQuery.of(context).size.width*.33,
                                  height: 200,
                                  decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network(
                                    data['monthImage'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 400.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("الجوائز الاسبوعيه",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),

                                Container(
                                  width: MediaQuery.of(context).size.width*.33,
                                  height: 200,
                                  decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network(
                                    data['weekImage'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: Text('No document found with the specified fields'));
          }
        },
      ),
    );
  }
}
