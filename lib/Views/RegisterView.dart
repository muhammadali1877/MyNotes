import 'package:ajeebdastan/constants/routes.dart';
import 'package:ajeebdastan/services/auth/auth_exception.dart';
import 'package:ajeebdastan/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ajeebdastan/Utilities/show_Error_Dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

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
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password "),
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

                AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "invalid-email");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  "email-already-in-use",
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "weak-password",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Registration failed',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already has an account? Login here."),
          )
        ],
      ),
    );
  }
}
