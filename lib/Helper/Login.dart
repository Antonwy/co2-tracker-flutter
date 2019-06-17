class Login {
  final String email;
  final String password;

  Login({this.email, this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;

    return map;
  }
}