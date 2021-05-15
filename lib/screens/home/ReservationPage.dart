import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'package:taxi_ma/models/User.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_ma/screens/home/RacePage.dart';
import 'package:taxi_ma/services/Auth.dart';
import 'package:taxi_ma/screens/Payment/CardChoicePage.dart';

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
  List<Marker> _markers2 = <Marker>[];

  Marker startMarker ;
  Marker endMarker ;
  bool isCashMode ;
  bool isCardMode ;

  Set<Circle> circles = Set<Circle>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Driver> _drivers= <Driver>[];

  String type_vehicule_value;
  bool isStep2 = false ;
  bool isStep3 = false ;
  bool isStep4 = false ;
  String viheculeType = "0" ;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor bitmapIcon1;
  BitmapDescriptor bitmapIcon2;
  BitmapDescriptor bitmapIcon3;
  Color color_card1 = Colors.amber ;
  Color color_card2 = Colors.amber ;

  Auth auth ;
  void loginAuto() async {
    u.User newUser = u.User.forSignIn(email:"ayoub@gmail.com",password:"azerty@123" );
    auth = new Auth(user:newUser);
    UserCredential user = await auth.signIn();

    if(user != null){
      print("Connected !");
    }
    else {
      print("Failed !");
    }
  }
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
      startMarker = Marker(
        markerId: MarkerId('SomeId'),
        position:LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(
            title: 'Start position' ) ,
      draggable: true ,
      onDragEnd: ((newPosition) {
        _cameraPosition = CameraPosition(target: LatLng(newPosition.latitude, newPosition.longitude) , zoom : 15);
      }) );

      _markers.add(startMarker);
      _markers2.add(startMarker);
    });
  }

  Widget getMap(){
    if(_cameraPosition != null && (!isStep3 ) ) return Expanded( child : GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _cameraPosition,
      markers: Set<Marker>.of(_markers),
      myLocationEnabled: true,
      onTap: _handleTap ,
      circles: circles,
    ));
    else return SizedBox.fromSize(size: Size(0,0),) ;
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
    ) ;
    else
      return SizedBox.fromSize() ;
  }

  Widget getSpinner(){
    if(isStep2 && !isStep3) return Container(
      alignment: Alignment.topRight,
      child : DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('All'),
            value: '0',
          ),
          DropdownMenuItem<String>(
            child: Text('Vehicles'),
            value: '1',
          ),
          DropdownMenuItem<String>(
            child: Text('Taxis'),
            value: '2',
          ),
        ],

        onChanged: (String value) {
          setState(() {
            viheculeType = value;
            loadDrivers();
          });
        },
        hint: Text('Select Item'),
        value: viheculeType,
      ),
    );
    else
      return SizedBox.fromSize(size: Size(0,0),) ;
  }

  _handleTap(LatLng point) {
    if(distination_marker_added) return ;
    else {
      distination_marker_added = true;
      setState(() {
        endMarker = Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Destination',
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          draggable: true ,
          onDragEnd: ((newPosition) {
            print(newPosition.latitude);
            print(newPosition.longitude);
          }),
        ) ;
        _markers.add(endMarker);
        _markers2.add(endMarker);
      });
    }
  }

  void step2(){
    setState(() {
      isStep2 = true;
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
  void step4(){
    setState(() {
      isStep4= true;
     if(isCardMode) {
       Navigator.push(context, MaterialPageRoute(
         builder: (context) => CardChoicePage(),
       ));
     }
     else {
       Navigator.push(context, MaterialPageRoute(
         builder: (context) => RacePage(),
       ));
     }
    });
  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool typeVisible(String type){
    if(viheculeType == "0") return true;
    return (type == viheculeType) ? true : false ;
  }
  void loadDrivers() async {

    if(_markers.length>2)_markers.removeRange(2, _markers.length-1);

    FirebaseFirestore.instance
        .collection('drivers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var driver = Driver.fromJson(doc.data());
        _drivers.add(driver);
        print(driver.full_name);
        setState(() {

          //if(m != null && _markers.contains(m)) _markers.remove(m);
          _markers.add(
              Marker(
                markerId: MarkerId(driver.full_name),
                position: LatLng(driver.position.latitude,driver.position.longitude),
                infoWindow: InfoWindow(
                  title: driver.full_name,
                ),
                icon:  getVehicleIcon(driver.type),
                visible: typeVisible(driver.type) ,
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
    loadIcons();
    super.initState();
    determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
      new Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getChooseDistinationText() ,
            getSpinner(),
            getMap(),
            getPayementInterface(),
            getButtonNext(),
           // getDetails(),
          ]

      ),
    );
  }

  getButtonNext() {
    return distination_marker_added ? SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: (){
            if(!isStep2)step2();
            else if (!isStep3)step3();
            else if(!isStep4)step4();
          },
          child: Text("Next"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          )
      ),
    ) : SizedBox.fromSize(size: Size(0,0),) ;
  }

  BitmapDescriptor getVehicleIcon(String type) {
    if(type == '1') return bitmapIcon2;
    if(type == '2') return bitmapIcon1;
    else return bitmapIcon3 ;
  }

  void loadIcons() async {
    bitmapIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,'asset/images/ic_v3.png');
    bitmapIcon2 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,'asset/images/ic_v4.png');
    bitmapIcon3 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,'asset/images/ic_v5.png');
  }

  void step3() {
    setState(() {
      isStep3 = true ;
    });
  }

  getPayementInterface() {
    return isStep3 && !isStep4 ?  Expanded( child : new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(50),
              child : Text(
            'Please choose payment method ',
            style: TextStyle( fontSize: 15 ),
          )),
          Card(
          color: color_card1,
            elevation: 10,
            margin:EdgeInsets.all(8) ,
            child : InkWell(
              splashColor: Colors.amber[200],
              onTap: (){
                setState(() {
                  isCashMode = true ;
                  isCardMode = false ;
                  color_card1 = Colors.amberAccent ;
                  color_card2 = Colors.amber ;
                });
              },
                 child : Container(
                    padding: EdgeInsets.all(80),
                    child:
                    Text("Payment cash   ",style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    )
                    ),
                  ),
            ) ,
          ),
            Card(
                color: color_card2,
                elevation: 10,
                margin:EdgeInsets.all(8) ,
                child : InkWell(
                  splashColor: Colors.amber[200],
                  onTap: (){
                    setState(() {
                      isCashMode = false ;
                      isCardMode = true ;
                      color_card1 = Colors.amber ;
                      color_card2 = Colors.amberAccent ;
                    });
                  },
                        child: Container(
                            padding: EdgeInsets.all(80),
                    child: Text("Payment online",style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ) , textAlign: ui.TextAlign.center,)
                  ),)
              ),
          ],)
      ] ,
    )): SizedBox.fromSize(size: Size(0,0),)  ;
  }

 /*final Set<Polyline> polyline = {};
  GoogleMapController _controller;
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
  new GoogleMapPolyline(apiKey: "AIzaSyBxc_rnyS8sZ1YsbsK8HY6i7cOz0FmsesE");

  getaddressPoints() async {
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: startMarker.position,
        destination: endMarker.position,
        mode: RouteMode.driving);
    return isStep4 ?
    getMapDetails()
        :
    SizedBox.fromSize(size: Size(0,0),)
    ;
  }*/

  /*getDetails() {
    //getaddressPoints();
    return isStep4 ?
    getMapDetails()
        :
    SizedBox.fromSize(size: Size(0,0),)
    ;
  }

 Widget getMapDetails(){
    if(_cameraPosition != null && isStep4 ) return Expanded( child : GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _cameraPosition,
      markers: Set<Marker>.of(_markers2),
      polylines: polyline,
      myLocationEnabled: true,
      onTap: _handleTap ,
    ));
    else return SizedBox.fromSize(size: Size(0,0),) ;
  }*/

}
