class PrayerTimesModel {
   String? fajr;
   String? sunrise;
   String? dhuhr;
   String? asr;
   String? maghrib;
   String? isha;

   PrayerTimesModel({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

   PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    fajr = json['data']['timings']['Fajr'];
    sunrise = json['data']['timings']['Sunrise'];
    dhuhr = json['data']['timings']['Dhuhr'];
    asr = json['data']['timings']['Asr'];
    maghrib = json['data']['timings']['Maghrib'];
    isha = json['data']['timings']['Isha'];

  }
}
