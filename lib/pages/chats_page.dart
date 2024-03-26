import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors/colors.dart';
import 'package:whatsapp_clone/pages/status_screen.dart';
import 'package:whatsapp_clone/widget/whatsapp_calls.dart';
import 'package:whatsapp_clone/widget/whatsapp_appbar.dart';


class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const WhatsappAppBar(),
        body: const TabBarView(
          children: <Widget>[
            
            ChatsPage(),
            StatusTab (),
            WhatsappCalls(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          backgroundColor: WhatsAppColors.tabFocusedColor,
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }
}
