import 'package:flutter/cupertino.dart';

import 'package:ifela/depend.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:rxdart/rxdart.dart';

class Contacts extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Contacts> {
  final myController = TextEditingController();
  final _mobileFormatter = NumberTextInputFormatter();
  final SweetSheet _sweetSheet = SweetSheet();
  ProgressDialog pr;
  Key _k1 = new GlobalKey();
  String phoneNo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService service = AuthService();
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
//    var users = Provider.of<FirebaseUser>(context);
//
//    print(users);
//    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    var usersdata = Provider.of<DocumentSnapshot>(context);


    var user = Provider.of<FirebaseUser>(context);

    phoneNo = user?.phoneNumber;
    getData(user?.uid);
    return Scaffold(

      key: _formKey,
       resizeToAvoidBottomPadding: true,
       resizeToAvoidBottomInset: false,
       backgroundColor: Color(0xff171719),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  Text(
                    "Contacts",
                    style: kHeadingextStyle,
                  ),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFF0D47A1),
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Contact(
                                        user: user,
                                        usersdata: usersdata,
                                      )));
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),

            /// now stories
            SizedBox(
              height: 30,
            ),

            /// CHats
            ///
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "All Contacts",
                              style: kSubtitleTextSyule,
                            ),
                            Spacer(),

                          ],
                        ),
                      ),
                      Expanded(
                        child: myContacts(user?.uid),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Stream<List<QuerySnapshot>> getData(id) {
    Stream stream1 = Firestore.instance
        .collection('contact')
        .where('peerID', isEqualTo: id)
        .where("status", isEqualTo: true)
        .snapshots();
    Stream stream2 = Firestore.instance
        .collection('contact')
        .where('myID', isEqualTo: id)
        .where("status", isEqualTo: true)
        .snapshots();
    return CombineLatestStream.list([stream1, stream2]);
  }

  myContacts(id) {
    return Container(
        child: StreamBuilder(
            stream: getData(id),
            builder: (BuildContext context,
                AsyncSnapshot<List<QuerySnapshot>> snapshot1) {
              if (snapshot1.data == null) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: ContactShimmer(),
                );
              } else if (!snapshot1.hasData) {
                return const Center(
                  child: Text(
                    "No contact yet",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                );
              } else {
                switch (snapshot1.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      child: ContactShimmer(),
                    );

                  default:
                    List<QuerySnapshot> querySnapshotData = snapshot1.data;

                    //copy document snapshots from second stream to first so querySnapshotData[0].documents will have all documents from both query snapshots
//                    querySnapshotData[0]
//                        .documents
//                        .addAll(querySnapshotData[1].documents);
                    var arrays = [];
                    querySnapshotData[1].documents.forEach((element) {
                      arrays.add({
                        'name': element.data['peerName'],
                        'peerID': element.data['peerID'],
                        'photo': element.data['peerPhoto'],
                        'phone': element.data['peerNumber'],
                        'ID': element.data['ID'],
                      });
                    });
                    querySnapshotData[0].documents.forEach((element) {
                      arrays.add({
                        'name': element.data['myName'],
                        'peerID': element.data['myID'],
                        'photo': element.data['myPhoto'],
                        'phone': element.data['myNumber'],
                        'ID': element.data['ID'],
                      });
                    });

                    if (arrays.length == 0) {
                      return const Center(
                        child: Text(
                          "You yet to add contact",
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                      );
                    } else {
                      return new ListView.builder(
                          itemCount: arrays.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: new Key(arrays.toString()),

                              background: Container(
                                margin: EdgeInsets.only(top: 12),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20.0),
                                color: Colors.redAccent,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),

                              confirmDismiss: (dir) async {

                                final bool res =
                                    await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Are you sure you want to delete this user"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              // TODO: Delete the item from DB etc..
                                              setState(() {
                                                try{
                                                  service.updateStatus(false,arrays[index]['ID']);


                                                  Fluttertoast.showToast(
                                                      msg: 'Rejected',
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.CENTER);
                                                  arrays.removeAt(index);
                                                }catch(err){
                                                  Fluttertoast.showToast(
                                                      msg: err.toString(),
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.CENTER);
                                                }

                                                //itemsList.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                return res;

                              },
                              child: ChatTile(
                                imgUrl: arrays[index]['photo'],
                                name: arrays[index]['name'],
                                lastMessage: arrays[index]['peerID'],
                                haveunreadmessages: true,
                                unreadmessages: 12,
                                lastSeenTime: arrays[index]['phone'],
                              ),
                            );
                          });
                    }
                }
              }
            }));
  }


}


