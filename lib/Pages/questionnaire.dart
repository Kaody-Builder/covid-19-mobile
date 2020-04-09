import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuestionnairePage extends StatefulWidget{

  @override
  _QuestionnairePage createState() => _QuestionnairePage();

}

class _QuestionnairePage extends State<QuestionnairePage>{

  stt.SpeechToText speech = stt.SpeechToText();
  String res = "";
  double level = 0; 
  String lastres = "";
  String _langueID = "fr_FR";
  bool islisten = false;
  bool available;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> initialise() async{
    available = await speech.initialize( onStatus: statusListener, onError: errorListener );
  }

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Description du Signalement"),
      ),
      body: Center(
        child: SingleChildScrollView(child: Text(lastres),)
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height/12,
        color: Colors.teal,
        alignment: Alignment.center,
        /*
        child: Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
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
              child: IconButton(
                icon: Icon(Icons.mic),
                onPressed: (){
                  print("click");
                  if (islisten)
                    stopListen();
                  else 
                    startListen();
                },
              )
            ),
          ),
        )*/
        
         
      ),
    );
  }

  void statusListener(String status){
    print("test");
    print("-- $status --");
    if (status == "notListening"){
      setState(() {
        lastres = res;
      });
    
    }
  }

  void errorListener(SpeechRecognitionError error){
    print(error.errorMsg);
  }

  Future<void> stopListen() async{ 
    speech.stop();
    islisten = false;
  }

  void startListen(){
    print("ere");
    islisten = true;
    speech.listen(
      partialResults: true,
      localeId: _langueID,
      onSoundLevelChange: soundChangeLevel,
      onResult: resultListener);
    setState(() {
      
    });
  }

  void resultListener(SpeechRecognitionResult result){
    print(result.recognizedWords);
    print(result.finalResult);
    res = result.recognizedWords;
    res += "\n";
  }

  void soundChangeLevel(double lev){
    setState(() {
      print("**** $lev");
      level = lev;
    });
    
  }
}
/*
class _QuestionnairePage extends State<QuestionnairePage>{

  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          Center(
            child: Text(
              'Speech recognition available',
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Initialize'),
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                    FlatButton(
                      child: Text('Stress Test'),
                      onPressed: stressTest,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Start'),
                      onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                    ),
                    FlatButton(
                      child: Text('Stop'),
                      onPressed: speech.isListening ? stopListening : null,
                    ),
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: speech.isListening ? cancelListening : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Recognized Words',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
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
                            child: IconButton(icon: Icon(Icons.mic)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Error Status',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Center(
                  child: Text(lastError),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ]),
      );
    
  }

  void stressTest() {
    if (_stressTest) {
      return;
    }
    _stressLoops = 0;
    _stressTest = true;
    print("Starting stress test...");
    startListening();
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 50),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

}
*/