import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:blinking_text/blinking_text.dart';
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
      title: 'PH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PH0423 '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime currentDate = DateTime.now();
  var finalDate = "2021-6-6"; // Va me servir pour les  controles d'acces
  String dateKey = "2025-08-21";
  TextEditingController titreController = TextEditingController();
  TextEditingController legendeController = TextEditingController();

  String mafoto = "assets/marin.jpeg";
  String potoName = "Blero";
  double thiswidth = 250;
  double thisheight = 250;

  bool okGame = false; //  User Non déclaré
  bool _isVisible = false; //

  String labelTitre = "";
  String labelLegende = "";
  List<Photoupload> listUpload = [];
  List<Photoupload> listPhotoUpload = [];
  List<Legendes> listLegendes = [];
  List<Legendes> listLegendesFoto = [];
  List<Potos> listPotos = [];
  List<Votes> listVotes = [];

  int okSave = 0; //
  String filouname = "";
  String filoutype = "";
  int fotoSelected = 0;
  int counterFotos = 1;
  String ipv4name = "xx.xx.xx.xx";
  int note = 0;
  int potoId = 0;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(50, 50),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Future<void> _selectDate(BuildContext context) async {
    //getPotos();
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

  void getPotoname() {
    potoName = "Boloss";
    okGame = false;
    _isVisible = false;
    for (Potos _thisObjet in listPotos) {
      if (_thisObjet.potopwd == finalDate) {
        setState(() {
          potoName = _thisObjet.potoname;
          potoId = _thisObjet.potoid;
          okGame = true;
          _isVisible = true;
          updatePotos();
        });
      }
    }

    setState(() {});
  }

  void selectLegendesFoto() {
    //  CreerUne Liste des  Legendes  concernat une Photo

    if (!okGame) return; // Pas connu
    bool _found = false;
    listLegendesFoto.clear();

    for (Legendes _thisObjet in listLegendes) {
      if ((_thisObjet.fotofilename == filouname) &&
          (_thisObjet.fotofilename == filouname)) {
        listLegendesFoto.add(_thisObjet);
      }
    }

    //  Maintenat on Va verifier si il existe des  votes de du poto actif
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
        createVote(thisindex, potoName, 0, ipv4name);
      }
    }
  }

  void selectUnSet() {
    //listUpload contient tout

    // On prend une partie mais laqueelle ? A définit
    listPhotoUpload.clear();
    okSave = 0;
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

  //**************************************************
  Expanded getListViewReduce() {
    //listLegendesFoto
    if (!okGame) return Expanded(child: Text('Boloss'));
    var listView = ListView.builder(
        itemCount: listLegendesFoto.length,
        itemBuilder: (context, index) {
          return ListTile(
              //leading: Icon(Icons.favorite),
              title: Text(
                listLegendesFoto[index].potoname +
                    "-->" +
                    listLegendesFoto[index].internalVote.toString() +
                    " :" +
                    listLegendesFoto[index].legende,
                style: TextStyle(
                    fontSize: 13, fontFamily: 'Serif', color: Colors.green),
              ),
              dense: true,
              onTap: () {
                setState(() {
                  // On connait Index de la Legendre
                  // Ou Storcker Les Notes

                  listLegendesFoto[index].internalVote++;
                  if (listLegendesFoto[index].internalVote > 10) {
                    listLegendesFoto[index].internalVote = 0;
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  //***********
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

  //***********
  void createLegende() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dblegendecreate.php");
    int laclef = buildClePML(listLegendes.length, NBMAXPOTOS, potoId);
    var cegame = "FIRST";
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
  }

//***********
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
    print("+++++A VOT2");
    // Il Faut relire
    // getDataLegendes();
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

  void refresh() {
    getDataLegendes();
    getVotes();
  }

//+++++++++++++++++++++
  Future getDataLegendes() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dblegendes.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        okSave = 0;
        listLegendes =
            datamysql.map((xJson) => Legendes.fromJson(xJson)).toList();
      });
    } else {}
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    final ipv6 = await Ipify.ipv64();
    final ipv4json = await Ipify.ipv64(format: Format.JSON);
    ipv4name = ipv4;
  }

  int buildClePML(int n, int p, int q) {
    // n cest le nombre de records de la Table à la dernierer  Si il ya  20 joueurs
    // Index devra tenir copte de  ces 2 infos
    // resultats n * p +  q
    int res = n * p + q;
    return (res);
  }

//+++++++++++++++++++++
  Future getPotos() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dbpotorid.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        okSave = 0;
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

  void majFotoActive() {
    // Initialise mafoto

    labelLegende = "";
    legendeController.text = labelLegende;
    filouname = listPhotoUpload[counterFotos].fotofilename;
    filoutype = listPhotoUpload[counterFotos].fototype;
    mafoto = 'upload/';
    mafoto = mafoto + filouname + '.' + filoutype.trim();
    selectLegendesFoto();
  }

//+++++++++++++++++++++
  void _incrementCounter() {
    setState(() {
      okSave = 0;
      thiswidth = 200;
      thisheight = 200;
      counterFotos++;
      fotoSelected = listPhotoUpload.length; // ???
      majFotoActive();
    });
  }

//+++++++++++++++++++++
  void _decrementCounter() {
    setState(() {
      okSave = 0;
      thiswidth = 400;
      thisheight = 400;
      counterFotos--;
      if (counterFotos < 0) counterFotos = 0;
      majFotoActive();
    });
  }

//+++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    titreController = TextEditingController();
    getDataUpload(); // Rep2
    getDataLegendes();
    getPotos(); // User
    getVotes();
    getIP();
    print("------->" + listLegendes.length.toString());
  }

  //+++++++++++++++++++++
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
                SizedBox(
                  width: thiswidth,
                  child: Slider(
                    label: 'Hauteur',
                    activeColor: Colors.orange,
                    divisions: 10,
                    min: 200,
                    max: 600,
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
                    max: 600,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: legendeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Legende",
                      ),
                      onChanged: (text) {
                        setState(() {
                          labelLegende = legendeController.text;
                        });
                      },
                    ),
                  ),
                ),
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
              tooltip: 'dateSelected',
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

            Visibility(
                visible: _isVisible,
                child: IconButton(
                    icon: const Icon(Icons.save_sharp),
                    iconSize: 35,
                    color: Colors.deepPurple,
                    tooltip: 'save',
                    onPressed: () {
                      // PAs de  Legende Vide et il faut un User déclaré
                      if (labelLegende.length > 0 && potoId > 0)
                        createLegende();
                    })),
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
            Visibility(
                visible: _isVisible,
                child: IconButton(
                    icon: const Icon(Icons.calculate_outlined),
                    iconSize: 55,
                    color: Colors.red,
                    tooltip: 'save',
                    onPressed: () {
                      // PAs de  Legende Vide et il faut un User déclaré
                      if (labelLegende.length > 0 && potoId > 0)
                        createLegende();
                    })),

            ///****
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
