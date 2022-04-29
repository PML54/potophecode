import 'dart:async';
import 'dart:convert';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potophe/briceclass.dart';

class AdminGame extends StatefulWidget {
  final String title;
  const AdminGame({Key? key, required this.title}) : super(key: key);

  @override
  State<AdminGame> createState() => _AdminGameState();
}

class _AdminGameState extends State<AdminGame> {
  bool _isVisible = false; //
  bool okGame = false; //  User Non déclaré
  DateTime currentDate = DateTime.now();
  double thisheight = 250;
  double thiswidth = 250;
  int counterFotos = 1;
  int fotoSelected = 0;
  int note = 0;

  List<Legendes> listLegendes = [];
  List<Legendes> listLegendesFoto = [];
  List<Legovote> listLegovote = [];
  List<Photoupload> listPhotoUpload = [];
  List<Photoupload> listUpload = [];
  List<Potos> listPotos = [];
  List<Votes> listVotes = [];
  String dateKey = "2025-08-21";
  String filouname = "";
  String filoutype = "";
  String ipv4name = "xx.xx.xx.xx";
  String labelLegende = "";
  String labelTitre = "";
  String mafoto = "assets/marin.jpeg";
  String potoName = "xxxx";
  var finalDate = "2022-4-4"; // Va me servir pour les  controles d'acces

//+++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Résultats',
        home: Scaffold(
          appBar: AppBar(actions: <Widget>[
            Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.redAccent,
                iconSize: 50.0,
                tooltip: 'Home',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
          body: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          mafoto,
                          fit: BoxFit.fill,
                          width: thiswidth,
                          height: thisheight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    getListViewReduce(),
                  ],
                ),
              ),
            ],
          ),

          bottomNavigationBar: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  iconSize: 45,
                  color: Colors.greenAccent,
                  tooltip: 'Refresh',
                  onPressed: () {
                    refresh();
                  },
                ),

                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: _decrementCounter,
                  tooltip: 'back',
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (counterFotos).toString() + ' / ' + fotoSelected.toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        backgroundColor: Colors.white,
                        color: Colors.black),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.arrow_forward, size: 20),
                ),

                //***
                IconButton(
                  icon: const Icon(Icons.people_alt_rounded),
                  iconSize: 25,
                  color: Colors.blue,
                  tooltip: 'Date du Game',
                  onPressed: () => _selectDate(context),
                ),

                Visibility(
                  visible: _isVisible,
                  child: BlinkText(
                    potoName,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        backgroundColor: Colors.red),
                    endColor: Colors.orange,
                  ),
                ),
              ]),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

//+++++++++++++++++++++
  Future getDataLegendes() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dblegendes.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listLegendes =
            datamysql.map((xJson) => Legendes.fromJson(xJson)).toList();
      });
    } else {}
  }

//+++++++++++++++++++++
  Future getDataUpload() async {
    // Lire les Images  Uploadés par les  Users
    Uri url = Uri.parse("https://www.paulbrode.com/php/readFOTOUPLOAD.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listUpload =
            datamysql.map((xJson) => Photoupload.fromJson(xJson)).toList();
        selectUnSet();
      });
    } else {}
  }

//**************************************************

  Expanded getListViewReduce() {
    var listView = ListView.builder(
        itemCount: listLegovote.length,
        itemBuilder: (context, index) {
          return ListTile(
              //leading: Icon(Icons.favorite),
              title: Text(
                listLegovote[index].potovote +
                    "-->" +
                    listLegovote[index].potoname +
                    " = " +
                    listLegovote[index].votepoints.toString() +
                    " :" +
                    listLegovote[index].legende,
                style: TextStyle(
                    fontSize: 13, fontFamily: 'Serif', color: Colors.green),
              ),
              dense: true,
              onTap: () {});
        });

    return (Expanded(child: listView));
  }

  //**************************************************

  Future getPotos() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dbpotorid.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPotos = datamysql.map((xJson) => Potos.fromJson(xJson)).toList();
      });
    } else {}
  }

  //+++++++++++++++++++++
  Future getVotes() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/readVOTES.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listVotes = datamysql.map((xJson) => Votes.fromJson(xJson)).toList();
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();

    getPotos(); // User
    getDataUpload(); // Rep2
    getDataLegendes();
    getVotes();
  }

  void majFotoActive() {
    labelLegende = "";
    filouname = listPhotoUpload[counterFotos].fotofilename;
    filoutype = listPhotoUpload[counterFotos].fototype;
    mafoto = 'upload/';
    mafoto = mafoto + filouname + '.' + filoutype.trim();
    selectLegendesFotoVote();
  }

void refresh() {
    getDataLegendes();
    getVotes();
  }

void selectLegendesFotoVote() {
    //  N°1 Creer Une Liste des  Legendes  concernant une Photo
    //  filouname) &&    filoutype   Pour une Photo
    // Pour une Photo Il y aura n  légendes max  si n joueurs
    // Pour 1 légende  il y a aura au plus n*(n-1)  Votes
    // L'idée est de constuire  une table contenant  les n*(n-1) votes avec legendes
    bool _found = false;
// Etape N°1  fabriquer  une table des légendes  pour ue photo donnée

    listLegendesFoto.clear();

    for (Legendes _thisObjet in listLegendes) {
      if ((_thisObjet.fotofilename == filouname) &&
          (_thisObjet.fototype == filoutype)) {
        listLegendesFoto.add(_thisObjet);
      }
    }

    listLegovote.clear();
    for (Legendes _thisLegende in listLegendesFoto) {
      int thisindex = _thisLegende.legendeid;
      //potoname actif
      // On va balayer les Votes
      _found = false;
      for (Votes _thisVote in listVotes) {
        if (_thisVote.legendeid == thisindex) {
          Legovote _Legovote = Legovote(
              fotofilename: _thisLegende.fotofilename,
              fototype: _thisLegende.fototype,
              potoname: _thisLegende.potoname,
              gamename: _thisLegende.gamename,
              legende: _thisLegende.legende,
              legendeid: _thisLegende.legendeid,
              potovote: _thisVote.potoname,
              votepoints: _thisVote.votepoints,
              ipv4: _thisVote.ipv4);
          // createVote(_thisVote.legendeid, potoName, 0, ipv4name);
          if (_thisLegende.potoname != _thisVote.potoname)
            listLegovote.add(_Legovote);
        } else {
          // Au suivant (Jacques Bre)

        }
      }
    }
  }

  //*******************************************************
  void selectUnSet() {
    // Selection de Base
    //listUpload contient tout
    // On prend une partie mais laqueelle ? A définit
    listPhotoUpload.clear();

    for (Photoupload _thisObjet in listUpload) {
      if (_thisObjet.fotoproprio == "INCONNU") {
        listPhotoUpload.add(_thisObjet);
      }
    }
    setState(() {
      fotoSelected = listPhotoUpload.length;
      counterFotos = 1;
      majFotoActive();
    });
  }

  //+++++++++++++++++++++
  void _decrementCounter() {
    setState(() {
      thiswidth = 400;
      thisheight = 400;
      counterFotos--;
      if (counterFotos < 1) counterFotos = 1;
      majFotoActive();
    });
  }

  //*******************************************************
  void _incrementCounter() {
    setState(() {
      thiswidth = 200;
      thisheight = 200;
      counterFotos++;
      fotoSelected = listPhotoUpload.length; // ???
      majFotoActive();
    });
  }

  //*******************************************************
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        finalDate = pickedDate.toString().substring(0, 10);
      });
    }
  }
}
