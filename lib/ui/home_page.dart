import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_gifs/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getUrlTopGifs() {
    return "https://api.giphy.com/v1/gifs/trending?api_key=L2r2lBQuhPgLrudyNhdYNr47NLcHo3ti&limit=25&rating=g";
  }

  String _getUrlGifsSearch(word_search, {limit = 11, offset = 0}) {
    return "https://api.giphy.com/v1/gifs/search?api_key=L2r2lBQuhPgLrudyNhdYNr47NLcHo3ti&q=${word_search}&limit=${limit}&offset=${offset}&rating=g&lang=pt";
  }

  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    String url;
    http.Response response;

    if (_search == null) {
      url = _getUrlTopGifs();
    } else {
      url = _getUrlGifsSearch(_search, offset: _offset);
    }

    response = await http.get(url);

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
          centerTitle: true),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onSubmitted: (texto) {
                  setState(() {
                    _search = texto;
                    if (_search.isEmpty) {
                      _search = null;
                    }
                    _offset = 0;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Pesquise aqui!",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.cyanAccent,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5)),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.error, color: Colors.red, size: 100),
                                Text("Erro ao carregar os Gifs.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white))
                              ]));
                    } else {
                      return _buildTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(AsyncSnapshot snapshot) {
    if (_search == null) {
      return snapshot.data["data"].length;
    }
    else {
      return snapshot.data["data"].length + 1;
    }
  }

  Widget _buildTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _getCount(snapshot),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                width: 300,
                fit: BoxFit.cover
              ),
              onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GifPage(snapshot.data["data"][index])
                    )
                );
              },
              onLongPress: (){
                  Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);

              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.add, size: 50, color: Colors.white),
                    Text('Carregar mais...', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20))
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _offset = 0;
    //_getGifs().then((map) => {print(map)});
  }
}
