import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DailyQuestionAddScreen extends StatefulWidget {
  const DailyQuestionAddScreen({super.key});

  @override
  State<DailyQuestionAddScreen> createState() => _DailyQuestionAddScreenState();
}

class _DailyQuestionAddScreenState extends State<DailyQuestionAddScreen> {

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late bool dataSent ;
  void _sendData () async {
    try {
      await _fireStore.collection('quiz').add({
        'date': DateTime.now().day,
        'qusetions': {
          'qusetion': question1Controller.text,
          "ansewr" : FieldValue.arrayUnion([ans1Controller.text,ans2Controller.text,ans3Controller.text,ans4Controller.text]),
          'trueAnsIndex': int.parse(trueAnsindexController.text),

        },
      });

      setState(() {
        dataSent = true;
      });

    } catch (e) {
      throw("error:$e");
    }
  }

   showSuccessfulToast (){
    return
      MotionToast.success(
        title:  const Text("Done"),
        description:  const Text("Data uploaded successfully "),
      ).show(context);

   }
   showFailedToast (){
    return MotionToast.error(
        title:  const Text("Error"),
        description:  const Text("Please check your internet")
    ).show(context);
  }

  TextEditingController question1Controller = TextEditingController();
  TextEditingController ans1Controller = TextEditingController();
  TextEditingController ans2Controller = TextEditingController();
  TextEditingController ans3Controller = TextEditingController();
  TextEditingController ans4Controller = TextEditingController();
  TextEditingController trueAnsindexController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          "اضف الاساله",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "السوال",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        controller: question1Controller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل السوال",
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

                      TextFormField(
                        controller: ans1Controller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل الاجابه الاولي",
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

                      TextFormField(
                        controller:ans2Controller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل الاجابه الثانيه",
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

                      TextFormField(
                        controller:ans3Controller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل الاجابه الثالثه",
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

                      TextFormField(
                        controller:ans4Controller,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل الاجابه الرابعه",
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

                      TextFormField(
                        controller:trueAnsindexController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "لا يمكن ترك الحقل فارغ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            "أدخل رقم الاجابه الصحيحه",
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
                              question1Controller.text ='';
                              ans4Controller.text ='';
                              ans3Controller.text ='';
                              ans2Controller.text ='';
                              ans1Controller.text ='';
                              trueAnsindexController.text ='';

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
