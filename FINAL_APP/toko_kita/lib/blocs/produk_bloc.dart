import 'dart:convert';
import 'dart:io';
import '../helpers/api.dart';
import '../helpers/api_url.dart';
import '../model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];

    List<Produk> produks = [];

    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    print(produks);
    return produks;
    
  }

  // static Future addProduk({Produk? produk}) async {
  //   String apiUrl = ApiUrl.createProduk;
  //   var body = {
  //     "kode_produk": produk!.kodeProduk,
  //     "nama_produk": produk.namaProduk,
  //     "harga": produk.hargaProduk.toString(),
  //     "gambar": produk.gambar,
  //     "deskripsi":produk.deskripsi,
  //     "stok": produk.stok.toString()
  //   };
  //   var response = await Api().post(apiUrl, body);
  //   var jsonObj = json.decode(response.body);
  //   return jsonObj['status'];
  // }

  static Future addProduk({Produk? produk, File? image}) async {
    String apiUrl = ApiUrl.createProduk;
    var fields = {
      "kode_produk": produk!.kodeProduk!,
      "nama_produk": produk.namaProduk!,
      "harga": produk.hargaProduk.toString(),
      "deskripsi": produk.deskripsi ?? '',
      "stok": produk.stok.toString()
    };

    var response = await Api().postMultipart(apiUrl, fields, image);
    var jsonObj = json.decode(response.body);
    print(jsonObj);
    return jsonObj['status'];
  }

  // static Future<bool> updateProduk({required Produk produk, File? image}) async {
  //   String apiUrl = ApiUrl.updateProduk(produk.id!);
  //   var body = jsonEncode({
  //     "kode_produk": produk.kodeProduk,
  //     "nama_produk": produk.namaProduk,
  //     "harga": produk.hargaProduk.toString(),
  //     "gambar": produk.gambar,
  //     "deskripsi":produk.deskripsi,
  //     "stok": produk.stok.toString()
  //   });
  //   // ignore: avoid_print
  //   print("Body : $body");

  //   try {
  //     var response = await Api().post(apiUrl, body);

  //     if (response.statusCode == 200) {
  //       var jsonObj = json.decode(response.body);
  //       if (jsonObj['data'] != null && jsonObj['data'] is Map<String, dynamic>) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     } else {
  //       print("Failed to update product. Status code: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return false;
  //   }
  // }
  static Future updateProduk({required Produk produk, File? image}) async {
    String apiUrl = ApiUrl.updateProduk(produk.id!);
    
    var fields = {
      "kode_produk": produk.kodeProduk!,
      "nama_produk": produk.namaProduk!,
      "harga": produk.hargaProduk.toString(),
      "deskripsi": produk.deskripsi ?? '',
      "stok": produk.stok.toString()
    };
    

    var response = await Api().postMultipart(apiUrl, fields, image);
    var jsonObj = json.decode(response.body);
    print(jsonObj);
    return jsonObj['status'];
  }

  static Future<Produk?> getDetailProduk(int id) async {
    String apiUrl = ApiUrl.showProduk(id);

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    if (response.statusCode == 200) {
      if (jsonObj['status'] == true && jsonObj['data'] != null) {
        return Produk.fromJson(jsonObj['data']);
      } else {
        throw Exception('Produk tidak ditemukan');
      }
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }


  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
  return jsonObj['status'];
  }

  static Future<List<Produk>> searchProduks(String namaProduk) async {
    String apiUrl = ApiUrl.searchProduk(namaProduk);

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    if (jsonObj['status'] == true) {
      List<dynamic> listProduk = jsonObj['data'];

      List<Produk> produks = [];

      for (int i = 0; i < listProduk.length; i++) {
        produks.add(Produk.fromJson(listProduk[i]));
      }
      return produks;
    } else {
      return [];
    }
  }
}