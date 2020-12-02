import 'package:division/division.dart';
import 'package:file_access/file_access.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  JESUS SALVADOR URIBE FERRER
  TEORIA DE AUTOMATAS
  PROYECTO 1
*/

void main() {
  runApp(
    MaterialApp(
      home: MyWidget(),
      title: 'Proyecto 1 - Automatas',
      color: Colors.amber,
    ),
  );
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController _input;
  Automata _contador;
  String cadenaDesdeArchivo;

  @override
  void initState() {
    super.initState();

    _input = TextEditingController();

    _contador = Automata(
      alfabeto: ['#', 'e', 'b', 'a', 'y', 'w'],
      estadoInicial: 0,
      estadosFinales: [3, 7],
      transiciones: [
        [0, 4, 4, 0, 0, 0, 1],
        [1, 0, 2, 0, 0, 0, 1],
        [2, 0, 4, 3, 0, 0, 1],
        [3, 0, 4, 0, 6, 0, 1],
        [4, 0, 4, 5, 0, 0, 1],
        [5, 0, 4, 0, 6, 0, 1],
        [6, 0, 4, 0, 0, 7, 1],
        [7, 0, 4, 0, 0, 0, 1],
      ],
    );
  }

  void abrirArchivo() async {
    final _file = await openFile();
    cadenaDesdeArchivo = await _file.readAsString();

    setState(() {
      _input.text = cadenaDesdeArchivo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TITULO
            Text(
              'Proyecto 1 - Teoria de Automatas',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Jesus Salvador Uribe Ferrer',
              style: Theme.of(context).textTheme.headline6,
            ),
            // CAMPO DE TEXTO
            Parent(
              style: ParentStyle()
                ..width(500)
                ..height(300)
                ..background.color(Colors.amber[700])
                ..borderRadius(all: 10)
                ..padding(all: 5)
                ..margin(all: 15),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _input,
                maxLines: null,
                minLines: null,
                expands: true,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              'Ingresa el texto o selecciona un archivo .txt.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            // BOTON SELECCIONAR
            Parent(
              style: ParentStyle()
                ..height(50)
                ..border(color: Colors.amber[700], all: 3)
                ..borderRadius(all: 5)
                ..margin(all: 15),
              child: FlatButton.icon(
                onPressed: () {
                  abrirArchivo();
                },
                icon: Icon(Icons.upload_file),
                label: Text('Seleccionar'),
              ),
            ),
            // BOTON CONTAR
            Parent(
              style: ParentStyle()
                ..height(50)
                ..border(color: Colors.amber[700], all: 3)
                ..borderRadius(all: 5)
                ..margin(all: 15),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _contador.procesar(
                      cadena: _input.text
                          .toLowerCase()
                          .replaceAll(RegExp(r'[\s,.cdf-vxz0-9+]'), '#'),
                    ); // se reemplazan caracteres que no estan en el alfabeto con #
                  });
                },
                child: Text('Contar'),
              ),
            ),
            // RESULTADOS
            Parent(
              style: ParentStyle()..width(300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Ebay: ' + _contador.contEbay.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Web: ' + _contador.contWeb.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Automata {
  List<String> alfabeto;
  int estadoInicial = 0;
  List<int> estadosFinales;
  List<List> transiciones;

  int estadoActual = 0, contWeb, contEbay;

  Automata(
      {this.alfabeto,
      this.estadoInicial,
      this.estadosFinales,
      this.transiciones}) {
    this.contEbay = 0;
    this.contWeb = 0;
  }

  void procesar({String cadena}) {
    contEbay = 0;
    contWeb = 0;
    for (String c in cadena.split('')) {
      print('estado: ' + estadoActual.toString() + ' entrada: ' + c);
      estadoActual = transiciones[estadoActual][alfabeto.indexOf(c) + 1];
      if (estadoActual == 3) {
        contWeb++;
      }
      if (estadoActual == 7) {
        contEbay++;
      }
    }
    print('Web: ' + contWeb.toString() + '   Ebay: ' + contEbay.toString());
  }
}
