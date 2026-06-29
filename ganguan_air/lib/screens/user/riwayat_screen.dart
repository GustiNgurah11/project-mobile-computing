import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ganguan_air/screens/user/status_laporan_screen.dart';

class RiwayatScreen extends StatefulWidget {
  final bool filterSelesai;
  final String userEmail; // ← tambah ini

  const RiwayatScreen({
    super.key,
    this.filterSelesai = false,
    required this.userEmail, // ← tambah ini
  });

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List laporan = [];
  List laporanFilter = [];
  String filterAktif = 'Semua';
  bool isLoading = true;

  final String baseUrl = 'http://localhost/lapor_air';

  @override
  void initState() {
    super.initState();
    filterAktif = widget.filterSelesai ? 'Selesai' : 'Semua';
    getLaporan();
  }

  Future<void> getLaporan() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_laporan.php?email=${widget.userEmail}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          laporan = data;
          applyFilter(filterAktif);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error : $e");
      setState(() => isLoading = false);
    }
  }

  void applyFilter(String filter) {
    setState(() {
      filterAktif = filter;
      if (filter == 'Semua') {
        laporanFilter = laporan;
      } else {
        laporanFilter = laporan
            .where((item) => item['status'] == filter)
            .toList();
      }
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Pending": return Colors.orange;
      case "Diproses": return Colors.blue;
      case "Selesai": return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData getKategoriIcon(String keterangan) {
    final k = keterangan.toLowerCase();
    if (k.contains('bocor') || k.contains('pipa')) return Icons.water_damage_rounded;
    if (k.contains('keruh')) return Icons.opacity_rounded;
    if (k.contains('tekanan')) return Icons.speed_rounded;
    if (k.contains('mati') || k.contains('mengalir')) return Icons.water_drop_rounded;
    return Icons.report_problem_rounded;
  }

  Color getKategoriColor(String keterangan) {
    final k = keterangan.toLowerCase();
    if (k.contains('bocor') || k.contains('pipa')) return Colors.blue;
    if (k.contains('keruh')) return Colors.teal;
    if (k.contains('tekanan')) return Colors.orange;
    if (k.contains('mati') || k.contains('mengalir')) return Colors.blue;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Riwayat Laporan",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [

          // FILTER TABS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              children: ['Semua', 'Diproses', 'Selesai', 'Pending']
                  .map((filter) => _filterChip(filter))
                  .toList(),
            ),
          ),

          // LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : laporanFilter.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              filterAktif == 'Selesai'
                                  ? Icons.check_circle_outline
                                  : Icons.inbox_rounded,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              filterAktif == 'Selesai'
                                  ? "Belum ada laporan yang selesai"
                                  : "Belum ada laporan",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: laporanFilter.length,
                        itemBuilder: (context, index) {
                          final item = laporanFilter[index];
                          final status = item['status']?.toString() ?? 'Pending';
                          final keterangan = item['keterangan']?.toString() ?? '-';
                          final tanggal = item['created_at']?.toString() ?? '-';
                          final id = item['id']?.toString() ?? '-';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatusLaporanScreen(
                                    laporanId: id,
                                    userEmail: widget.userEmail, // ← tambah ini
                                  ),
                                ),
                              );
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

                                  // ICON KATEGORI
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: getKategoriColor(keterangan)
                                          .withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      getKategoriIcon(keterangan),
                                      color: getKategoriColor(keterangan),
                                      size: 28,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  // INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          keterangan,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1A237E),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID : #$id',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tanggal,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // BADGE STATUS
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(status)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  // ARROW
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 14,
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

  Widget _filterChip(String label) {
    final isActive = filterAktif == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => applyFilter(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}