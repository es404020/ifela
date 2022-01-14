import 'package:ifela/depend.dart';

class AuthPage extends StatefulWidget {
  static const id = '/';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  final SweetSheet _sweetSheet = SweetSheet();
  String phoneNo;
  String smsCode;
  String verificationID;
  bool _saving = false;
  int index = 0;
  bool codeSent = false;
  List<String> myText = [
    'A modern way to stay safe ',
    '... now where the code'
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  void changeText() {
    setState(() {
      index++;
      if (index == myText.length) index = 0;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            exit(0);
          },
          child: ModalProgressHUD(
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShaderMask(
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
                            height: MediaQuery.of(context).size.height * 0.5,
                            child:

                            Image.asset('images/download.jpeg', alignment: Alignment.center,fit: BoxFit.cover,)

//                            FlareActor(
//                              'images/ifela.flr',
//                              alignment: Alignment.center,
//                              fit: BoxFit.cover,
//                              animation: 'start',
//                            )
                        ),
                      ),
                      Container(
                          margin:
                              EdgeInsets.only(top: 10, left: 30, bottom: 20),
                          child: Text(
                            'Doctor Avail',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: AutoSizeText(
                              'Quest medical help at anytime and at any given  place  .',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => {
                            _controller.animateToPage(1,
                                duration: Duration(milliseconds: 1200),
                                curve: Curves.ease)
                          },
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            color: Color(0xFF0D47A1),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container()
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShaderMask(
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
                            height: MediaQuery.of(context).size.height * 0.5,
                            child:
                            //Image.asset('images/police.jpg', alignment: Alignment.center,fit: BoxFit.cover,)
                            FlareActor(
                              'images/ifela.flr',
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              animation: 'start',
                            )


//                            FlareActor(
//                              'images/ifela.flr',
//                              alignment: Alignment.center,
//                              fit: BoxFit.cover,
//                              animation: 'start',
//                            )
                        ),
                      ),
                      Container(
                          margin:
                          EdgeInsets.only(top: 10, left: 30, bottom: 20),
                          child: Text(
                            'Advance Geolocation',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: AutoSizeText(
                              'We provide geolocation which enable you find the nearest health care center close to you ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => {
                            _controller.animateToPage(2,
                                duration: Duration(milliseconds: 1200),
                                curve: Curves.ease)
                          },
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            color: Color(0xFF0D47A1),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container()
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ShaderMask(
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
                            height: MediaQuery.of(context).size.height * 0.5,
                            child:Image.asset('images/rape.jpg', alignment: Alignment.center,fit: BoxFit.cover,)


//                            FlareActor(
//                              'images/ifela.flr',
//                              alignment: Alignment.center,
//                              fit: BoxFit.cover,
//                              animation: 'start',
//                            )
                        ),
                      ),
                      Container(
                          margin:
                          EdgeInsets.only(top: 10, left: 30, bottom: 20),
                          child: Text(
                            'Meet medical expert',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          )),
                      Expanded(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: AutoSizeText(
                              'We provide medical consultation through video call and chat',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => {
                            _controller.animateToPage(3,
                                duration: Duration(milliseconds: 1200),
                                curve: Curves.ease)
                          },
                          child: Container(
                            height: 100.0,
                            width: double.infinity,
                            color: Color(0xFF0D47A1),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: Text(
                                  'Get started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container()
                    ],
                  ),
                  Center(
                      child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 45.0),
                          child: Text(
                            codeSent
                                ? myText[index + 1].toString()
                                : myText[index].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        codeSent
                            ? PinCodeTextField(
                                length: 6,
                                backgroundColor: Color(0xff171719),
                                textStyle: TextStyle(color: Colors.white),
                                obsecureText: false,
                                animationType: AnimationType.fade,
                                shape: PinCodeFieldShape.box,
                                animationDuration: Duration(milliseconds: 300),
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                onChanged: (value) {
                                  setState(() {
                                    this.smsCode = value;
                                  });
                                },
                              )
                            : TextField(
                                style: TextStyle(color: Colors.white),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                  _mobileFormatter,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number eg(+234 xxxxx)',
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
                                onChanged: (value) {
                                  this.phoneNo = value;
                                },
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              setState(() {
                                if (codeSent) {
                                  AuthService()
                                      .signIn(AuthService().signInWithOTP(
                                          smsCode, verificationID))
                                      .then((res) => setParams(res.user.uid))
                                      .catchError((handleError) => {
                                            _sweetSheet.show(
                                              context: context,
                                              title: Text("hoops..",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                              description: Text(
                                                handleError.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              color: CustomSheetColor(
                                                  main: Colors.black,
                                                  accent: Colors.black87),
                                              icon: Icons.bubble_chart,
                                              positive: SweetSheetAction(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                title: 'close',
                                              ),
                                            )
                                          });
                                } else {
                                  print(phoneNo);
                                  if (phoneNo == null) {
                                    _sweetSheet.show(
                                      context: context,
                                      title: Text("hoops..",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                      description: Text(
                                        'Phone number is required',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      color: CustomSheetColor(
                                          main: Colors.black,
                                          accent: Colors.black87),
                                      icon: Icons.bubble_chart,
                                      positive: SweetSheetAction(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        title: 'close',
                                      ),
                                    );
                                  } else {
                                    verifyPhone(phoneNo);
                                  }
                                }

                                // codeSent ?  AuthService().signIn(AuthService().signInWithOTP(smsCode, verificationID)):verifyPhone(phoneNo);
                              });
                            },
                            child: codeSent
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Verify'),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Login'),
                                  ),
                            textColor: Colors.white,
                            elevation: 7.0,
                            color: Color(0xFF0D47A1),
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              inAsyncCall: _saving),
        ));
  }

//setting parameter
  setParams(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'phoneNo', phoneNo.toString().trim().replaceAll(' ', ''));
    await prefs.setString('UID', id);
    // Navigator.of(context).pushNamed(HomePage.id,arguments: false);

    Navigator.push(
        context,
        Routers.sharedAxis(
            () => HomePage(
                  ids: false,
                ),
            SharedAxisTransitionType.scaled));
  }

//phone_number verification
  Future<void> verifyPhone(phoneNo) async {
    print(phoneNo.toString().trim().replaceAll(' ', ''));
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');

      _sweetSheet.show(
        context: context,
        title: Text("hoops..",
            style: TextStyle(color: Colors.white, fontSize: 14)),
        description: Text(
          authException.message.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        color: CustomSheetColor(main: Colors.black, accent: Colors.black87),
        icon: Icons.bubble_chart,
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'try again',
        ),
      );
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationID = verId;
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo.toString().trim().replaceAll(' ', ''),
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
    } catch (err) {
      _sweetSheet.show(
        context: context,
        title: Text("hoops..",
            style: TextStyle(color: Colors.white, fontSize: 14)),
        description: Text(
          err.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        color: CustomSheetColor(main: Colors.black, accent: Colors.black87),
        icon: Icons.bubble_chart,
        positive: SweetSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'try again',
        ),
      );
    }
  }
}

//number formatter
final _mobileFormatter = NumberTextInputFormatter();
