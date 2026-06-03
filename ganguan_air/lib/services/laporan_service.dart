import 'dart:convert';

import 'package:http/http.dart'
    as http;

import '../config/api.dart';

class LaporanService {

  /// TAMBAH LAPORAN
  static Future tambahLaporan(

    String nama,
    String alamat,
    String keluhan,

  ) async {

    var url = Uri.parse(

      Api.baseUrl +
      "laporan/tambah.php",
    );

    var response = await http.post(

      url,

      body: {

        "nama": nama,
        "alamat": alamat,
        "keluhan": keluhan,
      },
    );

    return jsonDecode(
      response.body,
    );
  }

  /// GET LAPORAN
  static Future getLaporan() async {

    var url = Uri.parse(

      Api.baseUrl +
      "laporan/get_laporan.php",
    );

    var response =
        await http.get(url);

    return jsonDecode(
      response.body,
    );
  }
}