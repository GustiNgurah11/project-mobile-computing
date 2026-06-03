import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List laporan = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getLaporan();
  }

  Future<void> getLaporan() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/lapor_air/get_laporan.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          laporan = jsonDecode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      print(e);
    }
  }

  Color warnaStatus(String status) {
    switch (status) {
      case "Pending":
        return Colors.red;

      case "Diproses":
        return Colors.orange;

      case "Selesai":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Laporan"),
        backgroundColor: Colors.blue,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : laporan.isEmpty
          ? const Center(child: Text("Belum ada laporan"))
          : ListView.builder(
              itemCount: laporan.length,

              itemBuilder: (context, index) {
                var item = laporan[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warnaStatus(item['status'] ?? 'Pending'),
                      child: const Icon(
                        Icons.report,
                        color: Color.fromARGB(255, 18, 12, 12),
                      ),
                    ),

                    title: Text(item['kategori']),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['lokasi']),

                        Text(item['tanggal'] ?? ''),

                        const SizedBox(height: 5),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: warnaStatus(item['status'] ?? 'Pending'),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Status : ${item['status'] ?? 'Pending'}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 11, 7, 7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(item['kategori']),

                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lokasi : ${item['lokasi']}"),

                                const SizedBox(height: 10),

                                Text("Deskripsi : ${item['deskripsi']}"),

                                const SizedBox(height: 10),

                                Text(
                                  "Status : ${item['status'] ?? 'Pending'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Progress : ${item['progres_laporan'] ?? 'Laporan Terkirim'}",
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
