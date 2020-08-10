import 'package:ifela/depend.dart';



class PendingContact extends StatefulWidget {
  static const id = '/pending';

  final String uid;
  PendingContact({@required this.uid});
  @override
  _PendingContactState createState() => _PendingContactState();
}

class _PendingContactState extends State<PendingContact> {

  final Firestore _db = Firestore.instance;
  var redzones = [];
  final AuthService service = AuthService();

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending contacts'),
      ),
      body:  information(widget.uid),
    );
  }



  information(id) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('contact')
        .where("peerID", isEqualTo: id.toString())

            .where("status", isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.data == null) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Container(),
            );
          }

          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Container(),
              );
            default:
              print(snapshot.data.documents.length );
           //   DateTime dateTime= snapshot.data.documents[0]['date'].toDate();
              return new ListView.builder(
                itemCount:snapshot.data.documents.length ,

                  itemBuilder: (context,index){

                  final keyArray=snapshot.data.documents[index];
            return Dismissible(
                // ignore: missing_return
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    final bool res =
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to delete ${keyArray['myName']}?"),
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
                                  "Reject",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                                    try{
                                      service.updateStatus(false,keyArray['ID']);
                                      snapshot.data.documents.removeAt(index);

                                      Fluttertoast.showToast(
                                          msg: 'Rejected',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER);
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
                  } else {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            
                            content: Text(
                                "Are you sure you want to add username  ${keyArray['myName']}?"),
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
                                  "Add",
                                  style: TextStyle(color: Colors.green),
                                ),
                                onPressed: () {
                                  // TODO: Delete the item from DB etc..
                                  setState(() {
                          try{
                            service.updateStatus(true,keyArray['ID']);
                            snapshot.data.documents.removeAt(index);

                            Fluttertoast.showToast(
                                msg: 'Approved',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER);
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
                  }
                },
                background: Container(
                  margin: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20.0),
                  color: Colors.redAccent,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  margin: EdgeInsets.only(top: 12),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  color: Colors.greenAccent,
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              onDismissed: (dir){

              },
              key: new Key(keyArray.toString()),

             child:   ChatTile(
            imgUrl: keyArray['myPhoto'],
              name: keyArray['peerName'],
              lastMessage: keyArray['myID'],
              haveunreadmessages: true,
              unreadmessages: 12,
              lastSeenTime: keyArray['peerNumber'],
            )

            );
              });


//              return   Provider.value(
//                // Prohibit parent widget from notifying new value.
//                value: snapshot.data.documents[0],
//                updateShouldNotify: (oldValue, newValue) {},
//                child: TabPage(),
//              );
          }
        },
      ),
    );
  }
}
