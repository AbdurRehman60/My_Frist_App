import 'package:flutter/material.dart';
import 'package:fristapp/Constants/Routes.dart';
import 'package:fristapp/services/auth/auth_services.dart';

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
              AuthService.firebase().sendEmailVerification();
            },
            child: Text('Send Email Verifincating'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
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
