import 'package:flutter/material.dart';
import 'package:hasanat/screens/admin/add_banner_images.dart';
import 'package:hasanat/screens/admin/add_youtube.dart';
import 'package:hasanat/screens/admin/daily_question_add.dart';

import 'add_reward_images.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DailyQuestionAddScreen() ,),);
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: Colors.brown),
                  child: const Center(
                  child: Text("اضافه الاساله اليوميه",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),
                ),
                  ),
              ),

          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddRewardImages() ,),);
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: Colors.brown),
                  child: const Center(
                  child: Text("اضافه صور الجوائز",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),
                ),
                  ),
              ),

          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddYoutube(),),);
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: Colors.brown),
                  child: const Center(
                  child: Text("اضافه لينك يوتيوب",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),
                ),
                  ),
              ),

          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddBannerImages(),),);
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: Colors.brown),
                  child: const Center(
                  child: Text("اضافه لينك صور البانر",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0,color: Colors.white),
                      ),
                ),
                  ),
              ),

          ),
        ],
      ),
    );
  }
}
