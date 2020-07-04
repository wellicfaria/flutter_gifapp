import 'package:flutter/material.dart';


String _getUrlTopGifs(){
  return "https://api.giphy.com/v1/gifs/trending?api_key=L2r2lBQuhPgLrudyNhdYNr47NLcHo3ti&limit=25&rating=g";
}

String _getUrlGifsSearch(word_search,{limit=25,offset=0}){
  return "https://api.giphy.com/v1/gifs/search?api_key=L2r2lBQuhPgLrudyNhdYNr47NLcHo3ti&q=${word_search}&limit=${limit}&offset=${offset}&rating=g&lang=pt";
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Container()
    );
  }
}

