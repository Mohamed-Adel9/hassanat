import 'package:flutter/material.dart';
import 'package:hasanat/components/quran_viewer_page.dart';

class GuzDataScreen extends StatelessWidget {
  GuzDataScreen({super.key});

  final List<String> guaTitle = [
    'ألجزء ألاول',
    'ألجزء ألثاني',
    'ألجزء ألثالث',
    'ألجزء ألرابع',
    'ألجزء ألخامس',
    'ألجزء ألسادس',
    'ألجزء ألسابع',
    'ألجزء ألثامن',
    'ألجزء ألتاسع',
    'ألجزء ألعاشر',
    'ألجزء ألحادي عشر',
    'ألجزء ألثاني عشر',
    'ألجزء ألثالث عشر',
    'ألجزء ألرابع عشر',
    'ألجزء ألخامس عشر',
    'ألجزء ألسادس عشر',
    'ألجزء ألسابع عشر',
    'ألجزء ألثامن عشر',
    'ألجزء ألساتع عشر',
    'ألجزء ألعشرون',
    'ألجزء ألحادي والعشرون',
    'ألجزء ألثاني والعشرون',
    'ألجزء ألثالث والعشرون',
    'ألجزء ألرابع والعشرون',
    'ألجزء ألخامس والعشرون',
    'ألجزء ألسادس والعشرون',
    'ألجزء ألسابع والعشرون',
    'ألجزء ألثامن والعشرون',
    'ألجزء ألساتع والعشرون',
    'ألجزء ألثلاثون',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuranViewerPage(ayaNum: index+1,isJuz: true,)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 20.0),
            child: Text(
              guaTitle[index],
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.shade200,
      ),
      itemCount: 30,

    );
  }
}
