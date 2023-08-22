import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Emailverfing extends StatefulWidget {
  const Emailverfing({super.key});

  @override
  State<Emailverfing> createState() => _EmailverfingState();
}

class _EmailverfingState extends State<Emailverfing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verifing'),
      ),
      body: Column(
        children: [
          Text('please Verfing your email Address:'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: Text('Send Email Verifincating'))
        ],
      ),
    );
  }
}
