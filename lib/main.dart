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
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAllField() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  void _fieldEmpty(String text) {
    if (text.isEmpty) {
      _clearAllField();
      return;
    }
  }

  void _onChanged(String type, String text) {
    double value = double.parse(text);
    switch (type) {
      case 'real':
        _fieldEmpty(text);
        dolarController.text = (value / dolar).toStringAsFixed(2);
        euroController.text = (value / euro).toStringAsFixed(2);
        break;
      case 'euro':
        _fieldEmpty(text);
        realController.text = (value * this.dolar).toStringAsFixed(2);
        euroController.text = (value * this.dolar / euro).toStringAsFixed(2);
        break;
      case 'dolar':
        _fieldEmpty(text);
        realController.text = (value * this.euro).toStringAsFixed(2);
        dolarController.text = (value * this.euro / dolar).toStringAsFixed(2);
        break;
      default:
        break;
    }
  }

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
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildTextField('Reais', "R\$", realController,
                          (text) => _onChanged('real', text)),
                      Divider(),
                      buildTextField('Dóloar', "US\$", dolarController,
                          (text) => _onChanged('dolar', text)),
                      Divider(),
                      buildTextField('Euro', "€", euroController,
                          (text) => _onChanged('euro', text)),
                    ],
                  ),
                );
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChanged) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 18.0),
    onChanged: onChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
