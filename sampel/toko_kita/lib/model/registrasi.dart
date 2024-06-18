class Registrasi {
  int? code;
  bool? status;
  String? data;

  Registrasi({this.code, this.data, this.status});

  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    return Registrasi(
      code: obj['code'],
      status: obj['status'],
      data: obj['data'],
    );
  }
}