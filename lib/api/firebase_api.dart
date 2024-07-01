import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async{

  }

  Future<void> initNotification ()async{
    await _firebaseMessaging.requestPermission();
    // final fcmToken = await _firebaseMessaging.getToken();

    
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

}