import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusLaporanScreen extends StatefulWidget {
  const StatusLaporanScreen({super.key});

  @override
  State<StatusLaporanScreen> createState() => _StatusLaporanScreenState();
}

class _StatusLaporanScreenState extends State<StatusLaporanScreen> {
  List laporan = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLaporan();
  }

  Future<void> getLaporan() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/lapor_air/get_laporan.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          laporan = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget itemStatus(String title, bool aktif) {
    return Row(
      children: [
        Icon(
          aktif ? Icons.check_circle : Icons.radio_button_unchecked,
          color: aktif ? Colors.green : Colors.grey,
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: TextStyle(
            color: aktif ? Colors.black : Colors.grey,
            fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget statusTimeline(String progres) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemStatus("Laporan Terkirim", true),

        const SizedBox(height: 10),

        itemStatus(
          "Terverifikasi",
          progres == "Terverifikasi" ||
              progres == "Diproses" ||
              progres == "Selesai",
        ),

        const SizedBox(height: 10),

        itemStatus("Diproses", progres == "Diproses" || progres == "Selesai"),

        const SizedBox(height: 10),

        itemStatus("Selesai", progres == "Selesai"),
      ],
    );
  }

  Color warnaStatus(String status) {
    switch (status) {
      case "Pending":
        return Colors.red;

      case "Diproses":
        return Colors.orange;

      case "Selesai":
        return Colors.green;

      case "Terverifikasi":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: const Text(
          "Status Laporan",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : laporan.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
              padding: const EdgeInsets.all(15),

              itemCount: laporan.length,

              itemBuilder: (context, index) {
                final item = laporan[index];
                String progres = item['status'] ?? "Pending";
                return Card(
                  margin: const EdgeInsets.only(bottom: 20),

                  elevation: 3,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: Image.network(
                            "http://127.0.0.1/lapor_air/uploads/${item['foto']}",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey.shade300,

                                child: const Center(
                                  child: Icon(Icons.image, size: 60),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          item['kategori'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text("Lokasi : ${item['lokasi']}"),

                        const SizedBox(height: 5),

                        Text("Tanggal : ${item['tanggal']}"),

                        const SizedBox(height: 10),

                        Text(item['deskripsi']),

                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: warnaStatus(progres).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            progres,
                            style: TextStyle(
                              color: warnaStatus(progres),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Divider(),

                        const SizedBox(height: 10),

                        const Text(
                          "Progress Laporan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),
                        statusTimeline(progres),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
