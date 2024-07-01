import 'package:flutter/material.dart';
import 'package:hasanat/components/azkar_viewer_page.dart';
import 'package:hasanat/models/azkar_model.dart';
import 'package:hasanat/services/get_azkar_data_services.dart';

class AzkarCard extends StatefulWidget {
   const AzkarCard({
    super.key,
    required this.number,
    required this.title,
  });

  final String? number;
  final String? title;

  @override
  State<AzkarCard> createState() => _AzkarCardState();
}

class _AzkarCardState extends State<AzkarCard> {
  List<AzkarModel>? azkarModel = [];





  Map<String, List<AzkarModel>> categorizedAzkar = {};

  Future<void> categorizeAzkar() async {
    azkarModel = await AzkarDataServices().getAzkarData();

    for (var azkar in azkarModel!) {
      if (azkar.category != null) {
        if (!categorizedAzkar.containsKey(azkar.category)) {
          categorizedAzkar[azkar.category!] = [];
        }
        categorizedAzkar[azkar.category!]!.add(azkar);
      }
    }
    setState(() {});
  }

  void someFunction(String zekr) async {
     await categorizeAzkar();
    // Example usage: get all AzkarModel objects with the category "category1"
     azkarModel = categorizedAzkar[zekr];


  }


  @override
  void initState() {
    someFunction(widget.title!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AzkarViewerPage(azkarModel: azkarModel,);
              },
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.grey.shade300,
                spreadRadius: 1.0,
                blurRadius: 5.0,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/images/circle.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      widget.number!,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  widget.title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
