import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              }
          )
        ],
          backgroundColor: Colors.black,
          title:
              Text(_gifData['title'], style: TextStyle(color: Colors.white))),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(_gifData["images"]["fixed_height"]["url"])
                  ])),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   RaisedButton(
                     onPressed: (){
                       Share.share(_gifData["images"]["fixed_height"]["url"]);
                     },
                     color: Colors.white,
                     child: Column(
                       children: <Widget>[
                         Row(children: <Widget>[Icon(Icons.share,color: Colors.black, size: 20)]),
                         Row(children: <Widget>[Text("Compartilhar!")],)
                       ],
                     ),
                   )
                  ]))
        ],
      ),
    );
  }
}
