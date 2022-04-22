class Cartonton {
  int fotoindex = 0;
  String fototitre = "";
  int fotocat = 0;
  int fotonum = 0;
  String fotolegende = "";

  Cartonton({
    required this.fotoindex,
    required this.fototitre,
    required this.fotocat,
    required this.fotonum,
    required this.fotolegende,
  });

  factory Cartonton.fromJson(Map<String, dynamic> json) {
    return Cartonton(
      fotoindex: int.parse(json['FOTOINDEX']),
      fotocat: int.parse(json['FOTOCAT']),
      fotonum: int.parse(json['FOTONUM']),
      fototitre: json['FOTOTITRE'] as String,
      fotolegende: json['FOTOLEGENDE'] as String,
    );
  }
}

// FOTOFILENAME | FOTOTYPE | FOTOLEGENDE  | FOTOPROPRIO | FOTOCAT |
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
}

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
}

class Tables {
  int quelCarton;
  String quiGere;
  String quelTitre;
  int quelTable;

  Tables(
    this.quelCarton,
    this.quiGere,
    this.quelTitre,
    this.quelTable,
  );
}

final listTables = [
  Tables(1, "PML", "Catalogue Peche ", 1),
  Tables(2, "PML", "Dubout Celine", 1),
];
