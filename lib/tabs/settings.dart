import 'package:flutter/cupertino.dart';
import 'package:ifela/depend.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:background_geolocation_firebase/background_geolocation_firebase.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class Settings extends StatefulWidget {
  static const id = '/settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var address = '';
  GoogleMapController _controller;
  Location location = Location();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isMoving;
  bool _enabled;
  String _motionActivity;
  String _odometer;
  String _locationJSON;
  JsonEncoder _encoder = new JsonEncoder.withIndent('  ');
  Set<Circle> _circle = HashSet<Circle>();
  Set<Marker> _marker = HashSet<Marker>();

  String Style;

  String error;

  var locat;

  @override
  initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    _enabled = false;
    checkUser();
    _locationJSON = "Toggle the switch to start tracking.";
    _motionActivity = 'UNKNOWN';
    initPlatformState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  changeMapMode() {
    getJsonFile("images/dark.json").then(setMapStyle);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final DocumentSnapshot usersdata = Provider.of<DocumentSnapshot>(context);

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          //  backgroundColor: Colors.white,
          title: ListTile(
            title: Text(
              usersdata['name'],
              style: kHeadingextStyle,
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(usersdata['photo']),
            ),
            subtitle: Text(
              usersdata['phone_number'],
              style: kSubheadingextStyle,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(UpdateProfile.id, arguments: usersdata);
            },
          ),
          actions: <Widget>[
            _enabled
                ? Platform.isIOS
                    ? CupertinoSwitch(
                        value: _enabled, onChanged: _onClickEnable)
                    : Switch(value: _enabled, onChanged: _onClickEnable)
                : Container(),
          ],
        ),
        body: _enabled
            ? SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  locat != null
                      ? ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff171719), Colors.transparent],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            height: size.height / 3,
                            width: size.width,
                            child: GoogleMap(
                              mapType: MapType.normal,

                              onMapCreated: (GoogleMapController controller) {
                                _controller = controller;

                                changeMapMode();
                                setState(() {});
                              },

//                            markers: _setMarker(locat),
//                            circles: _setCircle(locat),
                              initialCameraPosition: (CameraPosition(
                                  target: LatLng(
                                      locat?.latitude == null
                                          ? 9.59396
                                          : locat?.latitude,
                                      locat?.longitude == null
                                          ? 9.59396
                                          : locat?.longitude),
                                  zoom: 12)),
                            ),
                          ),
                        )
                      : shimmers(),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Location Settings",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            title: Text(
                              'Pending contact',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () => Navigator.of(context).pushNamed(
                                PendingContact.id,
                                arguments: usersdata['UID'])),
                        ListTile(
                            title: Text('Manage Red Zones',
                                style: TextStyle(color: Colors.white)),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () => Navigator.of(context).pushNamed(Fencings.id)),
//                        ListTile(
//                          title: Text('Enable auto start',
//                              style: TextStyle(color: Colors.white)),
//                          trailing: Icon(Icons.arrow_right),
//                          onTap: () {
//                            checkAutoStartManager(context);
//                          },
//                        ),
                        ListTile(
                          title: Text('App Info',
                              style: TextStyle(color: Colors.white)),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationVersion: '0.0.0',
                              applicationIcon: ImageIcon(

                             new    AssetImage('images/logo2.png'),
                                color: Color.fromRGBO(32,127,195,1),

                              ),
                              applicationLegalese:
                                  '@ 2020 ifela.',
                              applicationName: 'ifela',

                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text('We try to modernize the way people look at securityLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',style:TextStyle(fontSize: 12) ,),

                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(color: Theme.of(context).accentColor),
                                          text: 'www.ifela.org'),
                                    ],
                                  ),
                                )
                              ]
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ))
            : Center(
                child: RaisedButton(
                  onPressed: () {
                    _onClickEnable(true);
                    if (!mounted) return;
                    setState(() {});
                  },
                  child: Text(
                    'Enable Tracking',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF0D47A1),
                ),
              ));
  }

  shimmers() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        height: MediaQuery.of(context).size.height / 3,
        child: Shimmer.fromColors(
          baseColor: Colors.black26,
          highlightColor: Color(0xff171719),
          enabled: true,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ));
  }

  _setCircle(currentpostion) {
    _circle.add(Circle(
        circleId: CircleId("o"),
        center: LatLng(currentpostion?.latitude, currentpostion?.longitude),
        radius: 60,
        strokeWidth: 2,
        fillColor: Color.fromRGBO(12, 51, 133, .5)));
    _address(currentpostion);

    return _circle;
  }

  _address(coord) async {
    final coordinates = new Coordinates(coord?.latitude, coord?.longitude);

    try {
      var addresses =
          await Geocoder.google('AIzaSyB2YdTgWF1T5TmYdTDPA-3FpkiDoSnpsaU').findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
//    Fluttertoast.showToast(
//        msg: 'My location:${first.addressLine},${first.locality},${first.countryName}',
//        toastLength: Toast.LENGTH_LONG,
//        gravity: ToastGravity.CENTER,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.black,
//        textColor: Colors.white,
//        fontSize: 16.0);
      address = first.addressLine;
    } catch (err) {
      print(err);
    }
  }

  _setMarker(currentpostion) {
    _marker.add(Marker(
      markerId: MarkerId("${currentpostion.toString()}"),
      position: LatLng(currentpostion?.latitude, currentpostion?.longitude),
      infoWindow: InfoWindow(title: address),
    ));

    return _marker;
  }



  void checkAutoStartManager(BuildContext context) async {
    print('hell');
    Autostart.getAutoStartPermission();

  }


  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });

    if (enabled) {
      bg.BackgroundGeolocation.start();
    } else {
      bg.BackgroundGeolocation.stop();
    }
  }

  Future<void> initPlatformState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user  =  await prefs.getString('UID');

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] $location');
      setState(() {
        locat = location.coords;
      //  _locationJSON = _encoder.convert(location.toMap());


      });
    });

    BackgroundGeolocationFirebase.configure(BackgroundGeolocationFirebaseConfig(
        locationsCollection: "/users/${user}/locations",
        geofencesCollection: "geofences",
        updateSingleDocument: false
    ));

    bg.BackgroundGeolocation.ready(bg.Config(
        debug: true,
        distanceFilter: 100,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        stopTimeout: 1,
        stopOnTerminate: false,
        startOnBoot: true
    )).then((bg.State state) {
      setState(() {
        _enabled = state.enabled;
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  checkUser(){
    FirebaseAuth.instance.onAuthStateChanged.listen((event) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'phoneNo',event.phoneNumber.toString().trim().replaceAll(' ', ''));
      await prefs.setString('UID', event.uid);

    });
  }

}
