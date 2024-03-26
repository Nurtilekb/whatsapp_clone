import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageListState();
  }
}

@override
State<StatefulWidget> createState() {
  return _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
  ScrollController scontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _messagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Ошибка при получении сообщений');
            }

            if (snapshot.hasData) {
              final messages = snapshot.data!.docs;
              return ListView.builder(
                controller: scontroller,
                physics: const ClampingScrollPhysics(),
                itemCount: messages.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final message =
                      messages[index].data() as Map<String, dynamic>?;

                  if (message != null) {
                    final messageText = message['message'] as String? ?? '';
                    final sender =
                        message['sender'] as String? ?? 'Unknown sender';

                    return ListTile(
                      title: Text(messageText),
                      subtitle: Text('От: $sender'),
                    );
                  }

                  return const SizedBox(); // Возвращаем пустой виджет в случае нулевого сообщения.
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
