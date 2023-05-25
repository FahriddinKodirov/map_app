import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/data/api/api_service.dart';
import 'package:map_app/data/models/lat_long.dart';
import 'package:map_app/data/repositories/geociding_repository.dart';
import 'package:map_app/screen/firebase/firebase_location_page.dart';
import 'package:map_app/screen/map_screen/widget/my_drop_down.dart';
import 'package:map_app/utils/constants.dart';
import 'package:map_app/view_model/map_view_model.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final LatLong latLong;
  final String userName;

  const MapScreen({super.key, required this.latLong, required this.userName});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String kind = 'house';

  late CameraPosition initialCameraPosition;
  late CameraPosition cameraPosition;

  Set<Marker> mapMakers = {
    const Marker(
        markerId: MarkerId('id_1'),
        infoWindow: InfoWindow(
          title: 'Najot Talim',
          snippet: 'Zamonaviy kasblar markazi',
        ),
        position: LatLng(
          41.286393176986685,
          69.20411702245474,
        )),
  };

 

  _init() {
    initialCameraPosition = CameraPosition(
        target: LatLng(widget.latLong.lattiitude, widget.latLong.longitude),
        zoom: 15);

    cameraPosition = CameraPosition(
      target: LatLng(
        widget.latLong.lattiitude,
        widget.latLong.longitude,
      ),
      zoom: 15,
    );
  }

  @override
  void initState() {
    // getCurrentLocation();
    // getPolyPoints();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('Gruppa/${widget.userName}');
    ref.set({
      'latt': widget.latLong.longitude,
      'long': widget.latLong.lattiitude,
    });
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MapViewModel(geocodingRepo: GeocodingRepo(apiService: ApiService())),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: CupertinoColors.quaternarySystemFill,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            appBar: AppBar(actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FirebaseLocationPage()));
                  },
                  child: const Text('firebase'))
            ]),
            body: Consumer<MapViewModel>(
              builder: (context, viewModel, child) {
                return Stack(children: [
                  GoogleMap(
                    trafficEnabled: true,
                    myLocationEnabled: true,
                    polylines: {
                      Polyline(
                          polylineId: PolylineId('route'),
                          color: Colors.red,
                          width: 4
                          ),
                    },
                    markers: {
                      Marker(
                          markerId: MarkerId('second'.toString()),
                          position:
                              LatLng(40.51818362589122, 72.78636306524277),
                          infoWindow: InfoWindow(title: 'abulloh')),
                    },
                    padding: EdgeInsets.only(bottom: height(context) * 0.45),
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    onCameraMoveStarted: () {
                      print('"MOVE STARTED"');
                    },
                    onCameraMove: (position) {
                      print("CAMERA POSITION:${position.target.toString()}");
                      cameraPosition = position;
                    },
                    onCameraIdle: () {
                      print('------------Malades-----------');
                      context.read<MapViewModel>().fetchAddress(
                          kind: kind,
                          latLong: LatLong(
                            longitude: cameraPosition.target.longitude,
                            lattiitude: cameraPosition.target.latitude,
                          ));
                    },
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: MyDropDown(
                      onDropSelected: (value) {
                        kind = value;
                        setState(() {});
                      },
                    ),
                  ),
                  // Positioned(
                  //     top: 100, left: 20, child: Text(viewModel.addressText)),

                  Positioned(
                      top: height(context) * 0.8,
                      left: width(context) * 0.03,
                      child: Container(
                        height: height(context) * 0.086,
                        width: width(context) * 0.94,
                        decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemBackground,
                            borderRadius:
                                BorderRadius.circular(height(context) * 0.014)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            icon(CupertinoIcons.search),
                            icon(Icons.location_pin),
                            icon(CupertinoIcons.add),
                            icon(CupertinoIcons.settings),
                          ],
                        ),
                      )),
                ]);
              },
            ),
            floatingActionButton: FloatingActionButton(onPressed: () async {
              GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  const CameraPosition(
                      target: LatLng(41.311081, 69.240562), zoom: 14)));
              setState(() {});
            }),
          ),
        );
      },
    );
  }

  icon(icon) {
    return IconButton(
      onPressed: () async {},
      icon: Icon(
        icon,
        size: height(context) * 0.042,
        weight: height(context),
      ),
    );
  }
}
