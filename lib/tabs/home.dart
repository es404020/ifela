

import 'package:flutter/cupertino.dart';

import 'package:focused_menu/modals.dart';
import 'dart:io' as io;
import 'package:ifela/depend.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeTab>
    with SingleTickerProviderStateMixin {
  List<TargetFocus> targets = List();
  final LocalStorage storage = new LocalStorage('intro');
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  var dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString() ;

//*-----defining animation and animation controller-----*
  AnimationController _controller;
  Animation _myAnimation;
  final List intoArr = [
    "We focus on modernize how to stay secured .",
    "We send a trigger which contains a dynamic link to your contact person when you request help.",
    "We provide regular Inapp and  push notification educating you on your fundermental human right.",
    "We help fight against police brutality"
  ];

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  //  _init();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _myAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    var value =
        storage.getItem('value') == null || storage.getItem('value') == false
            ? false
            : true;

    if (value) {
      initTargets();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //-disposing the animation controller-
    _controller.dispose();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.blueAccent,
        paddingFocus: 10,
        opacityShadow: 0.8, finish: () {
      print("finish");
      storage.setItem('value', false);
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      storage.getItem('value');
    })
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    var usersdata = Provider.of<DocumentSnapshot>(context);

    var heights = Platform.isAndroid
        ? MediaQuery.of(context).size.height * 0.3
        : MediaQuery.of(context).size.height * 0.3;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(heights.toDouble()),
          child: AppBar(
              automaticallyImplyLeading: false,
              // backgroundColor: Colors.white,
              actions: <Widget>[],
              flexibleSpace: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            key: keyButton,
                            padding: const EdgeInsets.all(6.0),
                            child: Text('Hello, ${usersdata['name'].toString()}',
                                style: kHeadingextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(Icons.exit_to_app),
                              onPressed: () {
                                return AuthService().signOut().then((_) => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AuthPage()))
                                    });
                              },
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
//                    DefaultTextStyle(
//                      key: keyButton4,
//                      style: TextStyle(color: Colors.blue),
//                      child: Container(
//                        margin: EdgeInsets.only(bottom: 1),
//                        child: new Calendar(onDateSelected: (s){
//
//                          DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(s.toString());
//                        setState(() {
//                          dateToday=tempDate.toString();
//                        });
//                        },),
//                      ),
//                    )
                  ],
                ),
              )),
        ),
        body: GestureDetector(
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(

            child: Column(children: [
              FadeTransition(
                opacity: _myAnimation,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 4.0,
                          color: Theme.of(context).cardColor,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.poll,
                                  color: Color(0xFF0D47A1),
                                  size: 40,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      " Health Center",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "Be part of a community.",
                                      style: kSubheadingextStyle,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  key: keyButton2,
                                  padding: const EdgeInsets.all(12.0),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      _start();

                                    },
                                    child: Text(
                                      "join",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xFF0D47A1),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Activity",
                      key: keyButton5,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Activites(),
           listActivities(usersdata['UID'])
            ]),
          ),
        ));
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: keyButton,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome to Doctor Avail ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "FInd the nearest hospitial close to you.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      '1' + intoArr[0].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '2' + intoArr[1].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '3' + intoArr[2].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

