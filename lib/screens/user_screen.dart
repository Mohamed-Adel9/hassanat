
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hasanat/components/home_card_list_view.dart';
import 'package:hasanat/components/last_read_card.dart';
import 'package:hasanat/components/my_separator.dart';
import 'package:hasanat/components/salah_times.dart';
import 'package:hasanat/components/show_banner.dart';
import 'package:hasanat/core/app_strings.dart';
import 'package:hasanat/functions/first_word.dart';
import 'package:hasanat/models/prayer_times_model.dart';
import 'package:hasanat/services/prayer_time_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserScreen> {

  double _progressValue = 0;
  String _lastReadTitle = "";
  int ayaNum = 0;
  final user = FirebaseAuth.instance.currentUser;

  List<String> quranSurahNames = [
    'الفاتحة',
    'البقرة',
    'آل عمران',
    'النساء',
    'المائدة',
    'الأنعام',
    'الأعراف',
    'الأنفال',
    'التوبة',
    'يونس',
    'هود',
    'يوسف',
    'الرعد',
    'إبراهيم',
    'الحجر',
    'النحل',
    'الإسراء',
    'الكهف',
    'مريم',
    'طه',
    'الأنبياء',
    'الحج',
    'المؤمنون',
    'النور',
    'الفرقان',
    'الشعراء',
    'النمل',
    'القصص',
    'العنكبوت',
    'الروم',
    'لقمان',
    'السجدة',
    'الأحزاب',
    'سبإ',
    'فاطر',
    'يس',
    'الصافات',
    'ص',
    'الزمر',
    'غافر',
    'فصلت',
    'الشورى',
    'الزخرف',
    'الدخان',
    'الجاثية',
    'الأحقاف',
    'محمد',
    'الفتح',
    'الحجرات',
    'ق',
    'الذاريات',
    'الطور',
    'النجم',
    'القمر',
    'الرحمن',
    'الواقعة',
    'الحديد',
    'المجادلة',
    'الحشر',
    'الممتحنة',
    'الصف',
    'الجمعة',
    'المنافقون',
    'التغابن',
    'الطلاق',
    'التحريم',
    'الملك',
    'القلم',
    'الحاقة',
    'المعارج',
    'نوح',
    'الجن',
    'المزمل',
    'المدثر',
    'القيامة',
    'الإنسان',
    'المرسلات',
    'النبأ',
    'النازعات',
    'عبس',
    'التكوير',
    'الإنفطار',
    'المطففين',
    'الإنشقاق',
    'البروج',
    'الطارق',
    'الأعلى',
    'الغاشية',
    'الفجر',
    'البلد',
    'الشمس',
    'الليل',
    'الضحى',
    'الشرح',
    'التين',
    'العلق',
    'القدر',
    'البينة',
    'الزلزلة',
    'العاديات',
    'القارعة',
    'التكاثر',
    'العصر',
    'الهمزة',
    'الفيل',
    'قريش',
    'الماعون',
    'الكوثر',
    'الكافرون',
    'النصر',
    'المسد',
    'الإخلاص',
    'الفلق',
    'الناس',
  ];


  late DocumentSnapshot<Map<String, dynamic>>? lastDocument;

  Future<void> fetchLastDocument() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('saved_data')
              .where("userId",isEqualTo: user!.uid)
              .orderBy('time', descending: true)
              .limit(1)
              .get();


      if (snapshot.docs.isNotEmpty) {
        setState(() {
          lastDocument = snapshot.docs.first;
        });
        _lastReadTitle =
            quranSurahNames[snapshot.docs[0].data()["surahNum"] - 1];
        _progressValue = (snapshot.docs[0].data()["index"]) /
            (snapshot.docs[0].data()["lenght"]);
        ayaNum = (snapshot.docs[0].data()["surahNum"]);
        setState(() {});
      } else {
        // No documents found
      }
    } catch (e) {
      // Error handling
      throw('Error fetching last document: $e');
    }
  }
  String? cityName;
  String? countryName;



  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return;
    }

    // Check location permission status
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      // Location permissions are not granted

      // Request location permissions
      permission = await Permission.location.request();
      if (permission == PermissionStatus.granted) {
        // Location permissions granted after request
        getCurrentLocation(); // Retry getting current location
        return;
      } else {
        // Location permissions denied after request
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        cityName = placemarks.first.administrativeArea;
        countryName = placemarks.first.country;
        cityName = getFirstWord(cityName!);
      });
    } catch (e) {
      throw('Error: $e');
    }
  }

  late CollectionReference _collectionReference;
  late CollectionReference _collectionReference2;
  late Future<DocumentSnapshot?> _firstDocumentFuture;

  Future<DocumentSnapshot?> _getFirstDocumentWithFields() async {
    try {
      QuerySnapshot snapshot = await _collectionReference
          .orderBy('timestamp', descending: true) // Assuming 'timestamp' is the field indicating the time the document was added
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.last;
      } else {
        return null; // No document found with the specified fields
      }
    } catch (error) {
      throw ("Failed to get first document: $error");
    }
  }

  Future<Map<String, dynamic>?> getLastDocument() async {
    try {
      QuerySnapshot snapshot = await _collectionReference2
          .orderBy('timestamp', descending: true) // Assuming 'timestamp' is the field indicating the time the document was added
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Extract data from the last document
        Map<String, dynamic>? data = snapshot.docs.first.data() as Map<String, dynamic>?;
        facebookContactPageUrl = data!['face'];
        setState(() {
        });
        return data;
      } else {
        return null; // No documents found in the collection
      }
    } catch (error) {
      throw ("Failed to get last document: $error");
    }
  }


  PrayerTimesModel model = PrayerTimesModel();

  getData() async {
    getCurrentLocation();
    setState(() {

    });

    model = await PrayerTimeServices()
        .getPrayTimes(cityName: cityName,countryName: countryName);
    setState(() {});
  }

  String ? facebookContactPageUrl ;
  Future<void> _launchContactFacebookPage() async {
    if (await canLaunchUrl(Uri.parse(facebookContactPageUrl!))) {
      await launchUrl(Uri.parse(facebookContactPageUrl!));
    } else {
      throw 'Could not launch $facebookContactPageUrl';
    }
  }

  @override
  void initState() {
    getData();
    fetchLastDocument();
    _collectionReference = FirebaseFirestore.instance.collection('images');
    _firstDocumentFuture = _getFirstDocumentWithFields();
    _collectionReference2 = FirebaseFirestore.instance.collection('youtube');
    getLastDocument();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 1030,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // carousal slider section
            const ShowBanner(),

            // the hole design
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 14.0, right: 14.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              AppStrings.prayTimes,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Text(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const MySeparator(),
                        // salah times
                        const SalahTimes(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 18.0),
                          child: MySeparator(),
                        ),

                        FutureBuilder<DocumentSnapshot?>(
                          future: _firstDocumentFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData && snapshot.data != null) {
                              Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;


                              return Center(child:  InkWell(
                                onTap: () {
                                  _launchContactFacebookPage();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 150.0,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Image.network(data['advertImage'],fit: BoxFit.fill,),

                                  ),
                              ),
                              );

                            } else {
                              return const Center(child: Text('No document found with the specified fields'));
                            }
                          },
                        ),
                          HomeCardListView(),
                        // last read section
                        LastReadCard(
                          ayaNum: ayaNum,
                          lastReadTitle: _lastReadTitle,
                          progressValue: _progressValue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


