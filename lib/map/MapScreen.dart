import 'dart:async';
import 'package:flutter_application_33/bottomnav/bottomnavy.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_33/map/sample/xyz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  String _startAddress = '';
  final startAddressController = TextEditingController();
  late Position _currentPosition;
  String _currentAddress = '';
  Set<Marker> markers = {};
  TextEditingController _date = TextEditingController();
  late GoogleMapController mapController;
  var currlocation;
  var clients = [];
  final CameraPosition _initialLocation =
      const CameraPosition(target: LatLng(28.7041, 77.1025));
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng source = LatLng(28.7041, 77.1025);
  static const LatLng dest = LatLng(30.167319, 77.311288);
  // BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  _getCurrentLocation() async {
    bool serviceenabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceenabled) {
      return Future.error("Disabled");
    }
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("denied");
    } else {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        setState(() {
          _currentPosition = position;
          // print('CURRENT POS: $_currentPosition');
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0,
              ),
            ),
          );
        });
        await _getAddress();
        addCurrentLocationMark();
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    }
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<dynamic> addCurrentLocationMark() async {
    setState(() {
      markers.add(
        Marker(
            infoWindow: const InfoWindow(title: "My Location"),
            markerId: const MarkerId('startPosition'),
            position:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }

  Future getallVendors() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Vendors').get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      markers.add(
        Marker(
            markerId: MarkerId(querySnapshot.docs[i]['company']),
            position: LatLng(querySnapshot.docs[i]['location'].latitude,
                querySnapshot.docs[i]['location'].longitude),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ListTile(
                        onTap: () async {
                          _makingPhoneCall(querySnapshot.docs[i]['contactno']);
                        },
                        leading: Icon(
                          Icons.call,
                        ),
                        title: Text("Contact"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextField(
                          keyboardType: TextInputType.none,
                          controller: _date,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today_rounded),
                            labelText: "Select Date",
                          ),
                          onTap: () async {
                            DateTime? pickDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickDate != null) {
                              setState(() {
                                _date.text =
                                    DateFormat('dd-MM-yyyy').format(pickDate);
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(children: [
                                  AlertDialog(
                                    title: Text("Order Done Successfully 🎉"),
                                  ),
                                ]);
                              },
                            );
                          },
                          child: Text("Order Now" +
                              " " +
                              querySnapshot.docs[i]['category'])),
                    ],
                  );
                },
              );
            },
            infoWindow: InfoWindow(
                title: querySnapshot.docs[i]['category'],
                snippet:
                    querySnapshot.docs[i]['rating'] + '🌟' + " " + "Rating"),
            icon: BitmapDescriptor.defaultMarker),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCurrentLocation();
    getallVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialLocation,
        markers: Set<Marker>.from(markers),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        // Marker(
        //custom marker
        //     markerId: MarkerId("src"),
        //     position: source,
        //     draggable: true,
        //     onDragEnd: (value) {
        //       //value is new position if dragged
        //     },
        //     icon: BitmapDescriptor.defaultMarker),
        // Marker(
        //     markerId: MarkerId("Dest"),
        //     position: dest,
        //     draggable: true,
        //     onDragEnd: (value) {
        //       //value is new position if dragged
        //     },
        //     icon: BitmapDescriptor.defaultMarker)
      ),
    );
  }
}

//Making Phone calls in the text button of contact us button
_makingPhoneCall(var url) async {
  var url = Uri.parse("tel:9466445533");
  if (await canLaunchUrl(url)) {
    print("Calling");
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
