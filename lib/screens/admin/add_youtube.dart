
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddYoutube extends StatefulWidget {
  const AddYoutube({super.key});

  @override
  State<AddYoutube> createState() => _AddYoutubeState();
}

class _AddYoutubeState extends State<AddYoutube> {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  void _sendData () async {
    try {
      await _fireStore.collection('youtube').add({
        'link': linkController.text,
        'face': faceController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });


    } catch (e) {
      throw("error:$e");    }
  }
  final _formKey = GlobalKey<FormState>();

  TextEditingController linkController = TextEditingController();
  TextEditingController faceController = TextEditingController();






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "اضف لينك يوتيوب",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: linkController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل اللينك",
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ), const Center(
                        child: Text(
                          "اضف لينك فيسبوك الخاص بالاعلان",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: faceController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل اللينك",
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: MaterialButton(
                          color: const Color.fromRGBO(110, 247, 110, 1),
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                            }
                            _sendData();
                            setState(() {
                              linkController.text = '';
                              faceController.text = '';

                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('done'),
                                content: const Text('done'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            "send",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
