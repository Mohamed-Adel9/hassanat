import 'package:flutter/material.dart';

class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({super.key, required this.salahTitle, required this.icon,required this.prayTime});

  final String ? salahTitle ;
  final String ? icon ;
  final String ? prayTime ;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 45.0,
      child: Row(
        children: [
          Image.asset(
            icon!,
            width: 25.0,
            height: 25.0,
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            salahTitle!,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            prayTime!,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
