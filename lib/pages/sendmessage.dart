import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageForm extends StatefulWidget {
  final ScrollController scontroller;

  const MessageForm({Key? key, required this.scontroller}) : super(key: key);

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
                final docRef = FirebaseFirestore.instance.collection('messages').doc();
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
              widget.scontroller.jumpTo(widget.scontroller.position.maxScrollExtent);
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }
}
