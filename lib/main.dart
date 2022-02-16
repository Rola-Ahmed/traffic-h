// ignore_for_file: void_checks

import 'dart:async';
import 'package:flutter/material.dart';
import './locationservice.dart';
//import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
//import 'package:google_api_headers/google_api_headers.dart';
//import 'package:google_maps_webservice/places.dart';






void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Set Orgin and Destination',
      home: FromTo(),
    );
  }
}

class FromTo extends StatefulWidget {
  @override
  State<FromTo> createState() => MapFromToState();
  
}

class MapFromToState extends State<FromTo> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
 String googleApikey = "AIzaSyCfyqFlydkxLBFhyTtKdrLnkGyyRP4zqA4";
  late GoogleMapController  mapController; 
   String location = 'Search Location'; 

  

    String orginInput='sreach orgin';
  late String DestinationInput;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;
  

  late var directions;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();

    _setMarker(LatLng(30.033333, 31.233334));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
          /*onTap: () {
          print("orginInput");
        //  var XR=Text('$point');
   var t!=orginInput;
         return(<orginInput!>);
       //  late String orginInput;
 //late String DestinationInput;
         }, */
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Enter orgin and destination'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
         alignment: Alignment.center,
    width: double.infinity,
    height: double.infinity,
    //color: viewModel.color,
        child:  Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _originController,
                          decoration: InputDecoration(hintText: ' Origin'),
                          
                          onChanged: (orginInput) async {
                           // getSuggestion(orginInput);

                            //print(orginInput);

                      //       var orginInput = await PlacesAutocomplete.show(
                      //     context: context,
                      //     apiKey: googleApikey,
                      //     mode: Mode.overlay,
                      //     types: [],
                      //     //language:['en','ar'];
                      //     strictbounds: false,
                      //     components: [Component(Component.country, 'Eg')],
                      //                 //google_map_webservice package
                      //     onError: (err){
                      //        print(err);
                      //     }
                      // );
                  //     if(orginInput  != null){
                  //       setState(() {
                  //        location = orginInput.description.toString();
                  //       },);
                  //                              //form google_maps_webservice package
                  //      final plist = GoogleMapsPlaces(apiKey:googleApikey,
                  //             apiHeaders: await GoogleApiHeaders().getHeaders(),
                  //                       //from google_api_headers package
                  //       );
                  //       String placeid = orginInput.placeId ?? "0";
                  //       final detail = await plist.getDetailsByPlaceId(placeid);
                  //       final geometry = detail.result.geometry!;
                  //       final lat = geometry.location.lat;
                  //       final lang = geometry.location.lng;
                  //       var newlatlang = LatLng(lat, lang);
                        

                  //       //move map camera to selected place with animation
                  //       //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                  //  }
                          },
                        ),
                        TextFormField(
                          controller: _destinationController,
                          decoration: InputDecoration(hintText: ' Destination'),
                          onChanged: (DestinationInput) {
                          //  getSuggestion(DestinationInput);
                            print(DestinationInput);
                          },
                        ), Text(
                          '$LocationService().getDistancematrix2(_destinationControllert,_orginController)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                      onPressed: () async {
                        directions = await LocationService().getDirections(
                         
                          _originController.text,
                          _destinationController.text,
                       
                        );
                        _goToPlace(
                          directions['start_location']['lat'],
                          directions['start_location']['lng'],
                          directions['bounds_ne'],
                          directions['bounds_sw'],
                        );

                        _setPolyline(directions['polyline_decoded'],
                        
                        );
                      },
                      icon: Icon(Icons.search),
                      color: Colors.pink,),
                 ],
              ),

              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  //title:"hello",
                  polygons: _polygons,
                  polylines: _polylines,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    
                    _controller.complete(controller);

                  },
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                      _setPolygon();
                    });
                  },
                ),
              ),

             
            ],
          ),
        ),
    
    );
  }

  Future<void> _goToPlace(
   
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }

}


