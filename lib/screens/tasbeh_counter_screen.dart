
import 'package:flutter/material.dart';
import 'package:hasanat/ad_mob/banner_ad.dart';
int counter = 0;

class TasbehCounterScreen extends StatefulWidget {
  const TasbehCounterScreen({super.key});

  @override
  State<TasbehCounterScreen> createState() => _TasbehCounterScreenState();
}

class _TasbehCounterScreenState extends State<TasbehCounterScreen> {

  @override
  Widget build(BuildContext context) {

    precacheImage(const AssetImage('assets/images/muslim-mosque-desert.jpg'), context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/muslim-mosque-desert.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay with opacity
          Container(
            color: Colors.white.withOpacity(0.7), // Adjust opacity here
          ),
          // Other Widgets on top of the background image
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 70.0, vertical: 30.0),
                    child: Container(
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100.withOpacity(.15),
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                            color: Colors.black87,
                            width: 1.5,
                          )),
                      child: Center(
                        child: Text(
                          counter.toString(),
                          style: const TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 184.0,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: const MyCustomButton(),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "اعاده تعيين",
                          style: TextStyle(fontSize: 17.0),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.refresh_sharp),
                            onPressed: () {
                              setState(() {
                                counter = 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      style:
                      const ButtonStyle(animationDuration: Duration(seconds: 1)),
                      color: Colors.grey.shade400.withOpacity(.2),
                      onPressed: () {
                        setState(() {
                          counter++;
                        });
                      },
                      icon: const Icon(
                        Icons.circle,
                        size: 300.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              blurRadius: 7,
                              offset: Offset(0, 3)),
                        ],
                      )),
                  const SizedBox(width: 320, height: 50, child: BannerAds())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



class MyCustomButton extends StatefulWidget {
  const MyCustomButton({super.key});

  @override
  _MyCustomButtonState createState() => _MyCustomButtonState();
}

class _MyCustomButtonState extends State<MyCustomButton> {
  String tasbeh = 'سبحان الله';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tasbeh,
          textAlign: TextAlign.start,
          textDirection: TextDirection.rtl,

          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: 80.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: GestureDetector(
            onTap: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(button.size.bottomLeft(Offset.zero),
                      ancestor: overlay),
                  button.localToGlobal(button.size.bottomRight(Offset.zero),
                      ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );

              showMenu<String>(
                color: Colors.black54,
                context: context,
                position: position,
                items: [
                  const PopupMenuItem<String>(
                    value: 'سبحان الله',
                    child: Text(
                      'سبحان الله',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'الحمد الله',
                    child: Text(
                      'الحمد الله',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'الله اكبر',
                    child: Text(
                      'الله اكبر',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  setState(() {
                    tasbeh = value;
                    counter = 0 ;
                  });
                }
              });
            },
            child: const TextButton(
              onPressed: null,
              child: Text(
                'تسابيح',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
