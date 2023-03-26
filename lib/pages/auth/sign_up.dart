import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuthException? _authException;

  Future<void> signUp(String displayName, String email, String password) async {
    setState(() {
      _authException = null;
    });
    if (!_formKey.currentState!.validate()) {
      print("somethings wrong");
      return;
    }
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      print("User created");
    } on FirebaseAuthException catch (e) {
      setState(() {
        _authException = e;
        _formKey.currentState!.validate();
      });
      print(e.code);
    } catch (e) {
      print(e);
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
              label: "Username",
              controller: _displayNameController,
              validator: (text) => text == null || text.isEmpty
                  ? "Please enter a username."
                  : null,
            ),
            const SizedBox(
              height: 20.0,
            ),
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
              onPressed: () => signUp(_displayNameController.text,
                  _emailController.text, _passwordController.text),
              child: const Text('Sign Up'),
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
