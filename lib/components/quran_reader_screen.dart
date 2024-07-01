// import 'package:flutter/material.dart';
// import 'package:hasanat/components/quran_lister.dart';
// import 'package:hasanat/models/reader_name_model.dart';
// import 'package:hasanat/services/get_reader_name.dart';
//
// class QuranReaderScreen extends StatefulWidget {
//   const QuranReaderScreen({super.key});
//
//   @override
//   State<QuranReaderScreen> createState() => _QuranReaderScreenState();
// }
//
// class _QuranReaderScreenState extends State<QuranReaderScreen> {
//   List<dynamic> reader = [];
//
//   getReaderName() async {
//     reader = await ReaderNameServices().getReaderName();
//   }
//
//   getData() async {
//     await getReaderName();
//     setState(() {
//
//     });
//   }
//
//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background Image
//           Image.asset(
//             'assets/images/muslim-mosque-desert.jpg',
//             fit: BoxFit.cover,
//           ),
//           // Overlay with opacity
//           Container(
//             color: Colors.white.withOpacity(0.7), // Adjust opacity here
//           ),
//
//           SafeArea(
//             child: Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20.0),
//                   child: Text(
//                     "اختر القارئ",
//                     style: TextStyle(fontSize: 30),
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 40.0,
//                     mainAxisSpacing: 40.0,
//                     padding: const EdgeInsets.all(30.0),
//                     children: List.generate(
//                       reader.length,
//                       (index) {
//                         return InkWell(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return QuranListenScreen(reader: reader[index].identifier,);
//                                 },
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * .45,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.brown,
//                             ),
//                             child: Center(
//                                 child: Text(
//                               reader[index].name,
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 fontSize: 25,
//                                 color: Colors.white,
//                               ),
//                             )),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
