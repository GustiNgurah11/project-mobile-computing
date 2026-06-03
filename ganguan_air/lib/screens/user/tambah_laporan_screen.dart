import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TambahLaporanScreen extends StatefulWidget {
  const TambahLaporanScreen({super.key});

  @override
  State<TambahLaporanScreen> createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends State<TambahLaporanScreen> {
  final lokasiController = TextEditingController();

  final deskripsiController = TextEditingController();

  String selectedKategori = 'Pipa Bocor';
  bool isLoading = false;
  XFile? imageFile;

  final ImagePicker picker = ImagePicker();

  /// CAMERA
  Future<void> ambilDariCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        imageFile = image;
      });
    }
  }

  /// GALERI
  Future<void> ambilDariGaleri() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,

      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        imageFile = image;
      });
    }
  }

  /// SIMPAN LAPORAN
  Future<void> simpanLaporan() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// VALIDASI FOTO
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih foto terlebih dahulu')),
        );

        setState(() {
          isLoading = true;
        });
        return;
      }

      /// VALIDASI FORM
      if (lokasiController.text.isEmpty || deskripsiController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi dan deskripsi wajib diisi')),
        );
        return;
      }

      var uri = Uri.parse('http://127.0.0.1/lapor_air/tambah_laporan.php');

      var request = http.MultipartRequest('POST', uri);

      request.fields['kategori'] = selectedKategori;
      request.fields['lokasi'] = lokasiController.text;
      request.fields['deskripsi'] = deskripsiController.text;

      final bytes = await imageFile!.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes('foto', bytes, filename: imageFile!.name),
      );

      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      print("STATUS: ${response.statusCode}");
      print("RESPONSE: $responseData");

      print(responseData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dikirim')),
        );

        /// RESET FORM
        setState(() {
          imageFile = null;
          selectedKategori = 'Pipa Bocor';
        });

        lokasiController.clear();
        deskripsiController.clear();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal mengirim laporan')));
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
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

        title: const Text(
          'Buat Laporan',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
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
                  .map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  })
                  .toList(),

              onChanged: (value) {
                setState(() {
                  selectedKategori = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Lokasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: lokasiController,

              decoration: InputDecoration(
                hintText: 'Masukkan lokasi',

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: deskripsiController,

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

                        Text('Belum ada foto'),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),

                      child: Image.network(
                        imageFile!.path,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Gagal menampilkan foto'),
                          );
                        },
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ambilDariCamera,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: simpanLaporan,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                  'KIRIM LAPORAN',

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
    );
  }
}
