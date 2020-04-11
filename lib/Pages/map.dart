import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MapPage extends StatefulWidget{

  @override
  _MapPage createState() => _MapPage();


}

class _MapPage extends State<MapPage>{

  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  

  void loadData() async {
   
    print("Loading geojson data");
    // statefulMapController.addLine(name: "test", points: [
    //   for (final i in geojson["points"]) LatLng(i[1], i[0])
    // ],width: 5.0);
    statefulMapController.addMarker(
      marker: Marker(builder: (_) => Icon(Icons.location_on, color: Colors.red) ),
      name: "mark",

    );
  }


  @override
  void initState() {
    initialiseLocation();
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => loadData());
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }

   Future<void> initialiseLocation() async{
   
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

}
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: MapOptions(
              center: LatLng(-18.943591 , 4.524609),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              // MarkerLayerOptions(markers: statefulMapController.markers),
              // PolylineLayerOptions(polylines: statefulMapController.lines),
              // PolygonLayerOptions(polygons: statefulMapController.polygons)
            ],
          )
        ],
      )
    );
  }

  Future<Map> dataJson({double dla, double dlo, double fla, double flo}) async{ 
     http.Response rep = await http.get(
      "https://mayday-kaody.herokuapp.com/api/directions?dlo=$dlo&dla=$dla&flo=$flo&fla=$fla"
    );

    if (rep.statusCode == 200){
      return json.decode(rep.body);
    }
    else{
      return {};
    }
  }


  double locationGet(String lalo){
    if (lalo == "la"){
      try {
        return _locationData.latitude;
      }
      catch(e){
        print(e);
      }
    }
    else if (lalo == "lo"){
      try { 
         return _locationData.longitude;
      }
      catch (e){
        print(e);
      }
    }

    return 0.0;
  }
}