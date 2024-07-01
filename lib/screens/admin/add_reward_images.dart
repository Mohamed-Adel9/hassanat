
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRewardImages extends StatefulWidget {
  const AddRewardImages({super.key});

  @override
  State<AddRewardImages> createState() => _AddRewardImagesState();
}

class _AddRewardImagesState extends State<AddRewardImages> {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  void _sendData () async {
    try {
      await _fireStore.collection('images').add({
        'weekImage': image1LinkController.text,
        'monthImage': image2LinkController.text,
        'advertImage': imageAdvertController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });


    } catch (e) {
      throw("error:$e");
    }
  }
  final _formKey = GlobalKey<FormState>();

  TextEditingController image1LinkController = TextEditingController();
  TextEditingController image2LinkController = TextEditingController();
  TextEditingController imageAdvertController = TextEditingController();





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
                          "اضف الصوره الاسبوعيه",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: image1LinkController,
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
                      const Center(
                        child: Text(
                          "اضف الصوره الشهريه",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: image2LinkController,
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

                      const Center(
                        child: Text(
                          "اضف الصوره الاعلان",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: imageAdvertController,
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
                        height: 10.0,
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
                              image1LinkController.text = '';
                              image2LinkController.text = '';
                              imageAdvertController.text = '';

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
