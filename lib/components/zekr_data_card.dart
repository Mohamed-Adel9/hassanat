
import 'package:flutter/material.dart';
import 'package:hasanat/components/my_separator.dart';
import 'package:hasanat/models/azkar_model.dart';

class ZekrDataCard extends StatelessWidget {
  const ZekrDataCard({
    required this.azkarModel,
    super.key,

  });

  final AzkarModel azkarModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 3,
                spreadRadius: 3,
                offset: const Offset(0, 5))
          ]),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 10.0),
            child: Text(
              azkarModel.zekr!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: MySeparator(),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  azkarModel.count!.isEmpty ? azkarModel.count! : "${azkarModel.count!}: عدد المرات ",

                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),
        ],
      ),
    );
  }
}
