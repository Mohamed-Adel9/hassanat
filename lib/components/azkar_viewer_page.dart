
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
import 'package:hasanat/components/zekr_data_card.dart';
import 'package:hasanat/models/azkar_model.dart';

class AzkarViewerPage extends StatefulWidget {
  const AzkarViewerPage({
    Key? key,
    required this.azkarModel,
  }) : super(key: key);

  final List<AzkarModel>? azkarModel;

  @override
  State<AzkarViewerPage> createState() => _AzkarViewerPageState();
}

class _AzkarViewerPageState extends State<AzkarViewerPage> {
  int zekrNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 250, 252, 1),
        title: Text(widget.azkarModel![0].category!),
      ),
      backgroundColor: const Color.fromRGBO(246, 250, 252, 1),
      body:Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/6587.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay with opacity
          Container(
            color: Colors.white.withOpacity(0.7), // Adjust opacity here
          ),
          // Other Widgets on top of the background image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Text("$zekrNum/${widget.azkarModel!.length}"),

                Expanded(
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        zekrNum = value + 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(
                                    onPressed: () {}, icon: const Icon(Icons.exposure_plus_1)),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(
                                    onPressed: () {}, icon: const Icon(Icons.exposure_minus_1)),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ZekrDataCard(azkarModel: widget.azkarModel![index]),
                            const SizedBox(height: 40,),
                            const SizedBox(width: 320, height: 50, child: BannerAds())
                          ],
                        ),
                      );
                    },
                    itemCount: widget.azkarModel!.length,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
