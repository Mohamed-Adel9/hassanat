
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hasanat/screens/quiz/show_reward_screen.dart';
import 'package:hasanat/screens/quiz/tournment_home.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowBanner extends StatefulWidget {
  const ShowBanner({
    super.key,
  });

  @override
  State<ShowBanner> createState() => _ShowBannerState();
}

class _ShowBannerState extends State<ShowBanner> {
   List<dynamic> images = [
    "assets/images/RAMADAN KAREEM (Flyer)_20240302_225649_٠٠٠٠.png",
    "assets/images/اعلن هنا_20240302_222321_٠٠٠٠.png",
    "assets/images/نسخة من RAMADAN KAREEM (Flyer)_20240311_004719_٠٠٠٠.png",
    "assets/images/Golden Elegant Awards Ceremony Video_20240311_011122_٠٠٠٠.png",
  ];

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
    _collectionReference = FirebaseFirestore.instance.collection('bannerImages');
    _firstDocumentFuture = _getFirstDocumentWithFields();
    super.initState();
  }

  final List<dynamic> screens = [
    const TournmentHomeScreen(),
    const LaunshFaceBookAdmin(),
    const LaunshFaceBook(),
    const ShowRewardScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
        future: _firstDocumentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData && snapshot.data != null) {
            Map<dynamic, dynamic> data =
            snapshot.data!.data() as Map<dynamic, dynamic>;
            images = data.values.toList();
            images = images.take(4).cast<dynamic>().toList();
            return CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                autoPlayInterval: const Duration(seconds: 6),
                aspectRatio: 1.0,
                viewportFraction: 1,
                reverse: true,

              ),
              items: images.asMap().entries.map((i) {
                final index = i.key;
                final image = i.value;
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return screens[index] ;
                        },));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 200.0,

                        child: Image.network(image,fit: BoxFit.fill,),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          } else {
            return const Center(
                child: Text('No document found with the specified fields'));
          }
        },
      );


  }
}


class LaunshFaceBook extends StatefulWidget {
  const LaunshFaceBook({super.key});

  @override
  State<LaunshFaceBook> createState() => _LaunshFaceBookState();
}

class _LaunshFaceBookState extends State<LaunshFaceBook> {
  final String facebookPageUrl = "https://www.facebook.com/hassanatapp";

  Future<void> _launchFacebookPage() async {
    if (await canLaunchUrl(Uri.parse(facebookPageUrl))) {
      await launchUrl(Uri.parse(facebookPageUrl));
    } else {
      throw 'Could not launch $facebookPageUrl';
    }
  }

  launsh ()async{
    await _launchFacebookPage();
  }
  @override
  void initState() {
    launsh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class LaunshFaceBookAdmin extends StatefulWidget {
  const LaunshFaceBookAdmin({super.key});

  @override
  State<LaunshFaceBookAdmin> createState() => _LaunshFaceBookAdminState();
}

class _LaunshFaceBookAdminState extends State<LaunshFaceBookAdmin> {
  final String facebookPageUrl = "https://www.facebook.com/hassan.esam1";

  Future<void> _launchFacebookPage() async {
    if (await canLaunchUrl(Uri.parse(facebookPageUrl))) {
      await launchUrl(Uri.parse(facebookPageUrl));
    } else {
      throw 'Could not launch $facebookPageUrl';
    }
  }

  launsh ()async{
    await _launchFacebookPage();
  }
  @override
  void initState() {
    launsh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

