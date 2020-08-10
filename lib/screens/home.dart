import 'package:ifela/depend.dart';

class HomePage extends StatefulWidget {
  static const id = '/home';

  final bool ids;

  HomePage({@required this.ids});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SweetSheet _sweetSheet = SweetSheet();
  final LocalStorage storage = new LocalStorage('intro');
  var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  static final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: WillPopScope(
          onWillPop: () => goBack(), child: userManager(user?.uid)),
    );
  }
//  Future<void> _initSquarePayment() async {
//    await InAppPayments.setSquareApplicationId('sandbox-sq0idb-lj3LFh-IQDNMXBS5aeTW2g');
//  }
// function to manage when the user click the back arrow button
  goBack() {
    return _sweetSheet.show(
      context: context,
      title: Text("Are you sure?",
          style: TextStyle(color: Colors.white, fontSize: 14)),
      description: Text(
        "Are you certain that you want to sign out?",
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      color: CustomSheetColor(main: Colors.black, accent: Colors.black87),
      icon: Icons.person_pin,
      positive: SweetSheetAction(
        onPressed: () {
          AuthService().signOut();
          Navigator.of(context).pushNamed(AuthPage.id);
        },
        title: 'Log out',
      ),
      negative: SweetSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        title: 'Cancle',
      ),
    );
  }

//manage users information
  userManager(id) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where("UID", isEqualTo: id.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: LoadingShimmer(),
            );
          }
          if (snapshot.hasData && snapshot.data.documents.length == 0) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: RaisedButton(
                  onPressed: () {
                    storage.setItem('value', true);
                    Navigator.of(context)
                        .pushReplacementNamed(EditProfile.id, arguments: true);

//
//                    AuthService().signOut();
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => AuthPage()));
                  },
                  child: Text('Create Profile'),
                  textColor: Colors.white,
                  elevation: 7.0,
                  color: Color(0xFF0D47A1),
                ),
              ),
            );
          }
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                margin: EdgeInsets.all(8.0),
                child: LoadingShimmer(),
              );
            default:
              DateTime dateTime = snapshot.data.documents[0]['date'].toDate();
              var date = DateTime.now().difference(dateTime).inDays;

              //snapshot.data.documents[0]['date']

              if (date >= 30) {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your payment has been due for about ${date} days',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text('Payment'),
                            onPressed: (){

                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Provider<DocumentSnapshot>(
                    create: (context) => snapshot.data.documents[0],
                    child: TabPage());
              }
          }
        },
      ),
    );
  }
  //skeleton widget





}
