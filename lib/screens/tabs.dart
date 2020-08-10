import 'dart:ui';

import 'package:ifela/depend.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  int _page = 0;
  final _pageOptions = [HomeTab(), Contacts(), Settings()];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      bottomNavigationBar: FlashyTabBar(
//          selectedIndex: _page,
//          showElevation: true,
//          onItemSelected: (index) {
//            setState(() {
//              _page = index;
//            });
//          },
//          items: [
//            FlashyTabBarItem(
//                icon: Icon(
//                  Icons.home,
//                  color: Colors.grey,
//                ),
//                title: Text("Home", style: TextStyle(color: Colors.blue))),
//            //    BottomNavigationBarItem(icon:Icon(Icons.map),title: Text("")),
//            FlashyTabBarItem(
//                icon: Icon(
//                  Icons.people,
//                  color: Colors.grey,
//                ),
//                title: Text("Contacts", style: TextStyle(color: Colors.blue))),
//
//            FlashyTabBarItem(
//                icon: Icon(
//                  Icons.settings,
//                  color: Colors.grey,
//                ),
//                title: Text("Settings", style: TextStyle(color: Colors.blue))),
//          ]),
//      body:
//          Scaffold(resizeToAvoidBottomPadding: true, body: _pageOptions[_page]),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //these are the screens that will be loaded for every bottom nav item
        children: <Widget>[
          IndexedStack(
            index: _page,
            children: _pageOptions,
          ),
          _buildBottomNavigation()
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() => Align(
        alignment: FractionalOffset.bottomCenter,

        //this is very important, without it the whole screen will be blurred
        child: ClipRect(
          //I'm using BackdropFilter for the blurring effect
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Opacity(
              //you can change the opacity to whatever suits you best
              opacity: 0.8,
              child: BottomNavigationBar(
                selectedItemColor: Colors.blueAccent,
                currentIndex: _page,
                onTap: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                      ),
                      title: Text("Home")),
                  //    BottomNavigationBarItem(icon:Icon(Icons.map),title: Text("")),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.people,
                      ),
                      title: Text("Contacts")),

                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                      ),
                      title: Text("Settings")),
                ],
              ),
            ),
          ),
        ),
      );
}
