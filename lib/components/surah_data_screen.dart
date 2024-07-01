import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/components/aya_data_card.dart';
import 'package:hasanat/components/my_separator.dart';
import 'package:hasanat/models/surah_data_model.dart';
import 'package:hasanat/services/get_surah_data_services.dart';

class SurahDataScreen extends StatefulWidget {
  const SurahDataScreen({super.key});

  @override
  State<SurahDataScreen> createState() => _SurahDataScreenState();
}

class _SurahDataScreenState extends State<SurahDataScreen> {
  SurahModel model = SurahModel();
  bool isLoaded = false;

  getSurahData() async {
    model = await SurahData().getSurahData();
    setState(() {
      isLoaded = true;
    });
  }


  @override
  void initState() {
    getSurahData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: isLoaded,
      builder: (context) {
        return ListView.separated(
          itemBuilder: (context, index) {
            return AyaDataCard(
              nameAr: model.data![index].nameAr!,
              nameEn: model.data![index].nameEn!,
              type: model.data![index].type!,
              ayaNum: model.data![index].ayaNum.toString(),
              numOfAyhas:  model.data![index].numOfAyahs.toString(),
            );
          },
          separatorBuilder: (context, index) => const MySeparator(),
          itemCount: 114,
        );
      },
      fallback: (context) => const Center(child: CircularProgressIndicator()),
    );
  }
}
