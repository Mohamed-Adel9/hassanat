import 'package:flutter/material.dart';
import 'package:hasanat/components/quran_viewer_page.dart';
import 'package:hasanat/core/app_asset.dart';
import 'package:hasanat/core/app_color.dart';


class AyaDataCard extends StatefulWidget {
  const AyaDataCard({
    super.key,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.ayaNum,
    required this.numOfAyhas,
  });

  final String ayaNum;
  final String nameAr;
  final String nameEn;
  final String type;
  final String numOfAyhas;
  @override
  State<AyaDataCard> createState() => _AyaDataCardState();
}

class _AyaDataCardState extends State<AyaDataCard> {

 



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return QuranViewerPage(ayaNum : int.parse(widget.ayaNum));
              },
            ),
          );
          // print(widget.nameAr);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Image(
                  image: AssetImage(AppAsset.ayahNum),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                Text(
                  widget.ayaNum,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameEn,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.type,
                        style: const TextStyle(
                            color: AppColor.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColor.primaryLight,
                        ),
                      ),
                      Text(
                        widget.numOfAyhas,
                        style: const TextStyle(
                            color: AppColor.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                      const Text(
                        ": عدد اياتها",
                        style: TextStyle(
                            color: AppColor.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.nameAr,
                style: const TextStyle(
                    fontSize: 22.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
