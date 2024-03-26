import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:whatsapp_clone/colors/colors.dart';

import 'package:whatsapp_clone/pages/twoinOne.dart';

class Rgist1 extends StatefulWidget {
  final String verificationid;

  const Rgist1({
    super.key,
    required this.verificationid,
  });

  @override
  State<Rgist1> createState() => _Rgist1State();
}

class _Rgist1State extends State<Rgist1> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false; // Флаг для индикатора загрузки

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: WhatsAppColors.appBarColor,),
      backgroundColor: WhatsAppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('PLease write your pasword',style: TextStyle(fontSize: 25,color: Color.fromARGB(255, 86, 156, 174),fontWeight: FontWeight.w700),),
            Pinput(
              controller: codeController,
              disabledPinTheme: const PinTheme(textStyle: TextStyle(fontSize: 20)),
              length: 6,
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator() // Показать индикатор загрузки
                : MaterialButton(
                    color: Colors.blue,
                    minWidth: 100,
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Установить флаг загрузки
                      });
                      try {
                        PhoneAuthCredential credential =
                            await PhoneAuthProvider.credential(
                                verificationId: widget.verificationid,
                                smsCode: codeController.text.toString());
                         FirebaseAuth.instance
                            .signInWithCredential(credential).then((value) { Navigator.push( // Заменить текущую страницу
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        );});
                       
                      } catch (ex) {
                        // Обработать ошибку корректно
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ex.toString()), // Отобразить более понятное сообщение об ошибке
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        setState(() {
                          isLoading = false; // Сбросить флаг загрузки
                        });
                      }
                    },
                    child: const Text('Проверить'), // Более понятный текст кнопки
                  ),
          ],
        ),
      ),
    );
  }
}
