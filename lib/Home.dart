import 'dart:convert';

import 'package:conversormoeda/util/TextFieldCustom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

//const request = "https://api.hgbrasil.com/finance?key=76931655";


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar;
  double euro;
  TextEditingController _euroController = TextEditingController();
  TextEditingController _dolarController = TextEditingController();
  TextEditingController _reaisController = TextEditingController();

  Future<Map> getData()async{
    String url = "https://api.hgbrasil.com/finance?key=76931655";
    http.Response response = await http.get(url);
    Map<String,dynamic> dados = json.decode(response.body);
    return dados;
  }

  _clearAll(){
    _reaisController.text = "";
    _dolarController.text = "";
    _euroController.text = "";
  }

  _realChanged(String texto){
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double reais = double.parse(texto);
    _dolarController.text = (reais / dolar).toStringAsFixed(2);
    _euroController.text = (reais / euro).toStringAsFixed(2);

  }
  _dolarChanged(String texto){
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(texto);
    _reaisController.text = (dolar * this.dolar).toStringAsFixed(2);
    _euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

  }
  _euroChanged(String texto){
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(texto);
    _reaisController.text = (euro * this.euro).toStringAsFixed(2);
    _dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 150.0,
                      ),
                    TextFieldCustom(
                        _reaisController,
                        _realChanged,
                        "Reais",
                        "R"),
                      Divider(),
                      TextFieldCustom(
                          _dolarController,
                          _dolarChanged,
                          "Dólar",
                          "US"),
                      Divider(),
                      TextFieldCustom(
                          _euroController,
                          _euroChanged,
                          "Euro",
                          "€"),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
