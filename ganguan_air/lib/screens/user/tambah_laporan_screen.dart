import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TambahLaporanScreen extends StatefulWidget {
  final String userName;
  final String userEmail; // ← tambah ini

  const TambahLaporanScreen({
    super.key,
    required this.userName,
    required this.userEmail, // ← tambah ini
  });

  @override
  State<TambahLaporanScreen> createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends State<TambahLaporanScreen> {
  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();

  String nama = '';
  String alamat = '';
  String keterangan = '';
  String selectedKategori = 'Pipa Bocor';
  bool isLoading = false;
  XFile? imageFile;
  Uint8List? imageBytes;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nama = widget.userName;
    namaController.text = widget.userName;
  }

  Future<void> ambilDariCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageFile = image;
        imageBytes = bytes;
      });
    }
  }

  Future<void> ambilDariGaleri() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        imageFile = image;
        imageBytes = bytes;
      });
    }
  }

  Future simpanLaporan() async {
    try {
      setState(() => isLoading = true);

      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih foto terlebih dahulu')),
        );
        setState(() => isLoading = false);
        return;
      }

      if (nama.isEmpty || alamat.isEmpty || keterangan.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama, alamat, dan keterangan wajib diisi'),
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/lapor_air/tambah_laporan.php'),
      );

      request.fields['nama'] = nama;
      request.fields['alamat'] = alamat;
      request.fields['keterangan'] = keterangan;
      request.fields['email'] = widget.userEmail; // ← pakai userEmail

      final bytes = await imageFile!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('foto', bytes, filename: imageFile!.name),
      );

      var response = await request.send();
      var result = await response.stream.bytesToString();
      print(result);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan berhasil dikirim'),
            backgroundColor: Colors.green,
          ),
        );

        namaController.clear();
        lokasiController.clear();
        deskripsiController.clear();
        nama = '';
        alamat = '';
        keterangan = '';

        setState(() {
          imageFile = null;
          imageBytes = null;
          selectedKategori = 'Pipa Bocor';
          isLoading = false;
        });

        Navigator.pop(context);
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    lokasiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Buat Laporan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KATEGORI
            const Text(
              'Kategori Gangguan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: selectedKategori,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: ['Pipa Bocor', 'Air Mati', 'Air Keruh', 'Tekanan Rendah']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedKategori = value!);
              },
            ),

            const SizedBox(height: 20),

            // NAMA
            const Text(
              'Nama',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: namaController,
              onChanged: (value) => nama = value,
              decoration: InputDecoration(
                hintText: 'Masukkan nama',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LOKASI
            const Text(
              'Lokasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lokasiController,
              onChanged: (value) => alamat = value,
              decoration: InputDecoration(
                hintText: 'Masukkan lokasi',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DESKRIPSI
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deskripsiController,
              onChanged: (value) => keterangan = value,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Masukkan deskripsi laporan',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // FOTO
            const Text(
              'Foto Laporan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: imageFile == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Belum ada foto',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: imageBytes != null
                          ? Image.memory(
                              imageBytes!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const Center(child: Text('Gagal menampilkan foto')),
                    ),
            ),

            const SizedBox(height: 15),

            // TOMBOL FOTO
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ambilDariCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ambilDariGaleri,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.photo, color: Colors.white),
                    label: const Text(
                      'Galeri',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // TOMBOL KIRIM
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : simpanLaporan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'KIRIM LAPORAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
