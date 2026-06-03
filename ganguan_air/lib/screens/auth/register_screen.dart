import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final namaController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            children: [
              const SizedBox(height: 30),

              Center(
                child: Image.asset(
                  'assets/images/logo.jpg.jpeg',
                  width: 120,
                  height: 120,
                ),
              ),

              const SizedBox(height: 24),

              /// TITLE
              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Silahkan isi data anda',

                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// NAMA
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
                  controller: namaController,

                  decoration: const InputDecoration(
                    hintText: 'Nama',

                    prefixIcon: Icon(Icons.person, color: Colors.blue),

                    border: InputBorder.none,

                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// EMAIL
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

              /// PASSWORD
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

                    prefixIcon: const Icon(Icons.lock, color: Colors.blue),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isHidden = !isHidden;
                        });
                      },

                      icon: Icon(
                        isHidden ? Icons.visibility_off : Icons.visibility,

                        color: Colors.grey,
                      ),
                    ),

                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// BUTTON REGISTER
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: () async {
                    var result = await AuthService.register(
                      namaController.text,
                      emailController.text,
                      passwordController.text,
                    );

                    if (!mounted) return;
                    final currentContext = context;

                    if (result['success']) {
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );

                      Navigator.pop(currentContext);
                    } else {
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );
                    }
                  },

                  child: const Text(
                    'DAFTAR',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
