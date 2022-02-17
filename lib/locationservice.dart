import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import './secrets.dart';
import 'package:dio/dio.dart';
class LocationService {

 static const  key=Secrets.API_KEY;

// Secrets().API_KEY;
 //final Secrets key= Secrets();
   //.API_KEY; // Google Maps API Key

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';//&types=geocode

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key'; //place_id=$placeId&types=address&language=en&components=country:en

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&region=Eg&language=en,ar'; //libraries=places
        

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    
    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    //print(results);

   return results;
   //return results.json['routes'][0]['legs'][0]['start_location'];
  }
 

/*void Time() async {
  Dio dio = new Dio();
  //var dio = Dio();
  var API_KEY='';
  ////final response = await dio.
  //get("https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&departure_time=now&key=$key";);
  get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C,-73.9976592&key=API_KEY");
   //printvalue=response.data;
   late String orginInput;
 late String DestinationInput;
  return (response.data);
}*/


      
   Future<Map<String, dynamic>> getDistancematrix2s(
      String origin, String destination)
   async {
final String url=' https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destination&origins=$origin&key=$key&&callback=initMap';
var json='5mn';
  var response = await http.get(Uri.parse(url));
    //json = convert.jsonDecode(response.body);
   // return response;
    //print( json);

  if (response.statusCode == 200) {
    var json = convert.jsonDecode(response.body);
    return json; 
  } else {
    throw Exception('An error occurred getting places nearby');
  }
}
  

}

