class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      code: json['code'],
      status: json['status'],
      token: json['data']['token'],
      userID: int.tryParse(json['data']['user']['id']),
      userEmail: json['data']['user']['email'],
    );
  }
}
