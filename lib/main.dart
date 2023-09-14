import 'package:flutter/material.dart';
import 'package:fristapp/Constants/Routes.dart';
import 'package:fristapp/Views/Login_Views.dart';
import 'package:fristapp/Views/Register_View.dart';
import 'package:fristapp/Views/notes_view.dart';
import 'package:fristapp/services/auth/auth_services.dart';

//import 'dart:developer' as devtools show log;

import 'Views/Verifying_Email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//up something
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
      routes: {
        loginRoute: (context) => const loginview(),
        RegisterRoute: (context) => const Registerview(),
        NotesRoute: (context) => const NotesView(),
        EmailverfingRoute: (context) => const Emailverfing(),
      },
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await AuthService.firebase().currentUser!.reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              print(user);
              if (user != null) {
                if (user.isEmailVerified) {
                  print('Email is Verified');
                  return const NotesView();
                } else {
                  return const Emailverfing();
                }
              } else {
                return const loginview();
              }

            default:
              return CircularProgressIndicator();
          }
        });
  }
}
