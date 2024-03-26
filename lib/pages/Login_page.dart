import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors/colors.dart';
import 'package:whatsapp_clone/pages/regs1.dart';

class LogNum extends StatelessWidget {
  const LogNum({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotter Passwordless App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 109, 94, 150),
        buttonTheme: const ButtonThemeData(minWidth: double.infinity),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

// Our Home Page
class LoginPageState extends State<LoginPage> {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: WhatsAppColors.backgroundColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Titles

              Row(
                children: [
                  const Text("Enter your phone number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                  const SizedBox(
                    width: 33,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  "WhatsApp requires you to verify your account. What's my number?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(
                height: 70,
              ),
              Form(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Your number",
                    hintText: '+996__________ ',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 157, 146, 146)),
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  controller: inputController,
                  maxLength: 13,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("International carrier rates may apply.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException ex) {},
                      codeSent: (String verificationid, int? resendtoken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Rgist1(verificationid: verificationid)));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: inputController.text.toString());
                },
                color: Colors.green,
                textColor: Colors.white,
                child: const Text(
                  "Sign In With Number",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
