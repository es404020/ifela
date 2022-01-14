import 'package:ifela/depend.dart';

class EditProfile extends StatefulWidget {
  static const id = '/edit';

  final bool ids;

  EditProfile({@required this.ids});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _imageFile = null;

  String fullName;
  String address;
  String uid;
  String phoneNo;
  ProgressDialog pr;
  bool start = false;

  final SweetSheet _sweetSheet = SweetSheet();

  var urls;
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);

    pr.style(
        message: 'Creating Profile...',
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
    var user = Provider.of<FirebaseUser>(context);
    uid = user?.uid;
    phoneNo = user?.phoneNumber;
    return Scaffold(
      appBar: AppBar(

        title: widget.ids
            ? Text(
                "New Profile",
                style: TextStyle(fontSize: 18.0),
              )
            : Text(
                "Edit profile",
                style: TextStyle(fontSize: 18.0),
              ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => widget.ids
              ? Navigator.pushReplacementNamed(context, HomePage.id)
              : Navigator.pushReplacementNamed(context, HomePage.id),
        ),
        centerTitle: true,

        // leading: IconButton(onPressed: _onClickHome, icon: Icon(Icons.home, color: Colors.black)),

        brightness: Brightness.dark,
      ),
      body: WillPopScope(
        onWillPop: () => widget.ids
            ? Navigator.of(context).pushNamed(HomePage.id, arguments: false)
            : Navigator.of(context).pushNamed(HomePage.id, arguments: false),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _imageFile == null
                          ? CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey,
                              // backgroundImage: AssetImage('images/protocoder.png'),
                            )
                          : CircleAvatar(
                              radius: 80,
                              child: ClipOval(
                                child: Image.file(
                                  _imageFile,
                                  fit: BoxFit.fill,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
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
//                    firbaseFileUpload();

                      if (fullName == null || address == null) {
                        generalError('Incomplete information');
                      } else if (_imageFile == null) {
                        generalError('You need to upload image');
                      } else {
                        await pr.show();
                        print('he');
                        firbaseFileUpload();
                      }
                    },
                    child: Text('Create Profile'),
                    textColor: Colors.white,
                    elevation: 7.0,
                    color: Color(0xFF0D47A1),
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

  //image croping to cut and resize

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

  //pick image

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      _cropImage();
    });
  }

//clear image
  void _clear() {
    setState(() => _imageFile = null);
  }

//upload image to firebase

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

  //text field username
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
          hintText: "Full Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0))),
    );
  }

  //text addressField

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
          hintText: "Address",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0))),
    );
  }

  //fileUpload
  firbaseFileUpload() async {
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://eagleeye-dev.appspot.com');
    String filePath = '${randomAlphaNumeric(10)}.png';
    StorageUploadTask _uploadTask;
    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

    try {
      String downloadURL =
          (await (await _uploadTask.onComplete).ref.getDownloadURL());

      createProfile(downloadURL);
    } catch (err) {
      await pr.hide();

      generalError(err);
    }
  }

  //createProfile
  createProfile(url) {
    return AuthService()
        .createProfile(uid, url, phoneNo, address, fullName)
        .then((res) async => {
              await pr.hide(),
              success(),
              Navigator.of(context)
                  .pushReplacementNamed(HomePage.id, arguments: true),
            })
        .catchError((err) async => {await pr.hide(), generalError(err)});
  }
  //generalError
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
  //success
  success() {
    Fluttertoast.showToast(
        msg: 'Congratulation profile was created successfully.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
