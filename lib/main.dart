import "package:flutter/material.dart";

import "package:http/http.dart" as http;
import "dart:async";
import "dart:convert";

const API = "https://api.hgbrasil.com/finance?format=json?key=64b8d61e";

void main() async {
  runApp(MyApp());
}

Future<Map> getData() async {
  http.Response response = await http.get(API);
  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Convert Coint",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Convert Coin"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.amber, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados",
                      style: TextStyle(color: Colors.red[100], fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Container(color: Colors.green);
            }
          }),
    );
  }
}
