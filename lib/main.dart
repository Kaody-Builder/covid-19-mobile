import 'package:covid19_tracker/Pages/confirmation.dart';
import 'package:flutter/material.dart';
import 'Pages/confirmation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final colorP = Colors.teal;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Tracker',
      theme: ThemeData(
        primarySwatch: colorP,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Covid-19 Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  final colorP = Colors.teal;
  final numeroChamp = TextEditingController();


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset("assets/logo.png"),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "COVID-19 Tracker",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                textScaleFactor: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:5),
              child: Text(
                "Solution signalement de cas de Corona Virus à Madagascar",
                style: TextStyle(color: Colors.black54, fontSize: 10)
              ),
            )

          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: colorP,
          //     width: 1,
          //   ),
          //   borderRadius: BorderRadius.circular(12),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Entrer votre numéro de téléphone pour confirmer \nvotre implication dans vos signalements:",
                  maxLines: 2,
                  style: TextStyle(color: Colors.black54, fontSize: 13.5),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/22,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width/12),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.grey,
                //     width: 1,
                //   ),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: numeroChamp,
                  decoration: InputDecoration(
                    hintText: "Votre numéro de téléphone.",
                      //border: InputBorder.none
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical:5),
                width: MediaQuery.of(context).size.width*(5/6),
                decoration: BoxDecoration(
                  color: colorP,
                  border: Border.all(color: colorP, width: 1),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: FlatButton(
                  color: colorP,
                  onPressed: (){
                    traitement(numeroChamp.text);
                  },
                  child: Text("Signaler un cas", style: TextStyle(color: Colors.white)),
                ),
              )

            ],
          ),
        ),
      ),

     
    );
  }

  void traitement(String numeroGet){
    bool validate = false; 

    if (numeroGet.length == 10){
      RegExp regExp = new RegExp(r"^(03)[2349]{1}[0-9]{7}$");
      if (regExp.hasMatch(numeroGet)) validate = true;
    }
    else if (numeroGet.length == 13){
      RegExp regExp = new RegExp(r"^(.+2613)[2349]{1}[0-9]{7}$");
      if (regExp.hasMatch(numeroGet)) validate = true;
    }

    numeroGet = formNumero(numeroGet);
    if (validate){
      Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context){
          return ConfirmationPage(numero: numeroGet);
        }));
    } 
    else _alertErrorInput();
    
  }

  Future<void> _alertErrorInput() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: Text('Numéro incorrecte', style: TextStyle(color: Color(0xFFe74c3c))),
          
          actions: <Widget>[
            FlatButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String formNumero(String num){
    String numFinal = "";

    if (num.length == 13){
      List<String> numList = num.split('');
      int i = 0;
      
      for (String l in numList){
        numFinal += l;
        if (i == 3) numFinal += " ";
        else if (i == 5) numFinal += " ";
        else if (i == 7) numFinal += " ";
        else if (i == 10) numFinal += " ";
        i++;
      }
    }

    else if (num.length == 10){
      List<String> numList = num.split('');
      int i = 0;
      
      for (String l in numList){
        if (i == 3) numFinal += " ";
        else if (i == 5) numFinal += " ";
        else if (i == 8) numFinal += " ";
        i++;
        numFinal += l;
      }
    }
    

    return numFinal;
  }
}

