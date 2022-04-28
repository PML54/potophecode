import 'dart:async';
import 'dart:convert';

import 'package:blinking_text/blinking_text.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potophe/admingame.dart';
import 'package:potophe/briceclass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*A BuildContext is nothing else but a reference to the location of a Widget
    within the tree structure of all the Widgets which are built.*/
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'PH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PH0426 '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  //
  DateTime currentDate = DateTime.now();
  var finalDate = "2021-6-6"; // Va me servir pour les  controles d'acces
  TextEditingController legendeController = TextEditingController();
  List<Photoupload> listUpload = [];
  List<Photoupload> listPhotoUpload = [];
  List<Legendes> listLegendes = [];
  List<Legendes> listLegendesFoto = [];
  List<Potos> listPotos = [];
  List<Votes> listVotes = [];
  String mafoto = "assets/marin.jpeg";
  String potoName = "xxxx";
  double thiswidth = 400;
  double thisheight = 400;
  String filouname = "";
  String filoutype = "";
  int nbFotosSelected = 0;
  int counterFotos = 1;
  String ipv4name = "xx.xx.xx.xx";
  int note = 0;
  int potoId = 0;
  bool okUser = false; //  User Non déclaré
  bool _isVisible = false; //
  bool _isAdmin = false; //
  bool _isSavingCaption = false; // Indicateur Saving en Cours
  bool _isSavingVotes = false; // Indicateur Saving en Cours
  String labelTitre = "";
  String labelLegende = "";

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(50, 50),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    return MaterialApp(
        home: Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  mafoto,
                  fit: BoxFit.fill,
                  width: thiswidth,
                  height: thisheight,
                ),
                SizedBox(
                  width: thiswidth,
                  child: Slider(
                    label: 'Hauteur',
                    activeColor: Colors.orange,
                    divisions: 10,
                    min: 200,
                    max: 500,
                    value: thisheight,
                    onChanged: (double newValue) {
                      setState(() {
                        newValue = newValue.round() as double;
                        if (newValue != thisheight) thisheight = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: thiswidth,
                  child: Slider(
                    label: 'Largeur',
                    activeColor: Colors.blueAccent,
                    divisions: 10,
                    min: 200,
                    max: 500,
                    value: thiswidth,
                    onChanged: (double newValue) {
                      setState(() {
                        newValue = newValue.round() as double;
                        if (newValue != thiswidth) thiswidth = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Visibility(
                        visible: _isVisible,
                        child: IconButton(
                            icon: const Icon(Icons.save_sharp),
                            iconSize: 35,
                            color: Colors.blue,
                            tooltip: 'Save Caption',
                            onPressed: () {
                              setState(() {
                                _isSavingCaption = true;
                              });

                              // PAs de  Legende Vide et il faut un User déclaré
                              if (labelLegende.length > 0 && potoId > 0)
                                createLegende();
                              // On va gagner de la place et Sauver les votes
                              _isSavingVotes = true;
                              saveVotes();
                            })),
                    Visibility(
                      visible: _isSavingCaption,
                      child: Visibility(
                        // 2 fois invisibles
                        visible: _isVisible,
                        child: BlinkText(
                          " Saving Comm",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red,
                              backgroundColor: Colors.red),
                          endColor: Colors.orange,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isSavingVotes,
                      child: Visibility(
                        // 2 fois invisibles
                        visible: _isVisible,
                        child: BlinkText(
                          " Saving Notes",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red,
                              backgroundColor: Colors.red),
                          endColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: legendeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter your Caption",
                      ),
                      onChanged: (text) {
                        setState(() {
                          labelLegende = legendeController.text;
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                    visible: _isVisible,
                    child: IconButton(
                        icon: const Icon(Icons.save_sharp),
                        iconSize: 45,
                        color: Colors.red,
                        tooltip: 'Save  Notes',
                        onPressed: () {
                          // Controle
                          saveVotes();
                        })),
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
                icon: const Icon(Icons.arrow_back),
                iconSize: 25,
                color: Colors.blue,
                tooltip: 'decrement',
                onPressed: () {
                  _decrementCounter();
                  // refresh();
                }),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (counterFotos).toString() + ' / ' + nbFotosSelected.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    backgroundColor: Colors.white,
                    color: Colors.black),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 25,
                color: Colors.blue,
                tooltip: '+1',
                onPressed: () {
                  _incrementCounter();
                  // refresh();
                }),

            //***
            IconButton(
                icon: const Icon(Icons.people_alt_rounded),
                iconSize: 25,
                color: Colors.blue,
                tooltip: 'Date du Game',
                onPressed: () {
                  _selectDate(context);
                  // refresh();
                }),

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

            Visibility(
                visible: _isAdmin,
                child: IconButton(
                    icon: const Icon(Icons.agriculture_rounded),
                    iconSize: 25,
                    color: Colors.red,
                    tooltip: 'Regarder les Notes',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminGame(title: "Admin Game"),
                        ),
                      );
                    })),
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }

  int buildClePML(int n, int p, int q) {
    // n cest le nombre de records de la Table à la dernierer  Si il ya  20 joueurs
    // Index devra tenir copte de  ces 2 infos
    // resultats n * p +  q
    int res = n * p + q;
    return (res);
  }

  void createLegende() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dblegendecreate.php");
    int laclef = buildClePML(listLegendes.length, NBMAXPOTOS, potoId);
    // Je veux une clé  non comme Primary mais unique
    // Aussi comme on est en environnement Multiuser
    // Je prends le nombre d'enregistrement Multiplié par le Nombre max de  Joueurs + N° Ordre di Joueur
    var cegame = "FIRST"; // On  réglera cela <plustard>
    var filename = listPhotoUpload[counterFotos].fotofilename;
    var filetype = listPhotoUpload[counterFotos].fototype;
    var data = {
      "FOTOFILENAME": filename,
      "FOTOTYPE": filetype,
      "POTONAME": potoName,
      "GAMENAME": cegame,
      "LEGENDE": legendeController.text,
      "LEGENDEID": laclef.toString(),
    };
    var res = await http.post(url, body: data);
    // Il Faut relire
    getDataLegendes();
    setState(() {
      _isSavingCaption = false;
    });
  }

  void createVote(
      int _legendeid, String _potoname, int _points, String _ipv4) async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/createVOTE.php");
    var data = {
      "LEGENDEID": _legendeid.toString(),
      "POTONAME": _potoname,
      "VOTEPOINTS": _points.toString(),
      "IPV4": _ipv4,
    };
    var res = await http.post(url, body: data);

    // On relit derriere
    getVotes(); // Secure
  }

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

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    final ipv6 = await Ipify.ipv64();
    final ipv4json = await Ipify.ipv64(format: Format.JSON);
    ipv4name = ipv4;
  }

  Expanded getListViewReduce() {
    //listLegendesFoto
    if (!okUser) return Expanded(child: Text(''));
    var listView = ListView.builder(
        itemCount: listLegendesFoto.length,
        itemBuilder: (context, index) {
          return ListTile(
              //leading: Icon(Icons.favorite),
              title: Text(
                listLegendesFoto[index].legende,
                style: TextStyle(
                    fontSize: 17, fontFamily: 'Serif', color: Colors.green),
              ),
              subtitle: Text(
                "Moi " +
                    potoName +
                    ", je donne un " +
                    listLegendesFoto[index].internalVote.toString() +
                    "/10  " +
                    " au caption  de   " +
                    listLegendesFoto[index].potoname +
                    ".",
                style: TextStyle(
                    fontSize: 10, fontFamily: 'Serif', color: Colors.black),
              ),
              dense: true,
              onTap: () {
                setState(() {
                  // On connait Index de la Legendre
                  // Ou Storcker Les Notes
                  if (listLegendesFoto[index].potoname != potoName) {
                    listLegendesFoto[index].internalVote++;
                    if (listLegendesFoto[index].internalVote > 10) {
                      listLegendesFoto[index].internalVote = 0;
                    }
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  void getPotoname() {
    potoName = "xxxx";
    okUser = false;
    _isVisible = false;
    _isAdmin = false;
    for (Potos _thisObjet in listPotos) {
      if (_thisObjet.potopwd == finalDate) {
        setState(() {
          potoName = _thisObjet.potoname;
          potoId = _thisObjet.potoid;
          if (potoName == "PML") _isAdmin = true;
          okUser = true;
          _isVisible = true;
          updatePotos();
        });
      }
    }
  }

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

  Future getVotes() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/readVOTES.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listVotes = datamysql.map((xJson) => Votes.fromJson(xJson)).toList();
      });
    } else {
      print("Pb getVotes " + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    getDataUpload(); // Rep2
    getDataLegendes();
    getPotos(); // User
    getVotes();
    getIP();
    counterFotos = 1;
    //majFotoActive();
  }

  void majFotoActive() {
    // Initialise mafoto
    // Passage obligatoire  ; A surveiller
    // On change
    if (_isSavingCaption || _isSavingVotes) {
      print(" should never Happen");
    }
    _isSavingVotes = false;
    _isSavingCaption = false;
    labelLegende = "";
    legendeController.text = labelLegende;
    filouname = listPhotoUpload[counterFotos].fotofilename;
    filoutype = listPhotoUpload[counterFotos].fototype;
    mafoto = 'upload/'; //<PML TODO>
    mafoto = mafoto + filouname + '.' + filoutype.trim();
    selectLegendesFoto();
    // Regarder Si il y a commentaire pour lutilisateur actif
    labelLegende = "";
    for (Legendes _thisObjet in listLegendes) {
      if ((_thisObjet.fotofilename == filouname) &&
          (_thisObjet.fototype == filoutype) &&
          (_thisObjet.potoname == potoName)) {
        labelLegende = _thisObjet.legende;
      }
    }
    legendeController.text = labelLegende;
  }

  void refresh() {
    super.initState();
    setState(() {
      okUser = false; //  User Non déclaré
      _isVisible = false; //
      _isAdmin = false; //
      labelTitre = "";
      labelLegende = "";
      okUser = false; //  User Non déclaré
      _isVisible = false; //
      _isAdmin = false; //
      int okSave = 0; //
      String filouname = "";
      String filoutype = "";

      int counterFotos = 1;
      String ipv4name = "xx.xx.xx.xx";
      int note = 0;
      int potoId = 0;
      getDataUpload(); // Rep2
      getDataLegendes();
      getPotos(); // User
      getVotes();
      getIP();
    });
  }

  void saveVotes() {
    bool _found = false;
    //  Maintenat on Va verifier si il existe des  votes de du poto actif
    //  sur ces légendes
    // Je vais les rlire

    // Une relecture
    getVotes();

    print(" Entree Save Votes" + listLegendesFoto.length.toString());
    for (Legendes _thisLegende in listLegendesFoto) {
      int _thisIndex = _thisLegende.legendeid;

      for (Votes _thisVote in listVotes) {
        _found = false;

        if ((_thisVote.legendeid == _thisIndex) &&
            _thisLegende.potoname != potoName) {
          // Mettre  à Jour il existe
          _thisVote.votepoints = _thisLegende.internalVote;
          _found = true;

          updateVote(_thisVote.legendeid, potoName, _thisVote.votepoints);
        } else {
          // Au suivant ( Jacques Brel)

        }
      }
    }
    _isSavingVotes = true;
  }

  void selectLegendesFoto() {
    //  Creer Une Liste des  Legendes  concernat une Photo
    if (!okUser) return; // User Non  référencé
    bool _found = false;
    listLegendesFoto.clear();
    for (Legendes _thisObjet in listLegendes) {
      if ((_thisObjet.fotofilename == filouname) &&
          (_thisObjet.fototype == filoutype)) {
        if ((_thisObjet.potoname != potoName)) listLegendesFoto.add(_thisObjet);
      }
    }

    //  Maintenant  verifieons si il existe des  votes du poto actif
    //  sur ces légendes
    // Je vais les rlire
    for (Legendes _thisLegende in listLegendesFoto) {
      int thisindex = _thisLegende.legendeid;
      //potoname actif
      // On va balayer les Votes
      _found = false;
      for (Votes _thisVote in listVotes) {
        _found = false;
        if ((_thisVote.legendeid == thisindex) &&
            (_thisVote.potoname == potoName)) {
          // Mettre  à Jour il existe
          _thisLegende.internalVote = _thisVote.votepoints;
          _found = true;
          // createVote(_thisVote.legendeid, potoName, 0, ipv4name);
        } else {
          //Il faut le creer avant de le Mettre à Jour

        }
      }

      if (!_found) {
        if (potoName != _thisLegende.potoname) {
          createVote(thisindex, potoName, 0, ipv4name);
        }
      }
    }
  }

  void selectUnSet() {
    //listUpload contient tout
    // On prend une partie mais laqueelle ? A définit
    listPhotoUpload.clear();

    for (Photoupload _thisObjet in listUpload) {
      if (_thisObjet.fotoproprio == "INCONNU") {
        listPhotoUpload.add(_thisObjet);
      }
    }
    setState(() {
      nbFotosSelected = listPhotoUpload.length;
      counterFotos = 1;
      majFotoActive();
    });
  }

  void updatePotos() async {
    // Mettre à Jour 2  Champs
    //dbUpdatePotos.php
    //DateTime.now().toString()
    String lastDate = DateTime.now().toString().substring(0, 19);
    Uri url = Uri.parse("https://www.paulbrode.com/php/dbUpdatePotos.php");
    var data = {
      "POTONAME": potoName,
      "POTOSTATUS": "1",
      "POTOLAST": lastDate,
      "IPV4": ipv4name
    };
    var res = await http.post(url, body: data);
  }

  void updateVote(int _legendeid, String _potoname, int _points) async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/updateVOTE.php");
    var data = {
      "LEGENDEID": _legendeid.toString(),
      "POTONAME": _potoname,
      "VOTEPOINTS": _points.toString(),
    };
    var res = await http.post(url, body: data);

    // Il Faut relire
    // getDataLegendes();
  }

  void _decrementCounter() {
    setState(() {
      print("Decrement");
      thiswidth = 400;
      thisheight = 400;
      counterFotos--;
      if (counterFotos < 1) counterFotos = 1;
      majFotoActive();
    });
  }

  void _incrementCounter() {
    setState(() {
      print("Increment");
      thiswidth = 400;
      thisheight = 400;
      counterFotos++;
      majFotoActive();
    });
  }

  @override
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
        getPotoname();
      });
    }
  }
}
