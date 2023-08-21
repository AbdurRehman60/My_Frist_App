import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fristapp/Views/Login_Views.dart';
import 'package:fristapp/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const homepage(),
    );
  }
}

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home page'),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  // final user = FirebaseAuth.instance.currentUser;
                  // if (user?.emailVerified ?? false) {
                  //   print('Your Verified user');
                  // } else {
                  //   print('you need to verified your email frist time');

                  //    return Emailverfing();
                  // }
                  return loginview();
                default:
                  return Text('Loading...');
              }
            }));
  }
}

class Emailverfing extends StatefulWidget {
  const Emailverfing({super.key});

  @override
  State<Emailverfing> createState() => _EmailverfingState();
}

class _EmailverfingState extends State<Emailverfing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('please Verfing your email Address:'),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: Text('Send Email Verifincating'))
      ],
    );
  }
}
