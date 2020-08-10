import 'package:ifela/depend.dart';

class UpdateProfile extends StatefulWidget {
//DocumentSnapshot
  static const id = '/update';
  final DocumentSnapshot val;
  UpdateProfile({@required this.val});
  @override
  _UpdateProfileState createState() => _UpdateProfileState(val: val);
}

class _UpdateProfileState extends State<UpdateProfile> {
  final DocumentSnapshot val;

  File _imageFile = null;
  var urls;
  String fullName;
  String address;
  String uid;
  String phoneNo;
  ProgressDialog pr;
  final SweetSheet _sweetSheet = SweetSheet();
  _UpdateProfileState({@required this.val});

  @override
  void initState() {
    super.initState();
    urls = val['photo'];
    fullName = val['name'];
    address = val['address'];
    uid = val['UID'];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);

    pr.style(
        message: 'Profile Updating...',
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
    return Scaffold(
      appBar: GradientAppBar(
        gradient: blackGradient,
        title: Text(
          "Edit profile",
          style: TextStyle(fontSize: 18.0),
        ),

        centerTitle: true,

        // leading: IconButton(onPressed: _onClickHome, icon: Icon(Icons.home, color: Colors.black)),

        brightness: Brightness.dark,
      ),
      body:   GestureDetector(
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _imageFile != null
                          ? CircleAvatar(
                              radius: 80,
                              child: ClipOval(
                                child: Image.file(
                                  _imageFile,
                                  fit: BoxFit.fill,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CachedNetworkImage(
                                height: 160,
                                width: 160,
                                imageUrl: urls,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fill,
                              ),
                            ),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          color: Colors.blue[700],
                          icon: Icon(
                            Icons.camera_alt,
                            size: 40,
                          ),
                          onPressed: () => imageUpload(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  margin: EdgeInsets.all(10),
                  child: nameField(),
                ),
                SizedBox(height: 15.0),
                Container(
                  child: AddressField(),
                  margin: EdgeInsets.all(10),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: RaisedButton(
                    onPressed: () async {

                      await pr.show();
                      if (_imageFile == null) {
                        var value = {
                          'name': fullName == '' ? val['name'] : fullName,
                          'address': address == '' ? val['address'] : address
                        };


                        return AuthService()
                            .updateProfile(value,uid)
                            .then((res) async => {

                          await pr.hide(),

                          success(),
                          Navigator.of(context)
                              .pushReplacementNamed(HomePage.id, arguments: true),

                        })
                            .catchError((err) async => {
                          await pr.hide(),
                          generalError(err)
                        });


                      } else {
                        firbaseFileUpload();
                      }


                    },
                    child: Text('Edit Profile'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color:Color(0xFF0D47A1),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  firbaseFileUpload() {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://eagleeye-dev.appspot.com');
    String filePath = '${randomAlphaNumeric(10)}.png';
    StorageUploadTask _uploadTask;

    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

    _uploadTask.onComplete
        .then((res) async => {
              pr.update(
                progress: 50.0,
                message: "Few more seconds...",
                progressWidget: Container(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator()),
                maxProgress: 100.0,
                progressTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400),
                messageTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600),
              ),

               updateProfile(await res.ref.getDownloadURL())
            })
        .catchError((err) async => {await pr.hide(), generalError(err)});
  }

  updateProfile(url) {

    var value = {
      'name': fullName == '' ? val['name'] : fullName,
      'address': address == '' ? val['address'] : address,
      'photo':url
    };
    return AuthService()
        .updateProfile(value,uid)
        .then((res) async => {

      await pr.hide(),

      success(),
      Navigator.of(context)
          .pushReplacementNamed(HomePage.id, arguments: false),

    })
        .catchError((err) async => {
      await pr.hide(),
      generalError(err)
    });
  }

  nameField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        this.fullName = value;
      },
      obscureText: false,
      decoration: InputDecoration(
          icon: new Icon(Icons.person, color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: fullName,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0))),
    );
  }

  AddressField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      onChanged: (value) {
        this.address = value;
      },
      obscureText: false,
      maxLines: 3,
      minLines: 3,
      decoration: InputDecoration(
          icon: new Icon(Icons.pin_drop, color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: address,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0))),
    );
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Cropper',
            rectHeight: 100.0,
            rectWidth: 100.0)

        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,

        //toolbarColor: Colors.purple,
        //toolbarWidgetColor: Colors.white,
        //toolbarTitle: 'Crop It'
        );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      _cropImage();
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  imageUpload() {
    return _sweetSheet.show(
      context: context,
      description: Text(
        "Pick from gallery or Take a picture",
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      color: CustomSheetColor(main: Colors.black, accent: Colors.black87),
      icon: Icons.camera_alt,
      positive: SweetSheetAction(
        onPressed: () => _pickImage(ImageSource.camera),
        title: 'Camera',
      ),
      negative: SweetSheetAction(
        onPressed: () => _pickImage(ImageSource.gallery),
        title: 'Gallery',
      ),
    );
  }

  generalError(err) {
    _sweetSheet.show(
      context: context,
      title:
          Text("hoops..", style: TextStyle(color: Colors.white, fontSize: 14)),
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

  success() {
    Fluttertoast.showToast(
        msg: 'Proile updated.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
