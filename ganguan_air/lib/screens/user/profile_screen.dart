import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,

        title: const Text(
          'Profile',

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              /// PROFILE CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.blue,

                  borderRadius: BorderRadius.circular(25),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,

                      blurRadius: 10,

                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    /// AVATAR
                    Container(
                      width: 100,
                      height: 100,

                      decoration: const BoxDecoration(
                        color: Colors.white,

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person,

                        size: 55,

                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// USERNAME
                    Text(
                      userName,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 26,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// USER TYPE
                    const Text(
                      'User Lapor Air',

                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// EMAIL CARD
              infoCard('Email', userEmail),

              const SizedBox(height: 15),

              /// NAMA CARD
              infoCard('Nama', userName),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  /// INFO CARD
  Widget infoCard(String title, String value) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,

            blurRadius: 8,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),

          const SizedBox(height: 5),

          Text(
            value,

            style: const TextStyle(
              color: Colors.black,

              fontSize: 16,

              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
