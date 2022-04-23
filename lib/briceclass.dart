class Fototon {
  int fotoindex = 0;
  String fototitre = "";
  int fotocat = 0;
  int fotonum = 0;
  String fotolegende = "";
  Fototon({
    required this.fotoindex,
    required this.fototitre,
    required this.fotocat,
    required this.fotonum,
    required this.fotolegende,
  });
  factory Fototon.fromJson(Map<String, dynamic> json) {
    return Fototon(
      fotoindex: int.parse(json['FOTOINDEX']),
      fotocat: int.parse(json['FOTOCAT']),
      fotonum: int.parse(json['FOTONUM']),
      fototitre: json['FOTOTITRE'] as String,
      fotolegende: json['FOTOLEGENDE'] as String,
    );
  }
}  // Images strockées
class Photoupload {
  String fotofilename = "";
  String fototype = "";
  String fotocat = "";
  String fotoproprio = "";
  String fotolegende = "";

  Photoupload({
    required this.fotofilename,
    required this.fototype,
    required this.fotocat,
    required this.fotoproprio,
    required this.fotolegende,
  });

  factory Photoupload.fromJson(Map<String, dynamic> json) {
    return Photoupload(
      fotofilename: json['FOTOFILENAME'] as String,
      fototype: json['FOTOTYPE'] as String,
      fotocat: json['FOTOCAT'] as String,
      fotoproprio: json['FOTOPROPRIO'] as String,
      fotolegende: json['FOTOLEGENDE'] as String,
    );
  }
}  // Images Users
class Potos {
  String potoname = "";
  String potopwd = "";
  String potodesc = "";
  int potostatus = 0;
  String potolast = "";
  String ipv4 = "";

  Potos({
    required this.potoname,
    required this.potopwd,
    required this.potodesc,
    required this.potostatus,
    required this.potolast,
    required this.ipv4,
  });
  factory Potos.fromJson(Map<String, dynamic> json) {
    return Potos(
      potoname: json['POTONAME'] as String,
      potopwd: json['POTOPWD'] as String,
      potodesc: json['POTODESC'] as String,
      potostatus: int.parse(json['POTOSTATUS']),
      potolast: json['POTOLAST'] as String,
      ipv4: json['IPV4'] as String,
    );
  }
}   // Users références
class Legendes {
  // FOTOINDEX | POTONAME | GAMENAME | LEGENDE
  int fotoindex = 0;
  String potoname = "";
  String gamename = "";
  String legende = "";
  Legendes({
    required this.fotoindex,
    required this.potoname,
    required this.gamename,
    required this.legende,
  });
  factory Legendes.fromJson(Map<String, dynamic> json) {
    return Legendes(
      fotoindex: int.parse(json['FOTOINDEX']),
      potoname: json['POTONAME'] as String,
      gamename: json['GAMENAME'] as String,
      legende: json['LEGENDE'] as String,
    );
  }
}  // Legendes données
