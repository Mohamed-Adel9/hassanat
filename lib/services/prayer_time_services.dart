import 'package:dio/dio.dart';
import 'package:hasanat/models/prayer_times_model.dart';

class PrayerTimeServices {
  final Dio dio = Dio();

  final String baseURL = 'https://api.aladhan.com/v1';

  Future<PrayerTimesModel> getPrayTimes({
   required String? cityName,
   required String? countryName,
}) async {
    try {
      Response response = await dio.get(
          '$baseURL/timingsByCity/${getCurrentDate()}?city=$cityName&country=$countryName&method=5');

      PrayerTimesModel prayerTimeModel =
          PrayerTimesModel.fromJson(response.data);

      return prayerTimeModel;
    } catch (e) {
      throw Exception('there was an error');
    }
  }
}

String getCurrentDate() {
  DateTime today = DateTime.now();
  String day = today.day.toString().padLeft(2, '0');
  String month = today.month.toString().padLeft(2, '0'); // Dart months are zero-indexed
  String year = today.year.toString();
  return '$day-$month-$year';
}

