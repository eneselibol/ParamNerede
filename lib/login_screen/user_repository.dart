import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
enum UserDurumu { Idle, OturumAcilmamis, OturumAciliyor, OturumAcik}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  UserDurumu _durum = UserDurumu.OturumAcilmamis;
  GoogleSignIn _googleSignIn;

  User get user => this._user;
  set user(User value) => this._user = value;

  UserDurumu get durum => this._durum;
  set durum(UserDurumu value) => this._durum = value;

  UserRepository() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }
 
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signInWithGoogle() async {
    try {
      _durum = UserDurumu.OturumAciliyor;
      debugPrint("google açılıyor");
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await _auth.signInWithCredential(credential);      
      _firestore.collection("users").doc(googleUser.email).set({
        "mail":googleUser.email,
      }).then((value) {
        debugPrint("google veri eklendi");
      }).catchError((e) {
        debugPrint("google veri eklenirken hata" + e.toString());
      });
      debugPrint("google açıldı");
      return true;
    } catch (e) {
      debugPrint(e);
      _durum = UserDurumu.OturumAcilmamis;
      debugPrint("google açılamadı");
      return false;
    }
  }

  Future<bool> signIn(String email, String sifre) async {
    try {
      _durum = UserDurumu.OturumAciliyor;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: sifre);
      return true;
    } catch (e) {
      _durum = UserDurumu.OturumAcilmamis;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _durum = UserDurumu.OturumAcilmamis;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _durum = UserDurumu.OturumAcilmamis;
    } else {
      _user = user;
      if(user.emailVerified==true){
        _durum = UserDurumu.OturumAcik;
      }
      
    }
    notifyListeners();
  }
}
