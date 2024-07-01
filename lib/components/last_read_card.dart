import 'package:flutter/material.dart';
import 'package:hasanat/components/quran_viewer_page.dart';
import 'package:hasanat/core/app_asset.dart';

import '../core/app_strings.dart';

class LastReadCard extends StatelessWidget {
  const LastReadCard({
    super.key,
    required this.ayaNum,
    required String lastReadTitle,
    required double progressValue,
  }) : _lastReadTitle = lastReadTitle, _progressValue = progressValue;

  final int ayaNum;
  final String _lastReadTitle;
  final double _progressValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return QuranViewerPage(ayaNum: ayaNum);
        },));
      },
      child: Container(
        width: double.infinity,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
              end: Alignment.centerLeft,
              begin: Alignment.centerRight,
              colors: [
                Color.fromRGBO(59, 151, 237, 1),
                Color.fromRGBO(202, 116, 255, 1),
                Color.fromRGBO(255, 120, 193, .8),
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // last read
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      AppStrings.lastRead,
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      _lastReadTitle,
                      style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 180.0,
                      child: Text(
                        '${(_progressValue * 100).toStringAsFixed(0)}%',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: 180.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.grey,
                        value: _progressValue,
                        minHeight: 4.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset(AppAsset.alquran)
            ],
          ),
        ),
      ),
    );
  }
}
