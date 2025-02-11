class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;
  String? gambar;
  String? deskripsi;
  int? stok;
  String? gambarUrl;

  Produk({
    this.id,
    this.kodeProduk,
    this.namaProduk,
    this.hargaProduk,
    this.gambar,
    this.deskripsi,
    this.stok,
    this.gambarUrl,
  });

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: int.tryParse(obj['id']),
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: int.tryParse(obj['harga']),
      gambar: obj['gambar'],
      deskripsi: obj['deskripsi'],
      stok: int.tryParse(obj['stok']),
      gambarUrl: obj['gambar_url'],
    );
  }
}

