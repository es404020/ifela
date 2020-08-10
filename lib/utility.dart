import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import  'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ifela/constants.dart';
import 'package:ifela/depend.dart';
import 'package:shimmer/shimmer.dart';
import 'package:full_screen_image/full_screen_image.dart';
const mainBgColor = Color(0xFFf2f2f2);
const darkColor = Color(0xFF2A0B35);
const midColor = Color(0xFF522349);
const lightColor = Color(0xFFA52C4D);
const darkRedColor = Color(0xFFFA695C);
const lightRedColor = Color(0xFFFD685A);

const purpleGradient = LinearGradient(
  colors: <Color>[darkColor, midColor, lightColor],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const blackGradient = LinearGradient(
  colors: <Color>[Colors.black,  Color(0xff171719), Colors.black],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
const redGradient = LinearGradient(
  colors: <Color>[Colors.blue, Colors.black87],
  stops: [0.0, 1.0],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);


class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('+');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ' ');
      if (newValue.selection.end >= 3) selectionIndex += 1;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String lastMessage;
  final bool haveunreadmessages;
  final int unreadmessages;
  final String lastSeenTime;
  ChatTile(
      {@required this.unreadmessages,
        @required this.haveunreadmessages,
        @required this.lastSeenTime,
        @required this.lastMessage,
        @required this.imgUrl,
        @required this.name});
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 12),
      child:    new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('UID', isEqualTo: lastMessage)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Container(),
            );
          }
          if (snapshot.hasError) return new Container();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Container(),
              );
            default:
            //snapshot.data.documents[0]['UID'].toString()
              var items = snapshot.data?.documents ?? [];
              return  ListTile(
                leading: CircleAvatar(
                  child: FullScreenWidget(
                  backgroundColor: Colors.grey,
                    child: Hero(
                      tag: "customTag",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: items[0].data['photo'],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          height: 60,
                          width: 60,
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                title:  Text(
                  items[0].data['name'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                subtitle:  Text(
                  items[0].data['phone_number'],
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              );

          }
        },
      ),
    );


  }
}

class ListCards extends StatelessWidget {
  final String peerID;
  final String myID;

  ListCards({
    @required this.peerID,
    @required this.myID,
  });
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ImageDialog extends StatelessWidget {
  final String imag;

  ImageDialog({this.imag});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 400,
        child: CachedNetworkImage(
          imageUrl: imag,
          placeholder: (context, url) => CircularProgressIndicator(),
          height: 400,
          width: 200,
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.black38,
            highlightColor: Color(0xff171719),
            enabled: true,
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            baseColor: Colors.black38,
            highlightColor: Color(0xff171719),
            enabled: true,
            child: Container(
              margin: EdgeInsets.all(17),
              height: 70,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Shimmer.fromColors(
              baseColor: Colors.black38,
              highlightColor: Color(0xff171719),
              enabled: true,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 8.0, right: 8.0, top: 2.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 3,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 3,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 3,
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Card(
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 12.0,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          height: 10.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Card(
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 12.0,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          height: 10.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Card(
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 12.0,
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.5,
                                          height: 10.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //Container(height: 120,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 1,
              )),
        ),
      ],
    );
  }
}

class ContactShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 return Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Color(0xff171719),
        enabled: true,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0, left: 8.0, right: 8.0, top: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 12.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 10,
        ));
  }
}

class StoryTile extends StatelessWidget {
  final String imgUrl;
  final String username;
  StoryTile({@required this.imgUrl, @required this.username});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              imgUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            username,
            style: TextStyle(
                color: Color(0xff78778a),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}


class TimeLine extends StatefulWidget {

final double log;
final double lat;
final String speed;
final String time;

TimeLine({@required this.log,@required this.lat,@required this.speed,@required this.time});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {

  String address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _address(widget.log,widget.lat);
  }
  @override
  Widget build(BuildContext context) {
    return Container(


      child: Padding(
        padding: const EdgeInsets.only(top: 0,),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 3,
                    decoration: BoxDecoration(color: Colors.green),
                  ),

                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.8,
                    child: Card(
                      elevation: 10.0,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                             widget.time.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),

                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13  ,bottom: 1),
                              child: AutoSizeText(
                                address==null?'.......':address,
                                style: TextStyle(color: Colors.white),

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Container(height: 120,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  _address(lon,lat) async {
    final coordinates = new Coordinates(lat,lon);

    try {
      var addresses =
      await Geocoder.google('AIzaSyB2YdTgWF1T5TmYdTDPA-3FpkiDoSnpsaU').findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
setState(() {
  address='My location:${first.addressLine},${first.locality},${first.countryName}';
});





//    Fluttertoast.showToast(
//        msg: 'My location:${first.addressLine},${first.locality},${first.countryName}',
//        toastLength: Toast.LENGTH_LONG,
//        gravity: ToastGravity.CENTER,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.black,
//        textColor: Colors.white,
//        fontSize: 16.0);

    } catch (err) {
      print(err);
    }
  }
}
