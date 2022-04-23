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
      home: const MyHomePage(title: 'PH042202 '),
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
  int okGame = 0; //  pas connu

  bool _isVisible = false;

  String labelTitre = "";
  String labelLegende = "";
  List<Fototon> listObjets = [];
  List<Fototon> listObjetsCarton = [];

  List<Photoupload> listUpload = [];
  List<Photoupload> listPhotoUpload = [];
  List<Legendes> listLegendes = [];
  List<Potos> listPotos = [];

  List<int> mesCartons = [];
  int quelCarton = 54;
  int ordreCarton = 0;
  int okSave = 0; // activer si + ou +
  int counterObjets = 0;
  int objetsInCarton = 1;
  String ipv4name = "xx.xx.xx.xx";

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
    potoName = "Inconnu";
    okGame = 0;
    for (Potos _thisObjet in listPotos) {
      if (_thisObjet.potopwd == finalDate) {
        setState(() {
          potoName = _thisObjet.potoname;
          okGame = 1;
          _isVisible = true;
          updatePotos();
        });
      }
    }

    setState(() {});
  }

  //+++++++++++++++++++++
  void selectUnCarton() {
    // C'est le carton Actif --> quelCarton

    listObjetsCarton.clear();
    okSave = 0;
    for (Fototon _thisObjet in listObjets) {
      if (_thisObjet.fotocat == quelCarton) {
        listObjetsCarton.add(_thisObjet);
      }
    }

    setState(() {
      listObjetsCarton.sort((a, b) => a.fotoindex.compareTo(b.fotoindex));
      objetsInCarton = listObjetsCarton.length;
      counterObjets = 0;
      labelTitre = listObjetsCarton[counterObjets].fototitre;
      titreController.text = labelTitre;

      labelLegende = listObjetsCarton[counterObjets].fotolegende;
      legendeController.text = labelLegende;

      String fotocon = (counterObjets + 1).toString();

      if (counterObjets < 10) fotocon = 'red00' + fotocon;
      if (counterObjets > 99) fotocon = 'red' + fotocon;
      if ((counterObjets > 9) && (counterObjets < 100))
        fotocon = 'red0' + fotocon;
      mafoto = 'potophe/' + quelCarton.toString() + '/' + fotocon + '.png';
    });
  }

  //**************************************************
  Expanded getListViewReduce() {
    if (okGame == 0) return Expanded(child: Text('VISITEUR'));
    var listView = ListView.builder(
        itemCount: listLegendes.length,
        itemBuilder: (context, index) {
          return ListTile(
            //leading: Icon(Icons.favorite),
            title: Text(
              listLegendes[index].gamename +
                  " " +
                  listLegendes[index].potoname +
                  " " +
                  listLegendes[index].fotoindex.toString(),
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Serif', color: Colors.green),
            ),
            subtitle: Text(
              "à " + listLegendes[index].legende,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Serif', color: Colors.black),
            ),
            dense: true,
            onTap: () {},
          );
        });

    return Expanded(child: listView);
  }

  //+++++++++++++++++++++
  void _cartonApres() {
    setState(() {
      ordreCarton++;
      okSave = 0;
      if (ordreCarton >= mesCartons.length) {
        ordreCarton = 0;
      }
      quelCarton = mesCartons[ordreCarton];
      selectUnCarton();
    });
  }

  //+++++++++++++++++++++
  void _cartonAvant() {
    setState(() {
      okSave = 0;
      ordreCarton--;
      if (ordreCarton < 0) {
        ordreCarton = 0;
      }
      quelCarton = mesCartons[ordreCarton];
      selectUnCarton();
    });
  }

  //***********
  void updateData() async {
    // Mettre à Jour 2  Champs

    Uri url = Uri.parse("https://www.paulbrode.com/php/dbutile.php");
    var id = listObjetsCarton[counterObjets].fotoindex.toString();
    var titre = listObjetsCarton[counterObjets].fototitre;
    var legende = listObjetsCarton[counterObjets].fotolegende;
    var data = {"FOTOINDEX": id, "FOTOTITRE": titre, "FOTOLEGENDE": legende};
    var res = await http.post(url, body: data);
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
    // Mise à JOur d'une License
    //$sql = "INSERT INTO LEGENDES  (FOTOINDEX, POTONAME,GAMENAME, LEGENDE)
    Uri url = Uri.parse("https://www.paulbrode.com/php/dblegendecreate.php");
    var id = listObjetsCarton[counterObjets].fotoindex.toString();
    var legende = listObjetsCarton[counterObjets].fotolegende;
    var cegame = "gameboy";
    var monpoto = "DEDE";
    var data = {
      "FOTOINDEX": id,
      "POTONAME": monpoto,
      "GAMENAME": cegame,
      "LEGENDE": legende
    };
    var res = await http.post(url, body: data);
  }

  //+++++++++++++++++++++
  Future getDataFototek() async {
    Uri url = Uri.parse("https://www.paulbrode.com/php/dbfototek.php");
    //var data = {"dadate": dateSelected};
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        okSave = 0;
        listObjets = datamysql.map((xJson) => Fototon.fromJson(xJson)).toList();
        _getListCarton();
        ordreCarton = 0;
        quelCarton = 54; //New
        selectUnCarton();
      });
    } else {}
  }

  //+++++++++++++++++++++
  Future getDataUpload() async {
    // Lire les Images  Uploadés par les  Users
    Uri url = Uri.parse("https://www.paulbrode.com/php/dbfototek.php");

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        okSave = 0;
        listUpload =
            datamysql.map((xJson) => Photoupload.fromJson(xJson)).toList();
        _getListCarton();
        ordreCarton = 0;
        quelCarton = 54; //New
        selectUnCarton();
      });
    } else {}
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
        _getListCarton();
        ordreCarton = 0;
        quelCarton = 54; //New
        selectUnCarton();
      });
    } else {}
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();

    final ipv6 = await Ipify.ipv64();

    final ipv4json = await Ipify.ipv64(format: Format.JSON);

    ipv4name = ipv4;
    // The response type can be text, json or jsonp
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
  void _incrementCounter() {
    setState(() {
      okSave = 0;
      thiswidth = 200;
      thisheight = 200;

      counterObjets++;
      if (counterObjets >= objetsInCarton) counterObjets = 0;

      labelTitre = listObjetsCarton[counterObjets].fototitre;
      titreController.text = labelTitre;
      labelLegende = listObjetsCarton[counterObjets].fotolegende;
      legendeController.text = labelLegende;

      String fotocon = (counterObjets + 1).toString();
      if (counterObjets < 10) fotocon = 'red00' + fotocon;
      if (counterObjets > 99) fotocon = 'red' + fotocon;
      if ((counterObjets > 9) && (counterObjets < 100))
        fotocon = 'red0' + fotocon;
      mafoto = 'potophe/' + quelCarton.toString() + '/' + fotocon + '.png';
    });
  }

