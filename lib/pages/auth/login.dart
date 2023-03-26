import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuthException? _authException;

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      //TODO somthing wirh error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              label: "Email",
              controller: _emailController,
              validator: (text) =>
                  _authException?.code == "email-already-in-use"
                      ? "Email is already in use"
                      : null,
              onChange: (text) {
                _authException = null;
                _formKey.currentState!.validate();
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            _buildTextField(
              label: "Password",
              controller: _passwordController,
              validator: (text) => _authException?.code == "weak-password"
                  ? "Password is too weak"
                  : null,
              onChange: (text) {
                _authException = null;
                _formKey.currentState!.validate();
              },
              isSecret: true,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () =>
                  login(_emailController.text, _passwordController.text),
              child: const Text('Log In'),
            ),
          ],
        ));
  }

  Widget _buildTextField(
          {required String label,
          TextEditingController? controller,
          Function(String)? onChange,
          String? Function(String? value)? validator,
          bool isSecret = false}) =>
      TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: isSecret,
        enableSuggestions: !isSecret,
        autocorrect: !isSecret,
        onChanged: onChange,
      );
}
