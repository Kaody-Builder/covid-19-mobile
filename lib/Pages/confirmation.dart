import 'package:flutter/material.dart';
import 'questionnaire.dart';


final colorP = Colors.teal; 

class ConfirmationPage extends StatefulWidget{

  final String numero;

  ConfirmationPage({Key key, this.numero}) : super(key: key);

  @override 
  _ConfirmationPage createState() => _ConfirmationPage();
}


class _ConfirmationPage extends State<ConfirmationPage>{

  int nbrMs = 0;
  String nombreMessage = "", sufval = "";
  @override 
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: AppBar(
        title: Text("Confirmation Page"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width  * (11/12),
          child: Card(
            elevation: 3,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Identity confirmation",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 26)
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "A $nombreMessage Confirmation code was sent to your telephone.",
                  style: TextStyle(color: Colors.black54),  
                )
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  widget.numero,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/20,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width/12),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     color: Colors.grey,
                //     width: 1,
                //   ),
                //   borderRadius: BorderRadius.circular(12),
              
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Enter confirmation code",
                      //border: InputBorder.none
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical:5),
                width: MediaQuery.of(context).size.width*(5/6),
                // decoration: BoxDecoration(
                //   color: colorP,
                //   border: Border.all(color: colorP, width: 1),
                //   borderRadius: BorderRadius.circular(6)
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*(5/18),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   border: Border.all(width: 1),
                      //   borderRadius: BorderRadius.circular(6)
                      // ),
                      margin: EdgeInsets.only(right: 15),
                      
                      child: FlatButton(
                        color: Colors.black12,
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel", style: TextStyle(color: Colors.black54)),
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*(5/18),
                      // decoration: BoxDecoration(
                      //   color: colorP,
                      //   border: Border.all(color: colorP, width: 1),
                      //   borderRadius: BorderRadius.circular(6)
                      // ),
                      margin: EdgeInsets.only(left: 15),
                      child: FlatButton(
                        color: colorP,
                        onPressed: (){
                          _choixSuite();
                        },
                        child: Text("Continue", style: TextStyle(color: Colors.white)),
                      )
                    )
                  ],
                )
                
              ),
               Container(
                 margin: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: FlatButton(
                  color: Colors.white,
                  onPressed: (){
                    _codenonreceive();
                  },
                  child: Text(
                    "I did not get a code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorP),
                  )
                )
              )
            ],
          ),
          )
        )
      )
    );

  }

  void nombreMessageChange(){
    if (nbrMs > 1) {
      sufval = nbrMs == 2 ? "nd" : "th";
      nombreMessage = nbrMs.toString() + sufval ;
    }
    else nombreMessage = "";
  }

  Future<void> _codenonreceive() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: Text('Confirmation Code', style: TextStyle(color: Color(0xFF464637))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please wait few minutes"),
                Text("You can resend new code.")
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Resend'),
              onPressed: () {
                setState(() {
                  nbrMs++;
                  nombreMessageChange();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _choixSuite() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose an action."),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings_voice),
              title: Text("Record voice"),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return QuestionnairePage();
                  })
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.sms),
              title: Text("Fill the form"),
              onTap: (){},
            )
          ],
          
        );
      },
    );
  }
}
