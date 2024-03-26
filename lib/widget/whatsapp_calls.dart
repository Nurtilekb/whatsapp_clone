import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors/colors.dart';

class WhatsappCalls extends StatelessWidget {
  const WhatsappCalls({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: double.infinity,
      color: WhatsAppColors.backgroundColor,
    );
  }
}
