import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:taxi_ma/models/Driver.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  Position p ;
  bool distination_marker_added = false ;
  CameraPosition _cameraPosition ;
  List<Marker> _markers = <Marker>[];

  Set<Circle> circles = Set<Circle>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Driver> _drivers= <Driver>[];


  void determinePosition() async {
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.requestPermission();
    p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print(p.latitude.toString() + ',' + p.longitude.toString());

    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(p.latitude, p.longitude),
        zoom: 15 ,
      );
      _markers.add(Marker(
        markerId: MarkerId('SomeId'),
        position:LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(
            title: 'The title of the marker'
        ),
        draggable: true ,
        onDragEnd: ((newPosition) {
          print(newPosition.latitude);
          print(newPosition.longitude);
        }),
      ));
    });
  }

  Widget getMap(){
    if(_cameraPosition != null ) return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _cameraPosition,
      markers: Set<Marker>.of(_markers),
      myLocationEnabled: true,
      onTap: _handleTap ,
      circles: circles,
    );
    else return SizedBox.fromSize() ;
  }

  Widget getChooseDistinationText(){
    if(!distination_marker_added) return Container(
      child: Text(
        'Please choose your distination ',
        style: TextStyle( fontSize: 15 ),
      ),
      height: 30,
      color: Colors.amber,
      margin: EdgeInsets.all(2),
      alignment: Alignment.center,
    );
    else
      return SizedBox.fromSize() ;
  }

  _handleTap(LatLng point) {
    if(distination_marker_added) return ;
    else {
      distination_marker_added = true;
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'I am a marker',
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          draggable: true ,
          onDragEnd: ((newPosition) {
            print(newPosition.latitude);
            print(newPosition.longitude);
          }),
        ));
      });
    }
  }

  void step2(){
    setState(() {
      circles.add(Circle(
          circleId: CircleId("1"),
          center: LatLng(p.latitude, p.longitude),
          radius: 500,
          fillColor: Color.fromRGBO(41, 98, 255 , 0.3),
          strokeWidth: 1
      ));
      loadDrivers();
    });

  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void loadDrivers(){
    FirebaseFirestore.instance
        .collection('drivers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var driver = Driver.fromJson(doc.data());
        _drivers.add(driver);
        setState(() {
          _markers.add(
              Marker(
                markerId: MarkerId(driver.full_name),
                position: LatLng(driver.position.latitude,driver.position.longitude),
                infoWindow: InfoWindow(
                  title: driver.full_name,
                ),
                icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                onTap: (){

                }
              )
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getChooseDistinationText() ,
            Expanded(
              child:  getMap(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    step2();
                  },
                  child: Text("Next"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  )
              ),
            ),
          ]

      ),
    );
  }
}
