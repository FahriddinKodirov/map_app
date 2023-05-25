import 'package:map_app/data/api/api_service.dart';
import 'package:map_app/data/models/lat_long.dart';

class GeocodingRepo {
 final ApiService apiService;

 GeocodingRepo({required this.apiService});

 Future<String> getAdress(LatLong latLong, kind) =>
            apiService.getLocationName(geoCodeText: '${latLong.longitude},${latLong.lattiitude}', kind: kind);
}