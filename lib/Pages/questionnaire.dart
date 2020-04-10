import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuestionnairePage extends StatefulWidget{

  @override
  _QuestionnairePage createState() => _QuestionnairePage();

}



class _QuestionnairePage extends State<QuestionnairePage>{

  double level = 0;
  bool listen = false;
  int radioval = 0;
  int nbrMs = 0;
  bool available;
  SpeechToText speech = SpeechToText();
  String _langueID = "en_US";
  String res = "";
  List<String> lastres = [];
  

  @override
  void initState() {
    super.initState();
    initialise();
    
  }

  Future<void> initialise() async{
    available = await speech.initialize(onStatus: statusListener, onError: errorListener);

  }

  void statusListener(String status){
    print(status);
    if (status == 'notListening'){
      print("nijanona");
      lastres.add(res);
      nbrMs++;
      listen = false;
      setState(() {
      });
    }
  }

  void errorListener(SpeechRecognitionError error){
    print(error.errorMsg);
    if (error.errorMsg == "error_busy")
      _errorMessage("Votre micro est déjà utiliser");
    else
      _errorMessage("");

  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Signalement'),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.6,
            child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:20),
                    child: Text(
                      "Décriver le signalement",
                      textScaleFactor: 2, 
                      style: TextStyle(fontFamily: "Arial", color: Color(0xFF464637), fontWeight: FontWeight.bold),
                    ) 
                  ), 
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Expliquer le cas de votre signalement",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top:15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/16),
                          alignment: Alignment.centerLeft,
                          child:  Column(
                            children: <Widget>[
                              Text("English"),
                              Radio(
                                groupValue: radioval,
                                value: 0,
                                onChanged: (int value){
                                  setState(() {
                                    radioval = value;
                                    _langueID = "en_US";
                                  });
                                  print(value);
                                },
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/16),
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: <Widget>[
                              Text("Français"),
                              Radio(
                                groupValue: radioval,
                                value: 1,
                                onChanged: (int value){
                                  setState(() {
                                    radioval = value;
                                    _langueID = "fr_FR";
                                    
                                  });
                                  print(value);
                                },
                              )
                            ],
                        )
                        )
                        
                        
                      
                      ],
                    )
                  ),

                  Container(
                    margin: EdgeInsets.only(top:10, bottom: 15, left: 10, right: 10),
                
                    child: FlatButton(
                      color: Colors.teal,
                      onPressed: (){
                        
                        if (!speech.isListening) startListening();
                        else speech.stop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text( !speech.isListening ? "Parler" : "Arreter", style: TextStyle(color: Colors.white)),
                          Icon( !speech.isListening ? Icons.play_arrow : Icons.stop, color: Colors.white,)
                        ],
                      ),
                    ),
                  ), 
                  Container( 
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Icon(Icons.mic, size: 32,)
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: speech.isListening
                          ? Text("En écoute")
                          : Text("Pas en écoute")
                  ),
                  Container( 
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Text(
                      nbrMs>0 ? "Vous avez fait part de $nbrMs enregistrement" : "",
                      style: TextStyle(color: Color(0xFF464637), fontWeight: FontWeight.bold)
                    )
                  )
                  
                ],
              )
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height/12,
          alignment: Alignment.center,
          color: Colors.teal,
          child: FlatButton(
            onPressed: (){
              print(lastres);
              terminate();
            },
            child: Text("Terminer", style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
    );
  }

  void startListening(){
    if (available){
      if (!speech.isListening){
        speech.listen(
          localeId: _langueID,
          onSoundLevelChange: soundChange,
          onResult: resultListener,
          listenFor: Duration(seconds: 60),
          cancelOnError: true
        );
        listen = true;
      }
    }
    else{
      _errorMessage("Nous avons pas pu se connecter avec votre micro.");
    }
  }

  void resultListener(SpeechRecognitionResult result){
      res = result.recognizedWords;
      print(res);
  }

  void soundChange(double level){
    setState(() {
      this.level = level;
    }); 
  }

  Future<void> _errorMessage(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: Text("Une erreur s'est produite", style: TextStyle(color: Color(0xFFe74c3c))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      
    });
  }

  Future<void> terminate() async{
    http.Response rep = await http.post(
      'http://192.168.43.122:5000/api/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List>{
        'data': lastres,
      }),
    );

    if (rep.statusCode == 201){
      print("ok");
    }
    else{
      _errorMessage("$rep.statusCode");
    }

  }

}

