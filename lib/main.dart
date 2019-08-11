import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IMC(),
    );
  }
}

class IMC extends StatefulWidget {
  @override
  _IMCState createState() => _IMCState();
}

class _IMCState extends State<IMC> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe os dados!";
  Color _color = Colors.green;

  void _showAbout() async {
    const url = 'https://github.com/rogeriorocha/imc';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível executar $url';
    }
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe os dados!";
      _color = Colors.green;
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 16) {
        _infoText = "Magreza grave (${imc.toStringAsPrecision(4)})";
        _color = Colors.red[900];
      } else if (imc <= 17) {
        _infoText = "Magreza moderada (${imc.toStringAsPrecision(4)})";
        _color = Colors.red[300];
      } else if (imc <= 18.5) {
        _infoText = "Magreza leve (${imc.toStringAsPrecision(4)})";
        _color = Colors.lightGreenAccent;
      } else if (imc <= 25) {
        _infoText = "Saudável (${imc.toStringAsPrecision(4)})";
        _color = Colors.green[900];
      } else if (imc <= 30) {
        _infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
        _color = Colors.limeAccent;
      } else if (imc <= 35) {
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
        _color = Colors.red[300];
      } else if (imc <= 40) {
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
        _color = Colors.red;
      } else {
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
        _color = Colors.red[900];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: _color,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
          IconButton(
            icon: Icon(Icons.alternate_email),
            onPressed: _showAbout,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_pin, size: 140.0, color: _color),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: _color)),
                textAlign: TextAlign.center,
                style: TextStyle(color: _color, fontSize: 27.0),
                controller: weightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira seu Peso!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: _color)),
                textAlign: TextAlign.center,
                style: TextStyle(color: _color, fontSize: 27.0),
                controller: heightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira sua Altura!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 45.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    color: _color,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: _color, fontSize: 26.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
