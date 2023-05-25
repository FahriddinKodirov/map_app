import 'package:flutter/material.dart';
import 'package:map_app/data/models/lat_long.dart';
import 'package:map_app/screen/map_screen/map_screen.dart';
import 'package:map_app/utils/constants.dart';

class UserNamePage extends StatefulWidget {
  final LatLong latLong;

  const UserNamePage({super.key, required this.latLong});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  TextEditingController nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: getInputDecorationTwo(label: 'name'),
            ),
          ),
          ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(latLong: widget.latLong,userName: nameController.text,)));
          }, child: const Text('Accept'))
        ],
      ),
     ),
    );
  }
}