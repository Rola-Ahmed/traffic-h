// ignore_for_file: void_checks

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './locationservice.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
//import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
//import 'package:google_api_headers/google_api_headers.dart';
//import 'package:google_maps_webservice/places.dart';
import './secrets.dart';

import 'package:permission_asker/permission_asker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:geocoding/geocoding.dart';

//List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");



void main() => runApp(MyApp());

/*void main(){
if (defaultTargetPlatform == TargetPlatform.android) {
AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
runApp(MyApp());
}*/ 

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
  late GoogleMapController  mapController; 
   
  

  

 
   late String originInputString='';
 late String destinationInputString='';
 var DistanceofLocation=LocationService().getDistance("miu","guc");
var TimeofLocation=LocationService().getTime("miu","guc");
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
 late String OrginInput;
 late String DestinationInput;
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
    // ignore: unnecessary_new
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Enter orgin and destination'),
        backgroundColor: Colors.blueGrey,
      ),
      body: PermissionAskerBuilder(
        permissions: [
          Permission.location,
          //Permission.camera,
        ],
        grantedBuilder: (context) => Container(
         alignment: Alignment.center,
    width: double.infinity,
    height: double.infinity,
    //color: viewModel.color,
        child:  Column(
            children: [
              SingleChildScrollView(
          child:
              SearchMapPlaceWidget(
                        hasClearButton: true,
                        placeType:PlaceType.address,
                       // controller: _originController,
                        placeholder: 'Enter the location',
                        apiKey: Secrets.API_KEY,
                        onSelected: ( place) async {
                          //Geolocation? geolocation = await place.geolocation;
                          print(place);
                         // mapController.animateCamera(
                           //   CameraUpdate.newLatLng(geolocation!.coordinates));
                          //mapController.animateCamera(
                            //  CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                        },
                      ),
                      ),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _originController,
                          decoration: InputDecoration(hintText: ' Origin'),
                          
                          onChanged: (originInput) async {
                           // getSuggestion(orginInput);

                            print(originInput);
                            originInputString=originInput;
                            //print("the ssssssssssssssssssssssssssssss $originInputString");
                            print("the_origidddnController $_originController");


                          },
                        ),
                        TextFormField(
                          controller: _destinationController,
                          decoration: InputDecoration(hintText: ' Destination'),
                          onChanged: (destinationInput) {
                          //  getSuggestion(DestinationInput);
                            print(destinationInput);
                             
  destinationInputString=destinationInput;
                            print("the inputtt is $_destinationController.text");
                          },
                         ), 
                         Text(
                          '$DistanceofLocation and $TimeofLocation',
                          //_originController.text, _destinationController.text
                          //"miu","guc"
                         
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 15,
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
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                // compassEnabled:true,
                //mapToolbarEnabled:true,
                
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
        )

,
        notGrantedBuilder: (context, notGrantedPermissions) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Not granted permissions:'),
              for (final p in notGrantedPermissions) Text(p.toString())
            ],
          ),
        ),
        notGrantedListener: (notGrantedPermissions) =>
            print('Not granted:\n$notGrantedPermissions'),
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

Future<List<Location>> locationFromAddress(
  String address, {
  String? localeIdentifier,
  
  
}) =>
    GeocodingPlatform.instance.locationFromAddress(
      address,
      localeIdentifier: localeIdentifier,
      
    );
void M(){
  print('locatiooooooooooooons');
print (locationFromAddress("Gronausestraat 710, Enschede"));
}
}



