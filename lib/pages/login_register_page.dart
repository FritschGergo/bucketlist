import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isTermsAndConditionsChecked = false;
  bool isLogin = true;
  
  

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

   Future<void> createUserWithEmailAndPassword() async {
    try{
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(( ){
        errorMessage = e.message;
      });

    }
  }

  Widget _title() {
    return const Text('Login');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
  controller: controller,
  obscureText: isPassword && !_isPasswordVisible,
  decoration: InputDecoration(
    labelText: title,
    suffixIcon: isPassword
        ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white, // Az ikon színét kékre állítja
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
        : null,
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Az elválasztó vonal színét kékre állítja
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red), // Az elválasztó vonal színét kékre állítja, amikor a mező fókuszban van
    ),
  ),
  style: const TextStyle(
    color: Colors.white, // A beírt szöveg színét kékre állítja
  ),
);
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hmm? $errorMessage');
  }

  Widget _submitButtonLogin() {
    return ElevatedButton(
      onPressed:signInWithEmailAndPassword,
      child: const Text('Login'),
      );
  }

  Widget _submitButtonRegister() {
    return ElevatedButton(
      onPressed: () {
        if (_isTermsAndConditionsChecked) {
          if (_controllerPassword.text == _controllerConfirmPassword.text) {
            
          // Perform registration here
          createUserWithEmailAndPassword();
          } else {
            setState(() {
              errorMessage = "Incorrect confirm password";
            });
          }
        } else {
          setState(() {
            errorMessage = "Please accept the Terms and Conditions";
          });
        }
      },
      child: const Text('Register'),
    );
  }

  Widget _termsAndConditions() {
    return Row(
      children: [
        Checkbox(
          fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.white; // A CheckBox színét fehérre állítja
                },
              ),
          value: _isTermsAndConditionsChecked,
          onChanged: (value) {
            setState(() {
              _isTermsAndConditionsChecked = value ?? false;
            });
          },
        ),
        const Text('I accept the '),
        GestureDetector(
          onTap: () {
            // Implement the functionality to open the Terms and Conditions page
            // using Navigator or any other method as per your requirement.
            // For example, you can use Navigator.push to navigate to a new page
            // with the detailed terms and conditions.
            print('Open Terms and Conditions');
          },
          child: const Text(
            'Terms and Conditions',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed:(){
        setState(() {
          isLogin = !isLogin;
        });
      }, child: Text(isLogin ? 'Register insted' : 'Login insted'),
      );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.myPrimaryColor,
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('email', _controllerEmail, false),
            _entryField('password', _controllerPassword, true),
            if(!isLogin) _entryField('confirm password', _controllerConfirmPassword, true),
            _errorMessage(),
            if(!isLogin) _termsAndConditions(),
            isLogin?  _submitButtonLogin() : _submitButtonRegister(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
 