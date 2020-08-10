import 'package:audio_service/audio_service.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:autostart/autostart.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_startup/flutter_startup.dart';

import 'package:ifela/auth.dart';

import 'package:ifela/router.dart';
import 'package:ifela/screens/main.dart';

import 'package:provider/provider.dart';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  var _brightness = Brightness.dark;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [


        StreamProvider<FirebaseUser>.value(
            value: AuthService().user),

      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'ifela',
        theme:  ThemeData.from(
          colorScheme: const ColorScheme.dark( primary: Colors.blue),


          textTheme: TextTheme(

            headline: TextStyle(fontFamily: 'ok'),
          ),
        ),
        // initialRoute:AuthPage.id,
//        SplashScreen.navigate(
      //  'images/ifela.flr',
//            name: 'intro.flr',
//            next: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
//            until: () => Future.delayed(Duration(seconds: 5)),
          //  sta MyHomePage(title: 'hello')
        //theme: ThemeData(colorScheme: const ColorScheme.light( primary: Color(0xFF0D47A1)),fontFamily: 'Raleway' ),
        home:   AudioServiceWidget(
          child: SplashScreen.navigate(next:(context) => MyHomePage(title: 'Flutter Demo Home Page'),
            until: () => Future.delayed(Duration(seconds: 4)),
            name: 'images/i.flr',
            startAnimation:'work' ,
            endAnimation: '4',
            fit: BoxFit.cover,



          ),
        ),


        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();


  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    checkAutoStartManager();
    presetting();
    _requestIOSPermissions();
    vibrate();


    fiam.setAutomaticDataCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);


    return Scaffold(body: user?.uid == null ? AuthPage() : HomePage());
//    return StreamBuilder(
//        stream: FirebaseAuth.instance.onAuthStateChanged,
//        builder: (_, snapshot) {
//          // Added this line
//          if (snapshot.connectionState == ConnectionState.waiting) {
//            return Container(
//              color: Colors.grey,
//            );
//          }
//          if (snapshot.data is FirebaseUser && snapshot.data != null) {
//            return HomePage();
//          }
//          return AuthPage();
//        });
  }

  vibrate() async {
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
      print('shake');
      Vibration.hasVibrator().then((value) =>
      {
        Vibration.vibrate(duration: 1000),

      });


      _showNotificationWithDefaultSound();
      // AudioServiceBackground.setState(playing: true,);

    });
    detector.startListening();
  }


  Future _showNotificationWithDefaultSound() async {
    print('test');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(
        sound: '../images/help.mp4');
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Alert',
      'Alert has been triggered',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onSelectNotification(String payload) async {
    final NotificationAppLaunchDetails details =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    print("test me !-> ${details.payload}");

    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) =>
      new AlertDialog(
        title: new Text('Trigger cancelled '),
        content: new Text('Trigger deactivated by you'),
      ),
    );
  }

  presetting() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }


  void checkAutoStartManager() async {
    //   Autostart.getAutoStartPermission();

  }

}