import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/Constants/Routes.dart';
import 'package:fristapp/Views/Login_Views.dart';
import 'package:fristapp/Views/Register_View.dart';
import 'package:fristapp/Views/notes/new_notes.dart';
import 'package:fristapp/Views/notes/notes_view.dart';
import 'package:fristapp/services/auth/auth_services.dart';
import 'package:fristapp/services/auth/firebase_auth_provider.dart';
import 'package:fristapp/services/bloc/auth_bloc.dart';
import 'package:fristapp/services/bloc/bloc_event.dart';
import 'package:fristapp/services/bloc/bloc_state.dart';

//import 'dart:developer' as devtools show log;

import 'Views/Verifying_Email.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: homepage(),
      ),
      routes: {
        loginRoute: (context) => const loginview(),
        RegisterRoute: (context) => const Registerview(),
        NotesRoute: (context) => const NotesView(),
        EmailverfingRoute: (context) => const Emailverfing(),
        newNoteRoute: (context) => const NewNoteView(),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedVerification) {
          return const Emailverfing();
        } else if (state is AuthEventLogout) {
          return const loginview();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
