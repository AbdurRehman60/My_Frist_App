import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fristapp/Constants/Routes.dart';

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
          Text(
            'We have sent you Email verfing Link On your Email',
          ),
          Text(
            'You cannot Recive a Email Please Press the Email Verfing Button',
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: Text('Send Email Verifincating'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                RegisterRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
