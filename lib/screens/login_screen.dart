import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hasanat/components/my_separator.dart';
import 'package:hasanat/screens/home_screen.dart';
import 'package:hasanat/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late AppLifecycleReactor _appLifecycleReactor;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isShowing = false;
  bool btnTapped = true;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
        await auth.signInWithCredential(credential);
        final User? user = authResult.user;
        await _fireStore.collection('username').doc(user!.uid).set({
          'username': user.displayName,
          "userId": user.uid,
        });
        return user;
      }
    } catch (error) {
      throw("$error");
    }
    return null;
  }
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;



  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // Background Image
          Image.asset(
            'assets/images/loginBG.png',
            fit: BoxFit.cover,
          ),
          // Overlay with opacity
          // Container(
          //   color: Colors.blue.withOpacity(0.3), // Adjust opacity here
          // ),
          // Other Widgets on top of the background image
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/حسنات.png",
                              width: 150,
                              height: 150,
                            ),
                          ),

                          const Text(
                            "البريد الالكتروني",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: emailController,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "لا يمكن ترك الحقل فارغ";
                              }
                              return null;
                            },
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "أدخل البريد الالكتروني",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Text(
                            "كلمة المرور",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            controller: passwordController,
                            maxLines: 1,
                            obscureText: !isShowing,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "لا يمكن ترك الحقل فارغ";
                              }
                              return null;
                            },
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.white),
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (isShowing == false) {
                                    setState(() {
                                      isShowing = true;
                                    });
                                  } else {
                                    setState(() {
                                      isShowing = false;
                                    });
                                  }
                                },
                                child: isShowing
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      )
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.white),
                              ),
                              label: const Text(
                                "أدخل كلمة المرور",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                            ),
                            style: const TextStyle(color: Colors.white),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                }
                                setState(() {
                                  btnTapped = false;
                                  Timer(const Duration(seconds: 3), () {
                                    setState(() {
                                      btnTapped = true;
                                    });
                                  });
                                });

                                try {
                                  await _auth.signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const HomeScreen();
                                      },
                                    ),
                                  );
                                  setState(() {
                                    btnTapped = true;
                                  });
                                } catch (e) {
                                  throw("error :$e");
                                }
                              },
                              child: ConditionalBuilder(
                                builder: (context) => const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                                condition: btnTapped,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const MySeparator(),
                          Center(
                            child: IconButton(
                                onPressed: () async {
                                  _signInWithGoogle().then((value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const HomeScreen();
                                        },
                                      ),
                                    );
                                  }).catchError((onError){
                                  });
                                  setState(() {
                                  });



                                },
                                icon:  CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/gmail.png"
                                        ,width: 30,
                                        height: 30,
                                      ),
                                      const Text(" مرتين")
                                    ],
                                  ),
                                )),
                          ),
                          const Center(
                              child: Text(
                            "او",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const RegisterScreen();
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  "سجل الان",
                                  style: TextStyle(
                                      color: Color.fromRGBO(110, 200, 110, 1),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Text(
                                "ليس لديك حساب بعد ؟",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Center(
                            child: Image.asset(
                              "assets/images/loginText.png",
                              width: 200,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // SizedBox(height: 25.0,),
                        ],
                      ),
                    ),
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
