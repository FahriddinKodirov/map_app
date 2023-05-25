import 'package:flutter/cupertino.dart';
import 'package:map_app/data/models/lat_long.dart';
import 'package:map_app/data/repositories/geociding_repository.dart';

class MapViewModel extends ChangeNotifier {
  GeocodingRepo geocodingRepo;

 MapViewModel({required this.geocodingRepo});

 String addressText = '';

 fetchAddress({required LatLong latLong, required String kind}) async {
  addressText = await geocodingRepo.getAdress(latLong, kind);
  notifyListeners();
 }
}