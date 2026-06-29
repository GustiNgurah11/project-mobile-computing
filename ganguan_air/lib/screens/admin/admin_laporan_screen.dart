import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ganguan_air/screens/admin/admin_detail_screen.dart';
import 'package:ganguan_air/screens/auth/login_screen.dart';

class AdminLaporanScreen extends StatefulWidget {
  const AdminLaporanScreen({super.key});

  @override
  State<AdminLaporanScreen> createState() => _AdminLaporanScreenState();
}

class _AdminLaporanScreenState extends State<AdminLaporanScreen> {
  List laporan = [];
  List laporanFilter = [];
  bool isLoading = true;
  String filterAktif = 'Semua Status';

  final String baseUrl = 'http://localhost/lapor_air';

  @override
  void initState() {
    super.initState();
    getLaporan();
  }

  Future<void> getLaporan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_laporan.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          laporan = data;
          applyFilter(filterAktif);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void applyFilter(String filter) {
    setState(() {
      filterAktif = filter;
      if (filter == 'Semua Status') {
        laporanFilter = laporan;
      } else {
        laporanFilter =
            laporan.where((item) => item['status'] == filter).toList();
      }
    });
  }

  void konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Logout'),
          ],
        ),
        content: const Text('Apakah anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color warnaStatus(String status) {
    switch (status) {
      case "Pending": return Colors.orange;
      case "Diproses": return Colors.blue;
      case "Selesai": return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData ikonKategori(String keterangan) {
    final k = keterangan.toLowerCase();
    if (k.contains('bocor') || k.contains('pipa')) return Icons.water_damage_rounded;
    if (k.contains('keruh')) return Icons.opacity_rounded;
    if (k.contains('tekanan')) return Icons.speed_rounded;
    if (k.contains('mati') || k.contains('mengalir')) return Icons.water_drop_rounded;
    return Icons.report_problem_rounded;
  }

  Color warnaKategori(String keterangan) {
    final k = keterangan.toLowerCase();
    if (k.contains('bocor') || k.contains('pipa')) return Colors.blue;
    if (k.contains('keruh')) return Colors.teal;
    if (k.contains('tekanan')) return Colors.orange;
    if (k.contains('mati') || k.contains('mengalir')) return Colors.blue;
    return Colors.purple;
  }

  int hitungStatus(String status) {
    return laporan.where((item) => item['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.menu_rounded, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: konfirmasiLogout,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                // STATISTIK
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      _statCard('Total Laporan', laporan.length.toString(),
                          Colors.blue.shade100, Colors.blue),
                      _statCard('Diproses', hitungStatus('Diproses').toString(),
                          Colors.blue.shade50, Colors.blue),
                      _statCard('Selesai', hitungStatus('Selesai').toString(),
                          Colors.green.shade50, Colors.green),
                      _statCard('Pending', hitungStatus('Pending').toString(),
                          Colors.orange.shade50, Colors.orange),
                    ],
                  ),
                ),

                // FILTER & JUDUL
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Laporan Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: filterAktif,
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            items: [
                              'Semua Status',
                              'Pending',
                              'Diproses',
                              'Selesai',
                            ].map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s,
                                      style: const TextStyle(fontSize: 13)),
                                )).toList(),
                            onChanged: (val) => applyFilter(val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // LIST
                Expanded(
                  child: laporanFilter.isEmpty
                      ? const Center(
                          child: Text('Tidak ada laporan',
                              style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: laporanFilter.length,
                          itemBuilder: (context, index) {
                            final item = laporanFilter[index];
                            final id = item['id']?.toString() ?? '-';
                            final nama = item['nama']?.toString() ?? '-';
                            final keterangan = item['keterangan']?.toString() ?? '-';
                            final tanggal = item['created_at']?.toString() ?? '-';
                            final status = item['status']?.toString() ?? 'Pending';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminDetailScreen(laporan: item),
                                  ),
                                ).then((_) => getLaporan());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade100,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    // ICON
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: warnaKategori(keterangan)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        ikonKategori(keterangan),
                                        color: warnaKategori(keterangan),
                                        size: 26,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // INFO
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '#$id - $keterangan',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xFF1A237E),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(nama,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13)),
                                          const SizedBox(height: 3),
                                          Text(tanggal,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),

                                    // STATUS
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: warnaStatus(status)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                              color: warnaStatus(status),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _statCard(String title, String jumlah, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              jumlah,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(color: textColor, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}