import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),

            // App Title
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 50,
              ),
            ),

            // Logo
            Image.asset(
              'assets/images/logo.webp',
              width: 80,
              height: 60,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Email
                  TextFieldInput(
                    controller: emailController,
                    isPassword: false,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Username
                  TextFieldInput(
                    controller: usernameController,
                    isPassword: false,
                    hintText: 'Username',
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  TextFieldInput(
                    controller: passwordController,
                    isPassword: !_passwordVisible,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password
                  TextFieldInput(
                    controller: passwordConfirmController,
                    isPassword: !_passwordVisible,
                    hintText: 'Confirm Password',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Sign Up Button
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Sign up logic
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text("Already have an account? "),
                        TextButton(
                        onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                        },
                        child: const Text(
                            'Log in',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(218, 226, 37, 24),
                            ),
                        ),
                    ),
                    ],
                ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
