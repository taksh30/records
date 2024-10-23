import 'package:flutter/material.dart';
import 'package:records/components/my_button.dart';
import 'package:records/components/my_text_field.dart';
import 'package:records/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNumberCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  // login function
  void _login() {
    String mobileNumber = _mobileNumberCtr.text.trim();
    String password = _passwordCtr.text.trim();

    // empty fields validation
    if (mobileNumber.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fields')));
    }

    // mobile number length validation
    if (mobileNumber.length != 10 && mobileNumber.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile number must be 10 digits')));
    }

    // when credentials are correct
    if (mobileNumber == '9033006262' && password == 'eVital@12') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 430,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // icon
                  const Icon(
                    Icons.list_alt,
                    size: 82,
                    color: Colors.blueGrey,
                  ),
                  const Text(
                    'Records',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),

                  // mobile number textfield
                  MyTextField(
                    controller: _mobileNumberCtr,
                    text: 'Mobile Number',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  // password textfield
                  MyTextField(
                    controller: _passwordCtr,
                    text: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),

                  // login button
                  MyButton(
                    onTap: _login,
                    text: 'Login',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
