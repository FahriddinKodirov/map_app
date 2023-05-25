import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchMapPage extends StatefulWidget {
  const SearchMapPage({super.key});

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  TextEditingController _controller = TextEditingController();

  var uuid = Uuid();
  String _sessionToken = '122344';
  List _placesList = [];

  @override
  void initState() {
    _controller.addListener(() {
      onChange();
    });
    super.initState();
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggesion(_controller.text);
  }

  getSuggesion(String input) async {
    String kPlaceApiKey = 'AIzaSyDvtnCFok6wEmFuX4jWqOk4SqUT7-utIdI';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=$kPlaceApiKey&sessiontoke=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    print('data');
    print(response.body.toString());

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Faild');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google search api'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(label: Text('search')),
            ),
            Expanded(child: ListView.builder(
              itemCount: _placesList.length,
              itemBuilder:(context, index) {
              return ListTile(
                  title: Text(_placesList[index]['description']),
                
              );
            },))
          ],
        ),
      ),
    );
  }
}
