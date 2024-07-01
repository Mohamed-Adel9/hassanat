import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hasanat/ad_mob/app_open_ad.dart';
import 'package:hasanat/api/firebase_api.dart';
import 'package:hasanat/firebase_options.dart';
import 'package:hasanat/screens/home_screen.dart';
import 'package:hasanat/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  AppOpenAdManager().showAdIfAvailable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    final PermissionStatus status =
    await Permission.storage.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasanat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Amiri",
        useMaterial3: true,
      ),

      home:
          _auth.currentUser != null ? const HomeScreen() :  const LoginScreen(),
    );
  }
}