//                  Padding(
//                    padding: const EdgeInsets.all(1.0),
//                    child: ListView.builder(itemCount: intoArr.length,
//                      itemBuilder: (context, index) {
//                        final item = intoArr[index];
//
//                        return ListTile(
//                          title: Text(item.toString(),  style: TextStyle(color: Colors.white),),
//
//                        );
//                      },
//
//                    ),
//                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "247 monitoring, 7 days a week",
      keyTarget: keyButton4,
      contents: [
        ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tracking strategy",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "We offer 247 tracking for our daily users .",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )),
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyButton5,
      contents: [
        ContentTarget(
            align: AlignContent.right,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Daily activities",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "We provide you with a detailed record of where you have been in a single day.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyButton3,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      "https://juststickers.in/wp-content/uploads/2019/01/flutter.png",
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Image Load network",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));
  }



  Widget Pending() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            width: 100,
            child: new FlareActor(
              'images/load.flr',
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: 'loading',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No Activities '),
          )
        ],
      ),
    );
  }

  listActivities(id) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(id)
            .collection('locations')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // ignore: missing_return
          if (snapshot.data == null) {
            return Container(margin: EdgeInsets.all(8.0), child: Pending());
          }
          if (snapshot.hasData && snapshot.data.documents.length == 0) {
            return Pending();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                margin: EdgeInsets.all(8.0),
                child: ContactShimmer(),
              );
            default:
              var items = snapshot.data.documents;

             var filter=items.where((element)=>element['location']['timestamp'].toString().split('T')[0].toString() +' '+'00:00:00.000'.toString()==dateToday.toString()).toList();

             items =filter;

             if(items.length==0) return Pending();



              return new ListView.builder(
                  itemCount: items.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {

           return        FocusedMenuHolder(
                      menuWidth: MediaQuery.of(context).size.width,

                      onPressed: () {

                      },
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(title: Text("Battery:  ${items[index]['battery_level']== null ? items[index]['location']['battery']['level']: items[index]['battery_level']}",style: TextStyle(color: Colors.black),) ,onPressed: (){},),

                        FocusedMenuItem(title: Text("Is_Moving:  ${items[index]['is_moving']== null ? items[index]['location']['is_moving']: items[index]['is_moving']}",style: TextStyle(color: Colors.black),) ,onPressed: (){},),

                      ],
                      child: TimeLine(
                        lat: items[index]['latitude'] == null
                            ? items[index]['location']['coords']['latitude']
                            : items[index]['latitude'],
                        log: items[index]['longitude'] == null
                            ? items[index]['location']['coords']['longitude']
                            : items[index]['longitude'],
                        speed: items[index]['speed'] == null
                            ? items[index]['location']['coords']['speed']
                                .toString()
                            : items[index]['speed'].toString(),
                        time: items[index]['timestamp'] == null
                            ? items[index]['location']['timestamp']
                                .toString()
                                .split('T')[0]
                            : items[index]['timestamp']
                                .toString()
                                .split('T')[0],
                      ),
                    );
                  });
          }
        });
  }

  checkdate(id){

   print(id.split('T')[0].toString()+' '+'00:00:00.000' == dateToday.toString());
//var result= new DateFormat("yyyy-MM-dd").parse(id).toString();
return id.split('T')[0].toString()+' '+'00:00:00.000'==dateToday.toString();
  }

  _init() async {
//    try {
//      if (await FlutterAudioRecorder.hasPermissions) {
//        String customPath = '/flutter_audio_recorder_';
//        io.Directory appDocDirectory;
////        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
//        if (io.Platform.isIOS) {
//          appDocDirectory = await getApplicationDocumentsDirectory();
//        } else {
//          appDocDirectory = await getExternalStorageDirectory();
//        }
//
//        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//        customPath = appDocDirectory.path +
//            customPath +
//            DateTime.now().millisecondsSinceEpoch.toString();
//
//        // .wav <---> AudioFormat.WAV
//        // .mp4 .m4a .aac <---> AudioFormat.AAC
//        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//        _recorder =
//            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);
//
//        await _recorder.initialized;
//        // after initialization
//        var current = await _recorder.current(channel: 0);
//        print(current);
//        // should be "Initialized", if all working fine
//        setState(() {
//          _current = current;
//          _currentStatus = current.status;
//          print(_currentStatus);
//        });
//      } else {
//        Scaffold.of(context).showSnackBar(
//            new SnackBar(content: new Text("You must accept permissions")));
//      }
//    } catch (e) {
//      print(e);
//    }
  }
  _start() async {
//    try {
//      await _recorder.start();
//      var recording = await _recorder.current(channel: 0);
//      setState(() {
//        _current = recording;
//      });
//
//      const tick = const Duration(milliseconds: 50);
//      new Timer.periodic(tick, (Timer t) async {
//        if (_currentStatus == RecordingStatus.Stopped) {
//          t.cancel();
//        }
//
//        var current = await _recorder.current(channel: 0);
//         print(current.status);
//
//        Fluttertoast.showToast(
//            msg:
//            'current',
//            toastLength: Toast.LENGTH_LONG,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.black,
//            textColor: Colors.white,
//            fontSize: 16.0);
//        setState(() {
//          _current = current;
//          _currentStatus = _current.status;
//        });
//      });
//    } catch (e) {
//      print(e);
//    }
  }

  _resume() async {
   // await _recorder.resume();
    setState(() {});
  }

  _pause() async {
   // await _recorder.pause();
    setState(() {});
  }

//  _stop() async {
//    var result = await _recorder.stop();
//    print("Stop recording: ${result.path}");
//    print("Stop recording: ${result.duration}");
//    File file = widget.localFileSystem.file(result.path);
//    print("File length: ${await file.length()}");
//    setState(() {
//      _current = result;
//      _currentStatus = _current.status;
//    });
//  }


}
