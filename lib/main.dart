import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var url = Uri.https(
    'api.hgbrasil.com', '/finance', {'?': 'format=json&key=97744f6f'});

void main() async {
  print(await buscaDados());
  runApp(MaterialApp(home: Home()));
}

Future<Map> buscaDados() async {
  var response = await http.get(url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  

  double dolar = 0;
  double euro = 0;


  void _clearAll() {
    realControl.text = "";
    dolarControl.text = "";
    euroControl.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    

    double real = double.parse(text);
    dolarControl.text = (real / dolar).toStringAsFixed(2);
    euroControl.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realControl.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControl.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    
    double euro = double.parse(text);
    realControl.text = (euro * this.euro).toStringAsFixed(2);
    dolarControl.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(" \$ Conversor \$ "),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: buscaDados(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando os Dados...",
                  style: TextStyle(color: Colors.red, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar os Dados...",
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.red),
                        construiMeusCamposDeTexto(
                            "Reais", "R\$  ", realControl, _realChanged),
                        Divider(),
                        construiMeusCamposDeTexto(
                            "Dólares", "US\$  ", dolarControl, _dolarChanged),
                        Divider(),
                        construiMeusCamposDeTexto(
                            "Euros", "EUR\€  ", euroControl, _euroChanged),
                            TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () => _clearAll(),
                          child: const Text('Limpar'),
                          ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget construiMeusCamposDeTexto(String label, String prefix,
    TextEditingController value, Function changed) {
  return TextField(
    controller: value,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.0)),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: changed as void Function(String)?,
    keyboardType: TextInputType.number,
  );
}


