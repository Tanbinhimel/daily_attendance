import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var distance = '10000';
  var isLocationMocked = false;

  @override
  void initState() {
    super.initState();
    setDistanceFromTruckLagbeTech();
  }

  @override
  Widget build(BuildContext context) {
    var distanceUI = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('You are', style: GoogleFonts.acme(fontSize: 20)),
          Text('$distance meter',
              style: GoogleFonts.acme(
                  fontSize: 30, color: Colors.red)),
          Text('away from Truck Lagbe Tech',
              style: GoogleFonts.acme(fontSize: 20))
        ]);

    var mockLocationUI = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Sorry Bro!', style: GoogleFonts.acme(
              fontSize: 30, color: Colors.red)),
          Text('You Are mocking location!',
              style: GoogleFonts.acme(
                  fontSize: 30, color: Colors.red))
        ]);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text('Daily Attendance',
                    style: GoogleFonts.acme(fontSize: 25)),
                centerTitle: true),
            body: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: isLocationMocked ? mockLocationUI : distanceUI)));
  }

  void setDistanceFromTruckLagbeTech() async {
    requestLocationPermission();

    const truckLagbeTechLatitude = 23.7819683;
    const truckLagbeTechLongitude = 90.3939017;
    const double minimumDistanceForAPICall = 25;

    Geolocator.getPositionStream().listen((event) {
      if (event.isMocked) {
        isLocationMocked = true;
        return;
      }
      final newDistance = Geolocator.distanceBetween(event.latitude,
          event.longitude, truckLagbeTechLatitude, truckLagbeTechLongitude)
          .round();
      setState(() {
        isLocationMocked = false;
        distance = newDistance.toString();
      });

      if (double.parse(distance) <= minimumDistanceForAPICall) {
        // api call here
      }
    });
  }

  void requestLocationPermission() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
