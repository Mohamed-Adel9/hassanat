import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasanat/screens/home_screen.dart';
import 'package:hasanat/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isShowing = false;

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await _fireStore.collection('username').doc(newUser.user!.uid).set({
        'username': usernameController.text.trim(),
        "userId": newUser.user!.uid,
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ),
      );
    } catch (e) {
      throw("error : $e");
    }
  }

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

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "حَسنات",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Center(
                          child: Text(
                            "انضم الينا الان",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text(
                          "اسم المستخدم",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          controller: usernameController,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "لا يمكن ترك الحقل فارغ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "أدخل اسم المستخدم",
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
                          cursorColor: Colors.white,
                          controller: passwordController,
                          maxLines: 1,
                          obscureText: !isShowing,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "لا يمكن ترك الحقل فارغ";
                            }
                            return null;
                          },
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
                        const Text(
                          "تاكيد كلمه المرور",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          controller: passwordConfirmController,
                          maxLines: 1,
                          obscureText: !isShowing,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "لا يمكن ترك الحقل فارغ";
                            }
                            return null;
                          },
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
                              "اعد ادخال كلمة المرور",
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
                          height: 40.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0)),
                          child: MaterialButton(
                            color: const Color.fromRGBO(110, 247, 110, 1),
                            onPressed: _register,
                            child: const Text(
                              "سجل",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginScreen();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                "سجل الدخول",
                                style: TextStyle(
                                    color: Color.fromRGBO(110, 200, 110, 1),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text(
                              "لديك حساب بالفعل ؟",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
