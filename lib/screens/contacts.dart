



import 'package:ifela/depend.dart';





class Contact extends StatefulWidget {

  static const id = '/contact';
  final DocumentSnapshot usersdata;
  final FirebaseUser user;

  Contact({this.usersdata,this.user});
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {


  final myController = TextEditingController();
  final _mobileFormatter = NumberTextInputFormatter();
  final SweetSheet _sweetSheet = SweetSheet();
  ProgressDialog pr;
  Key _k1 = new GlobalKey();
  String phoneNo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);
    var usersdata = widget.usersdata;
    pr.style(
        message: ' Creating contact...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'addPhone')
      ..timeout = const Duration(seconds: 30);
    var user = widget.user;

    phoneNo = user?.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff171719),
        title: Text('Add contact '),
      ),
      body:   GestureDetector(

        onTap: () {
          // call this method here to hide soft keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 45.0),
                    child: AutoSizeText(
                  'Would you like to add a contact?.This contact must be already  registerd on the Doctor Avail platform.',
                      style: TextStyle(color: Colors.white),

                    ),
                  ),
                  SizedBox(height: 24.0),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    key: _k1,
                    controller: myController,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly,
                      _mobileFormatter,
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Contact Mobile Number eg(+234 xxxxx)',
                      contentPadding: EdgeInsets.all(10.0),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.white70, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black, width: 1.0),
                      ),
                    ),

                  ),
                  SizedBox(height: 24.0),
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());

//                      var snackBar = new SnackBar(
//                          content: new Text('Sorry Email cannot be empty'));
                      if (myController.value.text == '') {
                        _sweetSheet.show(
                          context: context,
                          title: Text("hoops..",
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                          description: Text(
                            'Mobile Number Required'.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          color: CustomSheetColor(
                              main: Colors.black, accent: Colors.black87),
                          icon: Icons.bubble_chart,
                          positive: SweetSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            title: 'close',
                          ),
                        );
                      } else if (



                      myController.value.text
                          .toString()
                          .trim()
                          .replaceAll(' ', '') ==
                          phoneNo) {
                        _sweetSheet.show(
                          context: context,
                          title: Text("hoops..",
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                          description: Text(
                            'You can\'t add yourself as a contact person'
                                .toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          color: CustomSheetColor(
                              main: Colors.black, accent: Colors.black87),
                          icon: Icons.bubble_chart,
                          positive: SweetSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            title: 'close',
                          ),
                        );
                      } else {
//                            await DataConnectionChecker().hasConnection?
                        await pr.show();

                        try {
                          final HttpsCallableResult result = await callable.call(
                            <String, dynamic>{
                              'phone': myController.value.text
                                  .toString()
                                  .trim()
                                  .replaceAll(' ', ''),
                              'UID': user?.uid.toString(),
                              'name': usersdata['name'],
                              'photo': usersdata['photo'],
                              'number': usersdata['phone_number']
                            },
                          );
                          await pr.hide();
                          print(result.data);
                          Fluttertoast.showToast(
                              msg: result.data,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER);
                          myController.clear();
                          setState(() {});
                        } on CloudFunctionsException catch (e) {
//                          print('caught firebase functions exception');
//                          print(e.code);
//                          print(e.message);
//                          print(e.details);
                          await pr.hide();
                          Fluttertoast.showToast(msg: e.toString());
                        } catch (e) {
                          //   print('caught generic exception');
                          await pr.hide();
                          print(e.toString());
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        color:Color(0xFF0D47A1),
                        constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          'Add Contact',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )),
      ),
    );
  }
}
