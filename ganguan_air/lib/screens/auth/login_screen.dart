import 'package:flutter/material.dart';
import 'register_screen.dart';

import '../../services/auth_service.dart';
import '../user/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [
            /// CONTENT
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Center(
                      child: Image.asset(
                        'assets/images/logo.jpg.jpeg',
                        width: 120,
                        height: 120,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// TITLE
                    const Text(
                      'Login',

                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// SUBTITLE
                    const Text(
                      'Masuk untuk menggunakan akun anda',

                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 60),

                    /// EMAIL FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: TextField(
                        controller: emailController,

                        decoration: const InputDecoration(
                          hintText: 'Email',

                          prefixIcon: Icon(Icons.email, color: Colors.blue),

                          border: InputBorder.none,

                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// PASSWORD FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: TextField(
                        controller: passwordController,

                        obscureText: isHidden,

                        decoration: InputDecoration(
                          hintText: 'Password',

                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },

                            icon: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,

                              color: Colors.grey,
                            ),
                          ),

                          border: InputBorder.none,

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// LUPA PASSWORD
                    Align(
                      alignment: Alignment.centerRight,

                      child: TextButton(
                        onPressed: () {},

                        child: const Text(
                          'Lupa password?',

                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// BUTTON LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,

                          elevation: 5,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: () async {
                          if (emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email wajib diisi'),
                              ),
                            );

                            return;
                          }

                          if (passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password wajib diisi'),
                              ),
                            );

                            return;
                          }

                          var result = await AuthService.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (!mounted) return;
                          final currentContext = context;

                          if (result['success']) {
                            final data = result['data'];
                            String userName = '';
                            String userEmail = emailController.text;

                            if (data is Map) {
                              userName =
                                  (data['nama'] ??
                                          data['name'] ??
                                          data['username'] ??
                                          '')
                                      as String;
                              userEmail =
                                  (data['email'] ?? userEmail) as String;
                            }

                            if (userName.isEmpty) {
                              userName = emailController.text.split('@').first;
                            }

                            Navigator.pushReplacement(
                              currentContext,

                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  userName: userName,
                                  userEmail: userEmail,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(currentContext).showSnackBar(
                              const SnackBar(content: Text('Login gagal')),
                            );
                          }
                        },

                        child: const Text(
                          'LOGIN',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text('Belum punya akun?'),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            'Daftar di sini',

                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
