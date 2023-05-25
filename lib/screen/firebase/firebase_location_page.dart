import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:map_app/screen/firebase/widget/firebase_map.dart';

class FirebaseLocationPage extends StatefulWidget {

  const FirebaseLocationPage({super.key});

  @override
  State<FirebaseLocationPage> createState() => _FirebaseLocationPageState();
}

class _FirebaseLocationPageState extends State<FirebaseLocationPage> {

  var fb = FirebaseDatabase.instance;

  var latt;
  var long;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Gruppa');

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FirebaseAnimatedList(
              query: ref,
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                Map data =  snapshot.value as Map;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> FirebaseMap(latt: data.values.first, long: data.values.last, userName: snapshot.key.toString(),)));
                    },
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.indigo[100],
                    title: Text(snapshot.key.toString()),
                    subtitle: Text(data.keys.toString()),
                    trailing: IconButton(onPressed: (){
                         ref.child('${snapshot.key}').remove();
                    }, icon:const Icon(Icons.delete,color: Colors.red,)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}