//+++++++++++++++++++++
  void _decrementCounter() {
    setState(() {
      okSave = 0;
      thiswidth = 200;
      thisheight = 200;

      counterObjets--;
      if (counterObjets < 0) counterObjets = 0;
      labelTitre = listObjetsCarton[counterObjets].fototitre;
      titreController.text = labelTitre;
      labelLegende = listObjetsCarton[counterObjets].fotolegende;
      legendeController.text = labelLegende;

      String fotocon = (counterObjets + 1).toString();
      if (counterObjets < 10) fotocon = 'red00' + fotocon;
      if (counterObjets > 99) fotocon = 'red' + fotocon;
      if ((counterObjets > 9) && (counterObjets < 100))
        fotocon = 'red0' + fotocon;
      mafoto = 'potophe/' + quelCarton.toString() + '/' + fotocon + '.png';
    });
  }

//++++++++++++++++++++++++
  void _getListCarton() {
    mesCartons.clear();
    for (Fototon _thisObjet in listObjets) {
      int thisCarton = _thisObjet.fotocat;
      int inside = 0;

      for (var element in mesCartons) {
        if (element == thisCarton) inside = 1;
      }
      if (inside == 0) mesCartons.add(thisCarton);
    }
    mesCartons.sort();
  }

//+++++++++++++++++++++
  @override
  void initState() {
    super.initState();
    titreController = TextEditingController();
    getDataFototek(); //Rep1
    getDataUpload(); // Rep2
    getDataLegendes();
    getPotos(); // User
    getIP();
  }

  //+++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    return MaterialApp(
        home: Scaffold(
      /* appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Row(
        children: [
          Expanded(
            child: Column(
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
                Slider(
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
                Slider(
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
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titreController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Titre",
                    ),
                    onChanged: (text) {
                      setState(() {
                        labelTitre = titreController.text;
                        listObjetsCarton[counterObjets].fototitre = labelTitre;
                      });
                    },
                  ),
                ),
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
                          listObjetsCarton[counterObjets].fotolegende =
                              labelLegende;
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
                (counterObjets + 1).toString() +
                    ' / ' +
                    objetsInCarton.toString(),
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
            IconButton(
              icon: const Icon(Icons.save_sharp),
              iconSize: 25,
              color: Colors.deepPurple,
              tooltip: 'save',
              onPressed: () => updateData(),
            ),
            IconButton(
              icon: const Icon(Icons.sanitizer_rounded),
              iconSize: 25,
              color: Colors.deepPurple,
              tooltip: 'save',
              onPressed: () => createLegende(),
            ),
            //***
            IconButton(
              icon: const Icon(Icons.calendar_today),
              iconSize: 25,
              color: Colors.blue,
              tooltip: 'Date du Game',
              onPressed: () => _selectDate(context),
            ),
            /* Visibility(
              visible: _isVisible,
              child:  Text(
                potoName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    backgroundColor: Colors.red,
                    color: Colors.black),
              ),
            ),*/
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
            //finaldate = order.toString().substring(0, 10);

            ///****
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
