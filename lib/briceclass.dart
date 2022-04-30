import 'dart:core';

const int NBMAXPOTOS = 25;

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
} // Images Users

class Potos {
  int potoid = 0;
  String potoname = "";
  String potopwd = "";
  String potodesc = "";
  int potostatus = 0;
  String potolast = "";
  String ipv4 = "";

  Potos({
    required this.potoid,
    required this.potoname,
    required this.potopwd,
    required this.potodesc,
    required this.potostatus,
    required this.potolast,
    required this.ipv4,
  });

  factory Potos.fromJson(Map<String, dynamic> json) {
    return Potos(
      potoid: int.parse(json['POTOID']),
      potoname: json['POTONAME'] as String,
      potopwd: json['POTOPWD'] as String,
      potodesc: json['POTODESC'] as String,
      potostatus: int.parse(json['POTOSTATUS']),
      potolast: json['POTOLAST'] as String,
      ipv4: json['IPV4'] as String,
    );
  }
} // Users références

/*
FOTOFILENAME | varchar(50) | YES  | MUL | NULL    |       |
FOTOTYPE     | varchar(5)  | YES  |     | NULL    |       |
POTONAME     | varchar(10) | YES  |     | NULL    |       |
GAMENAME     | varchar(10) | YES  |     | NULL    |       |
LEGENDE      | text        | YES  |     | NULL    |       |
*/

class Legendes {
  String fotofilename = "";
  String fototype = "";
  String potoname = "";
  String gamename = "";
  String legende = "";
  int legendeid = 0;
  int internalVote=0; // bidouillage

  Legendes({
    required this.fotofilename,
    required this.fototype,
    required this.potoname,
    required this.gamename,
    required this.legende,
    required this.legendeid,
  });

  factory Legendes.fromJson(Map<String, dynamic> json) {
    return Legendes(
      fotofilename: json['FOTOFILENAME'] as String,
      fototype: json['FOTOTYPE'] as String,
      potoname: json['POTONAME'] as String,
      gamename: json['GAMENAME'] as String,
      legende: json['LEGENDE'] as String,
      legendeid: int.parse(json['LEGENDEID']),
    );
  }
} // Legendes

//
class Votes {
  /*
LEGENDEID  | int         | NO   | PRI | NULL    |       |
POTONAME   | varchar(10) | NO   | PRI | NULL    |       |
VOTEPOINTS | int         | YES  |     | NULL    |       |
IPV4       | varchar(30) | YES  |     | NULL    |
*/
  int legendeid = 0;
  String potovotant = "votant";
  int votepoints = 0;
  String ipv4 = "xx.xx.xx.xx";
  String potoname = "candidat";
  Votes({
    required this.legendeid,
    required this.potovotant,
    required this.votepoints,
    required this.ipv4,
    required this.potoname,
  });

  factory Votes.fromJson(Map<String, dynamic> json) {
    return Votes(
      legendeid: int.parse(json['LEGENDEID']),
      potovotant: json['POTOVOTANT'] as String,
      votepoints: int.parse(json['VOTEPOINTS']),
      ipv4: json['IPV4'] as String,
      potoname: json['POTONAME'] as String,
    );
  }
} //  Mixage  de Légende et de Vote
class Legovote {
  String fotofilename = "";
  String fototype = "";
  String potoname = ""; // Poto qui a créé la légende
  String gamename = "";
  String legende = "";
  int legendeid = 0;
  String potovote = ""; //Poto qui a  noté  la légende
  int votepoints = 0;
  String ipv4 = "xx.xx.xx.xx";

  Legovote({
    required this.fotofilename,
    required this.fototype,
    required this.potoname,
    required this.gamename,
    required this.legende,
    required this.legendeid,
    required this.potovote,
    required this.votepoints,
    required this.ipv4,
  });
}
class Logovofo {
  String fotofilename = "";
  String fototype = "";
  String potoname = ""; //   pur qui on vote   I
  String gamename = "";
  String legende = "";
  int legendeid = 0;  // Key
  String potovotant = "votant";
  int votepoints = 0;



  Logovofo({
    required this.fotofilename,
    required this.fototype,
    required this.potoname,
    required this.gamename,
    required this.legende,
    required this.legendeid,
    required this.potovotant,
    required this.votepoints,


  });


} // Legendes
