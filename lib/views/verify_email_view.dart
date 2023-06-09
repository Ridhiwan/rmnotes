import 'package:flutter/material.dart';
import 'package:rmnotes/constants/routes.dart';
import 'package:rmnotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text('We have sent you a verification email, '
              'please open it to verify your account'),
          const Text('If you have not received the email, click below: '),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send verification email.')),
          TextButton(
              onPressed: () async{
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, (route) => false);
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
