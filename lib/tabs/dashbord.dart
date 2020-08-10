import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifela/auth.dart';
import 'package:ifela/screens/authpage.dart';
import 'package:ifela/utility.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animations/animations.dart';
const double _fabDimension = 56.0;
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  @override
  Widget build(BuildContext context) {
    var usersdata = Provider.of<DocumentSnapshot>(context);
    return Scaffold(
      backgroundColor: mainBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              _backBgCover(),
              _greetings(usersdata),
              _moodsHolder(context),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  _notificationCard(),
                  SizedBox(
                    height: 20,
                  ),
                  _nextAppointment('Your Recent location', 'view more'),
                  SizedBox(
                    height: 13,
                  ),
                  _appoinmentCard(),
                  SizedBox(
                    height: 14,
                  ),
                  _nextAppointment('Your Connects', 'view more'),
                  _buildConnect(),
                  _buildConnect(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  shimmers() {
    return Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black38,
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

  Positioned _moodsHolder(BuildContext context) {
    return Positioned(
      bottom: -45,
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5.5,
                blurRadius: 5.5,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.thumb_down,
              size: 32,
            ),
            Icon(Icons.thumb_up, size: 32),
            Icon(Icons.thumbs_up_down, size: 32),
            Icon(Icons.vpn_lock, size: 32),
          ],
        ),
      ),
    );
  }

  Container _backBgCover() {
    return Container(
      height: 260.0,
      decoration: BoxDecoration(
        gradient: blackGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned _greetings(value) {
    return Positioned(
      left: 20,
      bottom: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value['name'].toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'How are you feeling save today ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:22.0,right: 0),
            child: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => {_showPopupMenu()},
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Row _nextAppointment(title, more) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Container _appoinmentCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: <Widget>[
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
                radius: 30.0,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 1,
                child: RichText(
                  text: TextSpan(
                      text: 'Lekki\n',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Hello world nigeria',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            color: Colors.grey[200],
            height: 3,
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _iconBuilder(LineAwesomeIcons.check_circle, 'Check In'),
              _iconBuilder(LineAwesomeIcons.map, 'Find'),
              _iconBuilder(LineAwesomeIcons.globe, 'Position'),
              _iconBuilder(LineAwesomeIcons.compass, 'Direction'),
            ],
          )
        ],
      ),
    );
  }

  Container _notificationCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          Icons.calendar_today,
          color: Colors.white,
          size: 18,
        ),
        title: Text(
          'Manage contact',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: OutlineButton(
          //  onPressed: ()=> Navigator.pushNamed(context, Contact.id),
          color: Colors.transparent,
          borderSide: BorderSide(
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            'view Contact',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _iconBuilder(icon, title) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 28, color: Colors.black),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.black),
        )
      ],
    );
  }

  _buildConnect() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 36,
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: 'Lekki\n',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Hello world nigeria',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ]),
                ),
              ],
            )
          ],
        ));
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      //  handleSignOut();
    } else {
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => Settings()));
//    }
    }
  }

  _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 10, 100),
      items: [
        PopupMenuItem<String>(child: InkWell(

            child: const Text('Settings')), value: 'Doge'),
        PopupMenuItem<String>(
            child:GestureDetector(
               onTap: (){
                  AuthService().signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
                },
                child: const Text('Log Out')), value: 'Lion'),
      ],
      elevation: 8.0,
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.results
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return results;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
