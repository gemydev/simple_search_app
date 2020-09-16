import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'country.dart';

class CountyList extends StatelessWidget {
  final List<Country> country;

  CountyList({Key key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: country == null ? 0 : country.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Container(
              child: new Center(
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(
                    country[index].name,
                    style: new TextStyle(
                        fontSize: 20.0, color: Colors.lightBlueAccent),
                  ),
                  new Text(
                    "Capital: " + country[index].capital,
                    style: new TextStyle(fontSize: 20.0, color: Colors.indigo),
                  ),
                ],
              )),
              padding: const EdgeInsets.all(15.0),
            ),
          );
        });
  }
}
