import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'country.dart';
import 'list.dart';
import 'netwoklayer.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;

  List<Country> filteredRecord;

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    fetchCountry(new http.Client()).then((String) {
      parseData(String);
    });
  }

  List<Country> allRecord;

  parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
      allRecord =
          parsed.map<Country>((json) => new Country.fromJson(json)).toList();
    });
    filteredRecord = new List<Country>();
    filteredRecord.addAll(allRecord);
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
      filteredRecord.addAll(allRecord);
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text('Seach box',
            style: new TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    filteredRecord.clear();
    if (newQuery.length > 0) {
      Set<Country> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }

    if (newQuery.isEmpty) {
      filteredRecord.addAll(allRecord);
    }

    setState(() {});
  }

  filterList(Country country, String searchQuery) {
    setState(() {
      if (country.name.toLowerCase().contains(searchQuery) ||
          country.name.contains(searchQuery)) {
        filteredRecord.add(country);
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: Colors.white,),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: Colors.white,),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? new BackButton( color: Colors.white,) : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: filteredRecord != null && filteredRecord.length > 0
          ? new CountyList(country: filteredRecord)
          : allRecord == null
              ? new Center(child: new CircularProgressIndicator())
              : new Center(
                  child: new Text("No record match!"),
                ),
    );
  }
}
