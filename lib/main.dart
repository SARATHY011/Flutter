import 'dart:convert';

import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom_parsing.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:url_launcher/url_launcher.dart';


void main() async{
  
  runApp(url());
}

class url extends StatelessWidget {
  const url({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage>  {
  TextEditingController controller =TextEditingController();
  String toLaunch = 'https://google.com';
  launched2(){
    toLaunch=controller.text;

  }
  late Future<void> _launched;
  Future<void> _launchIn(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:

            TextField(
              autofocus:  false,
              controller: controller,
              textInputAction: TextInputAction.go,
              onSubmitted: (toLaunch)=>launched2(),
              decoration: InputDecoration(
                  hintText: "your Url goes here",
                  labelText: 'http://',
                  labelStyle: TextStyle(
                      color:Colors.yellowAccent
                  )
              ),
            ),
            actions:<Widget> [
              RaisedButton( child: Icon(Icons.search)
                ,elevation: 10,
                color: Colors.blueGrey,
                onPressed: () => setState(() {
                  _launched =_launchIn(toLaunch);
                }
                ),
              ),
            ]
        ),
     body: Center(
       child: Column(
  children: <Widget>[
    RaisedButton(
        elevation: 10,
        color: Colors.redAccent,
        splashColor: Colors.yellowAccent,
        child: Text('WEBVIEW'),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>webview()));
        },
    ),RaisedButton(
        elevation: 10,
        color: Colors.redAccent,
        splashColor: Colors.yellowAccent,
        child: Text('PraSe'),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>_htmlprase()));
        },
    ),
  ],
),
     )  ,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [BottomNavigationBarItem(icon: Icon(Icons.home),

              title: Text('Home')
          ),BottomNavigationBarItem(icon: Icon(Icons.group_work),

              title: Text('WebView')
          ),],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.eleven_mp),
          onPressed: null

        ),

      ),

    );
  }
}


const List<Key>keys=[
  Key("Network"),
  Key("Networkdialog")
];
class webview extends StatelessWidget {
  const webview({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: WebView(
          initialUrl:'https://en.wikipedia.org/wiki/Elon_Musk',
          javascriptMode: JavascriptMode.unrestricted,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          items: [BottomNavigationBarItem(icon: Icon(Icons.home),

              title: Text('Home')
          ),BottomNavigationBarItem(icon: Icon(Icons.download),
              title: Text('Download')
          ),],
        ),
        floatingActionButton:
        FloatingActionButton(
          key: keys[0],
          child:
          Icon(Icons.eleven_mp),
          onPressed: (){
            showDialog(context: context,
              builder: (_)=> NetworkGiffyDialog(
                key: keys[1],
                image: Image.network("https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQU2JRbbl3LBOm_an3eI5iplFhOoLESyBwUfmWDO49BS1EYuGUE",
                  fit: BoxFit.cover,),
                entryAnimation: EntryAnimation.TOP_LEFT   ,
                title: Text('Elon Musk'),
                description: Text('This Dialog box is Created '),
                onOkButtonPressed: (){},),

            );
          },)
    );
  }
}


class _htmlprase extends StatefulWidget {
  const _htmlprase({Key? key}) : super(key: key);

  @override
  _htmlpraseState createState() => _htmlpraseState();
}

class _htmlpraseState extends State<_htmlprase> {
 String urll = 'https://en.wikipedia.org/wiki/Elon_Musk';
  Future _getServiceHtmlData() async{

    return await http.get(Uri.parse(urll));
  }
  String data = "hello";
  late Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _getServiceHtmlData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getServiceHtmlData(),
          builder: (context, snapshot) {
            if(snapshot.hasData){

              return  SafeArea(child: Html(data: "HTML prases",
              )
              );


            }else{
              if(snapshot.connectionState==ConnectionState.waiting){
                return CircularProgressIndicator();
              }else{
                return Text('Error');
              }
            }
          }
      ),
    );
  }
}

