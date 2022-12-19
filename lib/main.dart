import 'dart:convert';
import 'dart:developer';

import 'package:backgroun_schedule/utils/grant_user_permission.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
const fetchBackground = "fetchBackground";
  Position? userLocation;
 double? lat,longi;
 Map<String,dynamic>input={
  "lat":"latitude"
 };
   Future getLocation() async {
  await GeolocatorService.determinePosition();
  userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  log(userLocation!.latitude.toString());
  log("fetche");
}

void callbackDispatcher(BuildContext context) {
  Workmanager().executeTask((task, inputData) async {
    
    
    switch (task) {
      case fetchBackground:
          GeolocatorService.determinePosition();
            userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        log(userLocation!.latitude.toString());
        log("fetche");
        log("process");
        break;
    }
    return Future.value(true);
  });
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true
  );
  await Workmanager().registerPeriodicTask("1",fetchBackground,
  frequency: Duration(minutes: 15),
  constraints: Constraints(networkType: NetworkType.connected),
  inputData: {
    // 34.01088069331351, 71.53540110899202
    'array':[34.01088069331351, 71.53540110899202]
  }
  );
  
  // .registerPeriodicTask(
  //   "1",
  //   fetchBackground,
  //   frequency: Duration(minutes: 15),
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BackGround()
    );
  }
}



class BackGround extends StatefulWidget {
  const BackGround({super.key});

  @override
  State<BackGround> createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    getLocation();
    return Scaffold(
      body: Center(child: Text("hii")),
    );
  }
}

newwLogin( double lat,double longi) async {
  // Define the body parameters as variables

  String apiEndpoint =
      'https://gentecbspro.com/MobileApp/CoreAPI/api/values/InsertData';
  String nType = "1";
  String nsType = "2";
  String GPFormId = "36";
  String UserId = "kamil";
  double Latitude = lat;
  double Longitude = longi;
  String DocumentNo = "0";
  String spname = "CRM_DataEntryGeolocationSp";
  String Event = "Tracking By Kamil";

// Encode the body parameters as a JSON object
  String bodyJson = json.encode({
    "SPNAME": spname,
    "ReportQueryParameters": [
      "@nType",
      "@nsType",
      "@GPFormId",
      "@UserId",
      "@Latitude",
      "@Longitude",
      "@DocumentNo",
      "@Event"
    ],
    "ReportQueryValue": [
      nType,
      nsType,
      GPFormId,
      UserId,
      Latitude,
      Longitude,
      DocumentNo,
      Event
    ]
  });

// Make the POST request to the API endpoint, including the JSON object in the request body
  http.Response response = await http.post(Uri.parse(apiEndpoint),
      body: bodyJson, headers: {"Content-Type": "application/json"});

// Check the status code of the response to see if the request was successful
  if (response.statusCode == 200) {
    // The request was successful
    // You can parse the response body to get the data returned by the API
    print(response.body);
    
  } else {
    // The request was not successful
    // You can check the status code and/or the response body to understand the error
    print("Request failed with status code: ${response.body}");
  }
}
