import 'package:flutter/material.dart';
import 'package:rmnotes/constants/routes.dart';
import 'package:rmnotes/services/auth/auth_exceptions.dart';
import 'package:rmnotes/services/auth/auth_service.dart';
// import 'dart:developer' as dev show log;

import 'package:rmnotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: true,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
            const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak password.'
                    'password must be 8-16 characters long,'
                    'and contain at least one uppercase character'
                    'one lowercase character and one number.');
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'Email is already in use.');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'Email is invalid.');
              } on GenericAuthException{
                await showErrorDialog(context, 'Failed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (route) => false,
                );
              },
              child: const Text('Already registered? Login here'))
        ],
      ),
    );
  }
}
