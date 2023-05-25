import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_app/data/api/api_client.dart';
import 'package:map_app/data/geocoding/geocoding.dart';
import 'package:map_app/utils/constants.dart';

class ApiService extends ApiClient {

  Future<String> getLocationName({required String geoCodeText, required String kind}) async {
   String text = '';

   try {
    late Response response;
    Map<String, String> queryParams = {
        'apikey': mapApiKey,
        'geocode': geoCodeText,
        'lang': 'uz_UZ',
        'format': 'json',
        'kind': kind,
        'rspn': '1',
        'results': '1',
      };
       debugPrint("QueryParams>>>>>>>>>>$queryParams");
       response = await dio.get('${dio.options.baseUrl}',queryParameters: queryParams);

       if(response.statusCode! == 200) {
        Geocoding geocoding = Geocoding.fromJson(response.data);
        
        if(geocoding.response.geoObjectCollection.featureMember.isNotEmpty){
          text = geocoding.response.geoObjectCollection.featureMember[0]
              .geoObject.metaDataProperty.geocoderMetaData.text;
          debugPrint("text>>>>>>>>>>>> $text");
        } else {
          text = 'Aniqlanmagan hudud';
        } return text;
       } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
   }

  }
