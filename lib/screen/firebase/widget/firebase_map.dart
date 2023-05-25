import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/data/api/api_service.dart';
import 'package:map_app/data/models/lat_long.dart';
import 'package:map_app/data/repositories/geociding_repository.dart';
import 'package:map_app/screen/map_screen/widget/my_drop_down.dart';
import 'package:map_app/utils/constants.dart';
import 'package:map_app/view_model/map_view_model.dart';
import 'package:provider/provider.dart';

class FirebaseMap extends StatefulWidget {
  String userName;
  var latt;
  var long;

  FirebaseMap(
      {super.key,
      required this.latt,
      required this.long,
      required this.userName});

  @override
  State<FirebaseMap> createState() => _FirebaseMapState();
}

class _FirebaseMapState extends State<FirebaseMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String kind = 'house';

  late CameraPosition initialCameraPosition;
  late CameraPosition cameraPosition;

//! -------- Marker And Polyline ----------------------------------------------------
  Uint8List? markerImage;
  final List<Marker> _marker = [];
  final Set<Polyline> _polyline = {};

// ----------- assets ----------------------
  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
// ---------------- network --------------------------
 Future<Uint8List?> LoadNetworkImage(String path)async {
   final completer = Completer<ImageInfo>();
   var image = NetworkImage(path);
   image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener((image, synchronousCall) => completer.complete(image))
   );

   final imageInfo = await completer.future;
   final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

   return byteData!.buffer.asUint8List();

 }
// ----------------------------------------------------------------

  List<LatLng> _latlong =  [
    LatLng(40.54818362589122, 72.78636306524277),
    LatLng(40.574398166938465, 72.78503235429525),
    LatLng(40.54818362589122, 72.78636306524277),
    LatLng(40.56818362589122, 72.78636306524277),
    LatLng(40.51818362589122, 72.78636306524277),
  ];

  loadData() async { 
    for (int i = 0; i < images.length; i++) {
    // -------------- NetwordaImage ----------------------------------------
      Uint8List? image = await LoadNetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100
      );
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png
      );
      final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
    // -------------- AssetsImage ----------------------------------------
    
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 100);
      _marker.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(resizedImageMarker),
            markerId: MarkerId(i.toString()),
            position: _latlong[i],
            infoWindow: InfoWindow(title: 'usmon')),
      );
      setState(() {});
      _polyline.add(
        Polyline(polylineId: PolylineId('1'),
        points: _latlong,
        color: Colors.red
        ));
    }
  }
//! --------------------- Poligone   -------------------------------------------

Set<Polygon> _polygone = HashSet<Polygon>();

List<LatLng> _points =  [
  LatLng(33.654235, 73.073000),
  LatLng(33.647326, 72.820175),
  LatLng(33.689531, 72.263160),
  LatLng(34.131452, 72.662343),
  LatLng(33.654235, 73.073000),
];

polygone(){
 _polygone.add(
  Polygon(
    polygonId: const PolygonId('1'),
    points: _points,
    fillColor: Colors.amber,
    geodesic: true,
    strokeWidth: 4,
    strokeColor: Colors.red
  ));
 
}

//!---------------------------------------------------------------------------
  _init() {
    initialCameraPosition =
        CameraPosition(target: LatLng(widget.long, widget.latt), zoom: 15);
    cameraPosition = CameraPosition(
      target: LatLng(
        widget.latt,
        widget.long,
      ),
      zoom: 15,
    );
  }

String maptheme = '';
  @override
  void initState() {
    polygone();
    loadData();
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
            appBar: AppBar(
              actions: [
                PopupMenuButton(itemBuilder:(context) => [
                  PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context).loadString('assets/maptheme/retro_theme.json').then((string) {
                          value.setMapStyle(string);
                        });
                      });
                    },
                    child: Text('Retro')),
                PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context).loadString('assets/maptheme/dark_theme.json').then((string) {
                          value.setMapStyle(string);
                        });
                      });
                    },
                    child: Text('dark')),
                PopupMenuItem(
                    onTap: () {
                      _controller.future.then((value) {
                        DefaultAssetBundle.of(context).loadString('assets/maptheme/aubergine_theme.json').then((string) {
                          value.setMapStyle(string);
                        });
                      });
                    },
                    child: Text('aubegine')),
                ],)
              ],
            ),
            body: Consumer<MapViewModel>(
              builder: (context, viewModel, child) {
                return Stack(children: [
                  GoogleMap(
                    polylines: _polyline,
                    markers: Set<Marker>.of(_marker),
                    polygons: _polygone,
                    trafficEnabled: true,
                    padding: EdgeInsets.only(bottom: height(context) * 0.45),
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (controller) {
                      controller.setMapStyle(maptheme);
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
                      top: height(context) * 0.9,
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
          ),
        );
      },
    );
  }

  icon(icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        size: height(context) * 0.042,
        weight: height(context),
      ),
    );
  }

}


List<String> images = [
  'assets/images/images1.png',
  'assets/images/images1.png',
  'assets/images/images1.png',
  'assets/images/images1.png',
  'assets/images/images1.png',
];