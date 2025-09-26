import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'package:cinema_reservations_front/utils/global_colors.dart';
import '../widgets/global_button.dart';
import '../widgets/global_text_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final jmbgController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = User(
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        email: emailController.text.trim(),
        jmbg: jmbgController.text.trim(),
        role: 'Client',
        password: passwordController.text.trim(),
        // MobileNumber: phoneNumberController.text.trim(),
      );

      // print('Podaci za registraciju: ${userData.email}, ${userData.MobileNumber}');

      final authService = AuthService();
      final success = await authService.signUp(userData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Registration successful! Please login now!' : 'Registration failed. Please try again.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (value.length < 2) {
      return 'Name must have at least 2 characters';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Surname is required';
    } else if (value.length < 2) {
      return 'Surname must have at least 2 characters';
    }
    return null;
  }

  String? _validateJmbg(String? value) {
    if (value == null || value.trim().length != 13 || int.tryParse(value.trim()) == null) {
      return 'JMBG must have 13 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Register",
                    style: TextStyle(
                      color: GlobalColors.red,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hello user, an exciting journey awaits you",
                    style: TextStyle(
                      color: Color(0xFFFEF9F1),
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: nameController,
                    obscure: false,
                    text: 'Name',
                    textInputType: TextInputType.text,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: surnameController,
                    obscure: false,
                    text: 'Surname',
                    textInputType: TextInputType.text,
                    validator: _validateSurname,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: jmbgController,
                    obscure: false,
                    text: 'JMBG',
                    textInputType: TextInputType.number,
                    validator: _validateJmbg,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: emailController,
                    obscure: false,
                    text: 'Email Address',
                    textInputType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: phoneNumberController,
                    obscure: false,
                    text: 'Phone Number',
                    textInputType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 20),
                  GlobalTextForm(
                    controller: passwordController,
                    obscure: true,
                    text: 'Password',
                    textInputType: TextInputType.text,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GlobalButton(
                      text: 'Register',
                      onPressed: _submit,
                      backgroundColor: GlobalColors.red,
                      textColor: GlobalColors.black,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Color(0xFFFEF9F1),
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'login/');
                        },
                        child: Text(
                          " Log in!",
                          style: TextStyle(
                            color: GlobalColors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
