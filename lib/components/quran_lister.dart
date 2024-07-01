import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/models/surah_data_model.dart';
import 'package:hasanat/services/get_surah_data_services.dart';

class QuranListenScreen extends StatefulWidget {
  const QuranListenScreen({super.key});



  @override
  State<QuranListenScreen> createState() => _QuranListenScreenState();
}

class _QuranListenScreenState extends State<QuranListenScreen> {
  String url ='https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3' ;

  String reader  = "ar.abdulazizazzahrani";
  void makeUrl (String reader , int surahNum){
     url = 'https://cdn.islamic.network/quran/audio-surah/128/$reader/${surahNum+1}.mp3';
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  Future<void> _play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          SafeArea(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 40.0,
              mainAxisSpacing: 40.0,
              padding: const EdgeInsets.all(30.0),
              children: List.generate(
                114,
                    (index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * .45,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.brown,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: Text(
                              model.data![index].nameAr!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            )),
                        InkWell(
                          child: CircleAvatar(
                            backgroundColor: Colors.brown.shade300,
                            radius: 25,
                            child: const Icon(Icons.play_arrow,color: Colors.white,),
                          ),
                          onTap: () {
                            makeUrl(reader, index);
                            _play(url);
                            // if (_playerState != PlayerState.playing) {
                            //   ElevatedButton(
                            //     onPressed:() {
                            //       _play(url);
                            //     },
                            //     child: Text('Play'),
                            //   );
                            // }
                            // if (_playerState == PlayerState.playing) {
                            //   ElevatedButton(
                            // onPressed: _pause,
                            // child: Text('Pause'),
                            // );
                            // }
                            // if (_playerState == PlayerState.playing ||
                            // _playerState == PlayerState.paused) {
                            //   ElevatedButton(
                            // onPressed: _stop,
                            // child: Text('Stop'),
                            // );
                            // }
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
