import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristapp/Constants/Routes.dart';
import 'package:fristapp/Utilities/ShowErrorDialog.dart';
import 'package:fristapp/services/auth/auth_exceptions.dart';
import 'package:fristapp/services/bloc/auth_bloc.dart';
import 'package:fristapp/services/bloc/bloc_event.dart';

class loginview extends StatefulWidget {
  const loginview({super.key});

  @override
  State<loginview> createState() => _loginviewState();
}

class _loginviewState extends State<loginview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Enter Email Please'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: 'Enter Password Please'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                context.read<AuthBloc>().add(AuthEventLogin(
                      email,
                      password,
                    ));
              } on UserNotFoundAuthException {
                await ShowErrorDialog(
                  context,
                  'User Not Found',
                );
              } on WorngPasswordAuthException {
                await ShowErrorDialog(
                  context,
                  'Enter Worng creditianls',
                );
              } on GenericAuthException {
                await ShowErrorDialog(context, 'Authentication');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(RegisterRoute, (route) => false);
              },
              child: Text('Not Register Yet? Fristly regsister here'))
        ],
      ),
    );
  }
}
