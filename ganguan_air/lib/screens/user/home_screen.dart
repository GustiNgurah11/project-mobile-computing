import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ganguan_air/screens/user/status_laporan_screen.dart';
import 'package:ganguan_air/screens/user/riwayat_screen.dart';
import 'package:ganguan_air/screens/user/tambah_laporan_screen.dart';
import 'package:ganguan_air/screens/user/profile_screen.dart';
import 'package:ganguan_air/screens/user/notifikasi_screen.dart';
import 'package:http/http.dart' as http;

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
  int jumlahNotifBelumDibaca = 0;

  @override
  void initState() {
    super.initState();
    getStatistik();
    getJumlahNotif();
  }

  Future<void> getStatistik() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost/lapor_air/statistik.php?email=${widget.userEmail}',
        ),
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

  Future<void> getJumlahNotif() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost/lapor_air/get_notifikasi.php?email=${widget.userEmail}',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          jumlahNotifBelumDibaca = data
              .where((item) => item['is_read'].toString() == '0')
              .length;
        });
      }
    } catch (e) {
      print("Error notif: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Lapor Air',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotifikasiScreen(userEmail: widget.userEmail),
                    ),
                  ).then((_) {
                    getJumlahNotif();
                    setState(() => currentIndex = 0);
                  });
                },
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                ),
              ),
              if (jumlahNotifBelumDibaca > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        jumlahNotifBelumDibaca.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER BIRU
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                      ),
                    ),
                  ).then((_) => setState(() => currentIndex = 0));
                },
                child: Row(
                  children: [
                    // AVATAR
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade700,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 20),

                    // TEKS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang 👋',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userEmail,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white60,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATISTIK
                  const Text(
                    'Statistik',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RiwayatScreen(userEmail: widget.userEmail),
                              ),
                            ).then((_) => setState(() => currentIndex = 0));
                          },
                          child: statistikCard(
                            totalLaporan.toString(),
                            'Total Laporan',
                            Icons.report_rounded,
                            Colors.orange,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RiwayatScreen(
                                  filterSelesai: true,
                                  userEmail: widget.userEmail,
                                ),
                              ),
                            ).then((_) => setState(() => currentIndex = 0));
                          },
                          child: statistikCard(
                            laporanSelesai.toString(),
                            'Selesai',
                            Icons.check_circle_rounded,
                            Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // MENU UTAMA
                  const Text(
                    'Menu Utama',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),

                  const SizedBox(height: 15),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                    children: [
                      menuCard(
                        Icons.add_box_rounded,
                        'Buat\nLaporan',
                        Colors.blue,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahLaporanScreen(
                                userName: widget.userName,
                                userEmail: widget.userEmail,
                              ),
                            ),
                          ).then((_) {
                            setState(() => currentIndex = 0);
                            getStatistik();
                            getJumlahNotif();
                          });
                        },
                      ),
                      menuCard(
                        Icons.history_rounded,
                        'Riwayat\nLaporan',
                        Colors.orange,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RiwayatScreen(userEmail: widget.userEmail),
                            ),
                          ).then((_) => setState(() => currentIndex = 0));
                        },
                      ),
                      menuCard(
                        Icons.info_rounded,
                        'Status\nLaporan',
                        Colors.green,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatusLaporanScreen(
                                userEmail: widget.userEmail,
                              ),
                            ),
                          ).then((_) => setState(() => currentIndex = 0));
                        },
                      ),
                      menuCard(
                        Icons.person_rounded,
                        'Profile',
                        Colors.purple,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userName: widget.userName,
                                userEmail: widget.userEmail,
                              ),
                            ),
                          ).then((_) => setState(() => currentIndex = 0));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            setState(() => currentIndex = 0);
            return;
          }

          if (index == 1) {
            setState(() => currentIndex = 1);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahLaporanScreen(
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                ),
              ),
            ).then((_) {
              setState(() => currentIndex = 0);
              getStatistik();
              getJumlahNotif();
            });
          }

          if (index == 2) {
            setState(() => currentIndex = 2);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userName: widget.userName,
                  userEmail: widget.userEmail,
                ),
              ),
            ).then((_) => setState(() => currentIndex = 0));
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // MENU CARD
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
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STATISTIK CARD
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            jumlah,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
