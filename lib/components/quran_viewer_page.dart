import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/models/pages_data_model.dart';
import 'package:hasanat/services/get_surah_data_services.dart';

class QuranViewerPage extends StatefulWidget {
  const QuranViewerPage({super.key, required this.ayaNum, this.isJuz = false});

  final int ayaNum;
  final bool isJuz;

  @override
  State<QuranViewerPage> createState() => _QuranViewerPageState();
}

class _QuranViewerPageState extends State<QuranViewerPage> {
  List<PagesModel> pages = [];
  List<String> images = [];

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  sendDataToDB(String title,int index,int lenght,int surahNum) async {
    await _fireStore.collection('saved_data').add({
      'pageTitle': title,
      'userId': user!.uid,
      "index": index,
      "lenght": lenght,
      "surahNum": surahNum,
      "time": FieldValue.serverTimestamp(),
    });
    setState(() {
    });
  }

  getSurahPagesData() async {
    pages = await SurahData().getPagesData("surah");
    setState(() {
      // Update UI if necessary
    });

    if (pages.isNotEmpty) {
      bool foundSelectedSurah = false;

      for (int i = 0; i < pages.length; i++) {
        final currentPage = pages[i];
        final nextPage = i + 1 < pages.length ? pages[i + 1] : pages[i];

        if (int.tryParse(currentPage.index!) == widget.ayaNum) {
          foundSelectedSurah = true; // Set to true if selected surah is found
        }

        if (foundSelectedSurah) {
          if (int.tryParse(currentPage.page!) != int.tryParse(nextPage.page!)) {
            for (int j = int.parse(currentPage.page!);
                j < int.parse(nextPage.page!);
                j++) {
              images.add('assets/quranData/quran_images_new_2/$j.png');
            }
          } else if (int.tryParse(currentPage.index!) == widget.ayaNum) {
            images.add(
                'assets/quranData/quran_images_new_2/${currentPage.page}.png');
          }

          // If next page is not part of the selected surah or doesn't exist, break the loop
          if (int.tryParse(nextPage.index!) != widget.ayaNum) {
            break;
          }
        }
      }
    }
  }

  geGuzPagesData() async {
    pages = await SurahData().getPagesData("juz");
    setState(() {
      // Update UI if necessary
    });

    for (var i = 0; i < pages.length; i++) {
      if (int.tryParse(pages[i].index!) == widget.ayaNum) {
        if (i == (pages.length - 1)) {
          for (var j = int.parse(pages[i].page!); j < 605; j++) {
            images.add('assets/quranData/quran_images_new_2/$j.png');
          }
        } else {
          for (var j = int.parse(pages[i].page!);
              j < int.parse(pages[i + 1].page!);
              j++) {
            images.add('assets/quranData/quran_images_new_2/$j.png');
          }
        }
      }
    }
  }

  String savedPage = '';
  bool isTapped = false;

  @override
  void initState() {
    widget.isJuz ? geGuzPagesData() : getSurahPagesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      if (isTapped == false) {
                        setState(() {
                          isTapped = true;
                        });
                      } else {
                        setState(() {
                          isTapped = false;
                        });
                      }
                      savedPage = images[index];
                      sendDataToDB(savedPage,index+1,images.length,widget.ayaNum);
                    },
                    icon: isTapped
                        ? const Icon(
                            Icons.bookmark,
                            size: 30.0,
                          )
                        : const Icon(
                            Icons.bookmark_border,
                            size: 30.0,
                          ),
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
