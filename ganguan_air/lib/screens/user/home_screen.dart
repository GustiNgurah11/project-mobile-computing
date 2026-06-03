import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ganguan_air/screens/user/status_laporan_screen.dart';
import 'package:ganguan_air/screens/user/riwayat_screen.dart';
import 'package:ganguan_air/screens/user/tambah_laporan_screen.dart';
import 'package:ganguan_air/screens/user/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'riwayat_screen.dart';
import 'status_laporan_screen.dart';
import 'tambah_laporan_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  int totalLaporan = 0;
  int laporanSelesai = 0;

  @override
  void initState() {
    super.initState();
    getStatistik();
  }

  Future<void> getStatistik() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/lapor_air/statistik.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          totalLaporan = int.tryParse(data['total_laporan'].toString()) ?? 0;

          laporanSelesai =
              int.tryParse(data['laporan_selesai'].toString()) ?? 0;
        });
      }
    } catch (e) {
      print("Error statistik: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,

        title: const Text(
          'Lapor Air',

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Belum ada notifikasi')),
              );
            },

            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// PROFILE CARD
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                      ),
                    ),
                  );
                },

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.blue,

                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Row(
                    children: [
                      /// AVATAR
                      Container(
                        width: 70,
                        height: 70,

                        decoration: const BoxDecoration(
                          color: Colors.white,

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.person,

                          size: 40,

                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 20),

                      /// TEXT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Selamat Datang',

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            widget.userName,

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// TITLE
              const Text(
                'Statistik',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// STATISTIK
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Total laporan')),
                        );
                      },

                      child: statistikCard(
                        totalLaporan.toString(),
                        'Laporan',
                        Icons.report,
                        Colors.orange,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Laporan selesai')),
                        );
                      },

                      child: statistikCard(
                        laporanSelesai.toString(),
                        'Selesai',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// MENU TITLE
              const Text(
                'Menu Utama',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// MENU GRID
              GridView.count(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                childAspectRatio: 1.1,

                children: [
                  /// BUAT LAPORAN
                  menuCard(Icons.add_box, 'Buat\nLaporan', Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahLaporanScreen(),
                      ),
                    );
                  }),

                  /// RIWAYAT LAPORAN
                  menuCard(
                    Icons.history,
                    'Riwayat\nLaporan',
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatScreen(),
                        ),
                      );
                    },
                  ),

                  /// STATUS LAPORAN
                  menuCard(Icons.info, 'Status\nLaporan', Colors.green, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatusLaporanScreen(),
                      ),
                    );
                  }),

                  /// PROFILE
                  menuCard(Icons.person, 'Profile', Colors.purple, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          /// HOME
          if (index == 0) {
            return;
          }

          /// LAPORAN
          if (index == 1) {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) => const TambahLaporanScreen(),
              ),
            );
          }

          /// PROFILE
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                ),
              ),
            );
          }
        },

        selectedItemColor: Colors.blue,

        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  /// MENU CARD
  Widget menuCard(
    IconData icon,
    String title,
    Color color, [
    VoidCallback? onTap,
  ]) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(25),

            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,

                blurRadius: 10,

                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),

                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: color, size: 35),
              ),

              const SizedBox(height: 15),

              Text(
                title,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// STATISTIK CARD
  Widget statistikCard(
    String jumlah,
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(icon, color: color, size: 40),

          const SizedBox(height: 10),

          Text(
            jumlah,

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
