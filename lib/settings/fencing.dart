import 'package:ifela/depend.dart';
import 'package:flutter/cupertino.dart';

//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//    as bg;

class Fencings extends StatefulWidget {
  static const id = '/fencing';

// final BackgroundGeolocation LOC;

  @override
  _FencingsState createState() => _FencingsState();
}

class _FencingsState extends State<Fencings> {

    @override
  Widget build(BuildContext context) {

      return Scaffold(
          body: Text("helo")
      );
    }

}

//class _FencingsState extends State<Fencings> {
//  var array = [];
//  final Firestore _db = Firestore.instance;
//  var redzones = [];
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//  var view = true;
//
//  Set<Circle> _circle = HashSet<Circle>();
//  Set<Marker> _marker = HashSet<Marker>();
//  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(6.465422, 3.406448),
//    zoom: 10,
//  );
//
//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(9.59396, 8.105306),
//      tilt: 59.440717697143555,
//      zoom: 32.151926040649414);
//
//  final scaffoldKey = GlobalKey<ScaffoldState>();
//  @override
//  void initState() {
////    flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((value) => {
////      print('value'),
////
////    }).catchError((onError)=>print('onError'));
//    // TODO: implement initState
//    super.initState();
//    bg.BackgroundGeolocation.onGeofence((params) {
//      bg.BackgroundGeolocation.startGeofences();
//      showNotification();
//    });
//    presetting();
//    _requestIOSPermissions();
//    preloadfencing();
//  }
//
//  void _requestIOSPermissions() {
//    flutterLocalNotificationsPlugin
//        .resolvePlatformSpecificImplementation<
//            IOSFlutterLocalNotificationsPlugin>()
//        ?.requestPermissions(
//          alert: true,
//          badge: true,
//          sound: true,
//        );
//  }
//
//  Future onSelectNotification(String payload) async {
//    final NotificationAppLaunchDetails details =
//        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//    print("test me !-> ${details.payload}");
//
//    debugPrint("payload : $payload");
//    showDialog(
//      context: context,
//      builder: (_) => new AlertDialog(
//        title: new Text('Trigger cancelled '),
//        content: new Text('Trigger deactivated by you'),
//      ),
//    );
//  }
//
//  showNotification() async {
//    var android = new AndroidNotificationDetails(
//        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//        priority: Priority.High, importance: Importance.Max);
//    var iOS = new IOSNotificationDetails(
//        presentSound: true, presentAlert: true, presentBadge: true);
//    var platform = new NotificationDetails(android, iOS);
//    await flutterLocalNotificationsPlugin
//        .show(0, 'Red Zone alert',
//            'You are in a redzone .Click  to deactivate trigger ', platform,
//            payload: 'Something is happening')
//        .catchError((onError) => {print(onError)});
//
//    Future.delayed(const Duration(minutes: 1), () async {
//      await flutterLocalNotificationsPlugin.cancelAll();
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    var total = redzones.length - array.length;
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Color(0xff171719),
//        centerTitle: false,
//        title: Text('Red Zone Manger'),
//        actions: <Widget>[
//          view
//              ? IconButton(
//                  icon: Icon(Icons.list),
//                  onPressed: () {
//                    setState(() {
//                      view = false;
//                    });
//                  },
//                )
//              : IconButton(
//                  icon: Icon(Icons.map),
//                  onPressed: () {
//                    setState(() {
//                      view = true;
//                    });
//                  },
//                ),
//          Padding(
//            padding: const EdgeInsets.only(top: 17, right: 17),
//            child: array.length == redzones.length
//                ? Container()
//                : Badge(
//                    badgeContent: Text(total.toString()),
//                    animationType: BadgeAnimationType.slide,
//                    child: IconButton(
//                      onPressed: () {
//                        setState(() {
//                          this.redzones.forEach((element) {
//                            bg.BackgroundGeolocation.addGeofence(bg.Geofence(
//                                identifier: element['identifier'],
//                                radius: element['radius'].toDouble(),
//                                latitude: element['latitude'].toDouble(),
//                                longitude: element['longitude'].toDouble(),
//                                notifyOnEntry: element['notifyOnEntry'],
//                                notifyOnExit: element['notifyOnExit']));
//                          });
//
//                          preloadfencing();
//                        });
//                      },
//                      icon: Icon(Icons.cloud_upload),
//                    ),
//                  ),
//          )
//        ],
//      ),
//      body: array.length == 0
//          ? Center(
//              child: RaisedButton(
//                onPressed: () {
//                  setState(() {
//                    this.redzones.forEach((element) {
//                      bg.BackgroundGeolocation.addGeofence(bg.Geofence(
//                          identifier: element['identifier'],
//                          radius: element['radius'].toDouble(),
//                          latitude: element['latitude'].toDouble(),
//                          longitude: element['longitude'].toDouble(),
//                          notifyOnEntry: element['notifyOnEntry'],
//                          notifyOnExit: element['notifyOnExit']));
//                    });
//
//                    preloadfencing();
//                  });
//                },
//                child: Text(
//                  'Load Red Zone',
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: Colors.black,
//              ),
//            )
//          : view ? redZon() : Map(),
//    );
//  }
//
//  RedZone(identifier, radius, latitude, longitude) async {
//    DateTime _now = DateTime.now();
//    await _db.collection('redzone').add({
//      'identifier': identifier,
//      'radius': radius,
//      'latitude': latitude,
//      'longitude': longitude,
//      'notifyOnEntry': true,
//      'notifyOnExit': false,
//      'status': true
//    });
//  }
//
//  preloadfencing() {
//    _db.collection('redzone').snapshots().listen((data) => {
//          setState(() {
//            this.redzones = data.documents;
//          })
//        });
//    bg.BackgroundGeolocation.geofences.then((value) => {
//          setState(() {
//            this.array = value;
//            this.array.forEach((element) {
//              _setCircle(
//                  element.latitude, element.longitude, element.identifier);
//            });
//          })
//        });
//
//    bg.BackgroundGeolocation.onGeofence((value) => {showNotification()});
//  }
//
//  presetting() {
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var iOS = new IOSInitializationSettings();
//    var initSetttings = new InitializationSettings(android, iOS);
//    flutterLocalNotificationsPlugin.initialize(initSetttings,
//        onSelectNotification: onSelectNotification);
//  }
//
//  Widget Map() {
//    return GoogleMap(
//      mapType: MapType.normal,
//      circles: _circle,
//      initialCameraPosition: _kGooglePlex,
//    );
//  }
//
//  void _setCircle(lat, lon, id) {
//    _circle.add(Circle(
//        circleId: CircleId(id),
//        center: LatLng(lat, lon),
//        radius: 600,
//        strokeWidth: 2,
//        fillColor: Color.fromRGBO(133, 1, 3, .4)));
//  }
//
//  Widget redZon() {
//    return ListView.builder(
//      itemCount: array.length,
//      itemBuilder: (BuildContext context, int index) {
//        final geo = array[index];
//        return Dismissible(
//          onDismissed: (dir) {
//            setState(() {
//              array.removeAt(index);
//              bg.BackgroundGeolocation.removeGeofence(geo.identifier);
//            });
//          },
//          background: Container(
//            alignment: AlignmentDirectional.centerEnd,
//            color: Colors.red,
//            margin: EdgeInsets.only(bottom: 5.0),
//            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//            child: Icon(
//              Icons.delete,
//              color: Colors.white,
//            ),
//          ),
//          key: new Key(array[index].toString()),
//          child: Container(
//            margin: EdgeInsets.only(bottom: 5.0),
//            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
//            decoration: BoxDecoration(
//              color: geo.notifyOnDwell
//                  ? Colors.blueAccent.withOpacity(0.2)
//                  : geo.notifyOnExit
//                      ? Colors.blueAccent.withOpacity(0.2)
//                      : Colors.blueAccent.withOpacity(0.2),
//            ),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
////                    CircleAvatar(
////                      radius: 35.0,
////                      backgroundColor: Colors.grey,
////                    ),
////                    SizedBox(width: 10.0),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
//                          width: MediaQuery.of(context).size.width * 0.7,
//                          child: AutoSizeText(
//                            geo.identifier,
//                            overflow: TextOverflow.fade,
//                            softWrap: true,
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 4.0,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                        ),
//                        SizedBox(height: 5.0),
//                        Container(
//                          child: AutoSizeText(
//                            'lat:${geo.latitude.toStringAsFixed(4)}| lon:${geo.longitude.toStringAsFixed(4)}',
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 15.0,
//                              fontWeight: FontWeight.w600,
//                            ),
//                            overflow: TextOverflow.visible,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
////                        Column(
////                          children: <Widget>[
////                            Text(
////                              'Radius',
////                              style: TextStyle(
////                                color: Colors.grey,
////                                fontSize: 15.0,
////                                fontWeight: FontWeight.bold,
////                              ),
////                            ),
////                            SizedBox(height: 5.0),
////                            geo.notifyOnEntry
////                                ? Container(
////                                    width: 40.0,
////                                    height: 20.0,
////                                    decoration: BoxDecoration(
////                                      color: Theme.of(context).primaryColor,
////                                      borderRadius: BorderRadius.circular(30.0),
////                                    ),
////                                    alignment: Alignment.center,
////                                    child: Text(
////                                      geo.radius.toString(),
////                                      style: TextStyle(
////                                        color: Colors.white,
////                                        fontSize: 12.0,
////                                        fontWeight: FontWeight.bold,
////                                      ),
////                                    ),
////                                  )
////                                : Text(''),
////                          ],
////                        ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }
//}
