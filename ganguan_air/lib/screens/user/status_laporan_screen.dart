import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusLaporanScreen extends StatefulWidget {
  final String? laporanId;
  final String userEmail; // ← tambah ini

  const StatusLaporanScreen({
    super.key,
    this.laporanId,
    required this.userEmail, // ← tambah ini
  });

  @override
  State<StatusLaporanScreen> createState() => _StatusLaporanScreenState();
}

class _StatusLaporanScreenState extends State<StatusLaporanScreen> {
  List laporan = [];
  bool isLoading = true;

  final String baseUrl = 'http://localhost/lapor_air';

  @override
  void initState() {
    super.initState();
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
          laporan = widget.laporanId != null
              ? data
                    .where((item) => item['id']?.toString() == widget.laporanId)
                    .toList()
              : data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR : $e");
      setState(() => isLoading = false);
    }
  }

  Color warnaStatus(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Diproses":
        return Colors.blue;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData ikonStatus(String status) {
    switch (status) {
      case "Pending":
        return Icons.hourglass_empty;
      case "Diproses":
        return Icons.engineering;
      case "Selesai":
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  bool isAktif(String progres, String tahap) {
    const urutan = [
      "Laporan Dikirim",
      "Diverifikasi",
      "Dalam Proses Perbaikan",
      "Selesai",
    ];
    final iProg = urutan.indexOf(progres);
    final iTahap = urutan.indexOf(tahap);
    return iProg >= iTahap && iProg != -1;
  }

  Widget itemTimeline(String title, bool aktif, Color warna, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: aktif ? warna : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                aktif ? Icons.check : Icons.circle_outlined,
                color: aktif ? Colors.white : Colors.grey,
                size: 18,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 35,
                color: aktif ? warna.withOpacity(0.4) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            title,
            style: TextStyle(
              color: aktif ? warna : Colors.grey,
              fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget progressTimeline(String progres) {
    final tahapan = [
      {"label": "Laporan Dikirim", "warna": Colors.blue},
      {"label": "Diverifikasi", "warna": Colors.indigo},
      {"label": "Dalam Proses Perbaikan", "warna": Colors.purple},
      {"label": "Selesai", "warna": Colors.green},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(tahapan.length, (i) {
        final label = tahapan[i]['label'] as String;
        final warna = tahapan[i]['warna'] as Color;
        final aktif = isAktif(progres, label);
        final isLast = i == tahapan.length - 1;
        return itemTimeline(label, aktif, warna, isLast);
      }),
    );
  }

  String normalizeFotoUrl(String foto) {
    final trimmed = foto.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Uri.encodeFull(trimmed);
    }
    if (trimmed.startsWith('/')) return Uri.encodeFull('$baseUrl$trimmed');
    return Uri.encodeFull('$baseUrl/uploads/$trimmed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Status Laporan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : laporan.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Belum ada laporan",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: laporan.length,
              itemBuilder: (context, index) {
                final item = laporan[index];
                final nama = item['nama']?.toString() ?? '-';
                final alamat = item['alamat']?.toString() ?? '-';
                final keterangan = item['keterangan']?.toString() ?? '-';
                final fotoRaw = item['foto']?.toString() ?? '';
                final foto = normalizeFotoUrl(fotoRaw);
                final tanggal = item['created_at']?.toString() ?? '-';
                final status = item['status']?.toString() ?? 'Pending';
                final progres =
                    item['progres']?.toString() ?? 'Laporan Dikirim';
                final id = item['id']?.toString() ?? '-';

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FOTO
                      if (foto.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            foto,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200,
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Text("Gagal memuat gambar"),
                                  ),
                                ),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ID & NAMA
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                Text(
                                  'ID #$id',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // ALAMAT
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    alamat,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            // TANGGAL
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueGrey,
                                  size: 14,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tanggal,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // KETERANGAN
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                keterangan,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // BADGE STATUS
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: warnaStatus(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    ikonStatus(status),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),
                            const Divider(),
                            const SizedBox(height: 10),

                            // JUDUL PROGRESS
                            const Text(
                              "Progress Pengerjaan",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // TIMELINE
                            progressTimeline(progres),

                            // PESAN TERIMA KASIH (hanya tampil jika dibuka dari detail/riwayat)
                            if (widget.laporanId != null) ...[
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  status == 'Selesai'
                                      ? 'Laporan anda telah selesai ditangani. Terima kasih atas kesabarannya.'
                                      : 'Terima kasih telah melaporkan.\nKami akan segera menanganinya.',
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
