import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCreds) {
    return FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    return authCreds;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }



  createProfile(id, url, phone, address, name) async {
    DateTime _now = DateTime.now();
    await _db.collection('users').document(id).setData({
      'UID': id,
      'photo': url,
      'phone_number': phone,
      'address': address,
      'name': name,
      'status': false,
      'target': false,
      'token': null,
      'date': _now,
      'adate': _now.millisecond
    });
  }


  updateProfile(value,id) async {
    await _db.collection('users').document(id).setData(value,merge: true);
  }

  updateStatus(bool,id) async{

    if(bool){
      await _db.collection('contact').document(id).setData({
        'status':bool,
      },merge: true);
    }else{

    await _db.collection('contact').document(id).delete();
    }



  }
}
