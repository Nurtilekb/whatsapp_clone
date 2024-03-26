import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessageList(scontroller: _scontroller),
          ),
          MessageForm(scontroller: _scontroller),
        ],
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  const MessageList({Key? key, required this.scontroller}) : super(key: key);
  final ScrollController scontroller;

  @override
  State<StatefulWidget> createState() {
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка при получении сообщений');
        }

        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          return ListView.builder(
            controller: widget.scontroller,
            physics: const ClampingScrollPhysics(),
            itemCount: messages.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final message = messages[index].data() as Map<String, dynamic>?;

              if (message != null) {
                final messageText = message['message']?.toString() ?? '';
                final sender = message['sender']?.toString() ?? 'Unknown sender';

                return ListTile(
                  title: Text(messageText),
                  subtitle: Text('От: $sender'),
                );
              }

              return const SizedBox(); 
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MessageForm extends StatefulWidget {
  const MessageForm({Key? key, required this.scontroller}) : super(key: key);
  final ScrollController scontroller;

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _recipientController,
            decoration: const InputDecoration(
              labelText: 'Номер телефона получателя',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите номер телефона получателя';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Сообщение'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите сообщение';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final sender = FirebaseAuth.instance.currentUser!.phoneNumber;
                final docRef =
                    FirebaseFirestore.instance.collection('messages').doc();
                docRef.set({
                  'sender': sender,
                  'recipient': _recipientController.text,
                  'message': _messageController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                }).then((value) {
                  // Сообщение успешно отправлено
                 
                }).catchError((error) {
                  // Обработать ошибку
                });
                 
              }
              // Прокручиваем чат к последнему сообщению после отправки
              widget.scontroller
                  .jumpTo(widget.scontroller.position.maxScrollExtent);
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }
}
