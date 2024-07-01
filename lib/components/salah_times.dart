
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hasanat/components/prayer_time_card.dart';
import 'package:hasanat/core/app_asset.dart';
import 'package:hasanat/functions/time_converter.dart';
import 'package:hasanat/models/prayer_times_model.dart';
import 'package:hasanat/services/prayer_time_services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class SalahTimes extends StatefulWidget {
  const SalahTimes({
    super.key,
  });

  @override
  State<SalahTimes> createState() => _SalahTimesState();
}

class _SalahTimesState extends State<SalahTimes> {

  String? cityName = "giza";
  String? countryName;

  late PrayerTimesModel model;

  final List<String> salahTitles = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];
  final List<String> icons = [
    AppAsset.fajr,
    AppAsset.sunrise,
    AppAsset.dhuhr,
    AppAsset.asr,
    AppAsset.maghrib,
    AppAsset.isha,
  ];
  List<String?> data = [];
  List<String?> noData = [
    '...جاري التحميل',
    '...جاري التحميل',
    '...جاري التحميل',
    '...جاري التحميل',
    '...جاري التحميل',
    '...جاري التحميل',
  ];


  String getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.jm().format(now); // 'jm' formats time as 4:52 PM
    return formattedTime;
  }

  getData() async{
    getCurrentLocation();

    model = await PrayerTimeServices().getPrayTimes(countryName: countryName,cityName: cityName);
    setState(() {
    });
    data=[
      convertTimeTo12HourFormat(model.fajr),
      convertTimeTo12HourFormat(model.sunrise),
      convertTimeTo12HourFormat(model.dhuhr),
      convertTimeTo12HourFormat(model.asr),
      convertTimeTo12HourFormat(model.maghrib),
      convertTimeTo12HourFormat(model.isha),

    ];


  }

  String getFirstWord(String text) {
    List<String> parts = text.split(" ");
    return parts.first.toLowerCase();
  }


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
      throw("error:$e");
    }
  }
  @override
  void initState(){
     getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 280,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return PrayerTimeCard(
            salahTitle: salahTitles[index],
            icon: icons[index],
            prayTime: data.isNotEmpty ? data[index] : noData[index],

          );
        },
        itemCount: 6,

      ),
    );
  }
}