import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _mail;
  TextEditingController _sifre;
  TextEditingController _isim;
  TextEditingController _soyisim;
  String _kullaniciemailAdress, _kullanicisifre, _kullaniciad, _kullanicisoyad;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
          ),
          SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
              child: AutoSizeText(
                "Kayıt Ol",
                style: TextStyle(
                    color: Colors.white, fontSize: screenHeight * 0.035),
                minFontSize: 15,
                maxFontSize: 30,
                maxLines: 2,
                stepGranularity: 1,
              ),
            ),
          ),
          SizedBox(
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0, 0),
                child: Row(
                  children: [
                    AutoSizeText(
                      "Zaten Bir Hesaba Sahip misin?",
                      style: TextStyle(
                          fontSize: screenHeight * 0.022, color: Colors.white),
                      maxFontSize: 14,
                    ),
                    GestureDetector(
                      child: AutoSizeText(
                        " Hemen Giriş Yap!",
                        style: TextStyle(
                            fontSize: screenHeight * 0.022, color: Colors.blue),
                        maxFontSize: 14,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    )
                  ],
                ),
              )),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.grey,
                      ),
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.1,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.grey),
                          controller: _isim,
                          validator: (String girilenisim) {
                            if (girilenisim == "") {
                              return "İsim Alanı Boş Olamaz";
                            } else
                              return null;
                          },
                          onSaved: (isimdeger) => _kullaniciad = isimdeger,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "İsim",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            hoverColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.grey,
                      ),
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.1,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.grey),
                          controller: _soyisim,
                          validator: (String girilensoyisim) {
                            if (girilensoyisim == "") {
                              return "Soyad Alanı Boş Olamaz";
                            } else
                              return null;
                          },
                          onSaved: (soyaddeger) => _kullaniciad = soyaddeger,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Soyad",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            hoverColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.grey,
                      ),
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.1,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.grey),
                          controller: _mail,
                          validator: (String girilenmail) {
                            if (girilenmail == "") {
                              return "Mail Alanı Boş Bırakılamaz";
                            } else if (!girilenmail.contains("@")) {
                              return "Geçersiz Mail Adresi Girdiniz";
                            } else
                              return null;
                          },
                          onSaved: (maildeger) =>
                              _kullaniciemailAdress = maildeger,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            labelText: "Mail",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            hoverColor: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.grey,
                      ),
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.1,
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.grey),
                          controller: _sifre,
                          validator: (sifredeger) {
                            if (sifredeger == "") {
                              return "Şifre Alanı Boş Bırakılamaz";
                            } else if (sifredeger.length < 6) {
                              return "Şifre 6 Karekterden Az Olamaz";
                            } else
                              return null;
                          },
                          onSaved: (sifredeger) => _kullanicisifre = sifredeger,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            labelText: "Şifre",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () {
                          _emailSifreRegister();                          
                        },
                        //child: Text("Kayıt Ol",style: TextStyle(fontSize: 18),),
                        child: AutoSizeText(
                          "Kayıt Ol",
                          maxFontSize: 14,
                          minFontSize: 12,
                          stepGranularity: 1,
                          maxLines: 2,
                        ),
                        color: Colors.blue,
                        highlightColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _emailSifreRegister() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      debugPrint("mail $_kullaniciemailAdress şifre $_kullanicisifre");
      _auth
          .createUserWithEmailAndPassword(
              email: _kullaniciemailAdress, password: _kullanicisifre)
          .then((kayitolmuskullanci) {
        kayitolmuskullanci.user.sendEmailVerification().then((deger) {
          veriEkle();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Kayıt Başarılı Mail Adresinizi Kontrol Ediniz."),
            duration: Duration(seconds: 5),
          ));
        }).catchError((hata) {
          debugPrint("Onay Maili Gönderilirken Hata.");
        });
      }).catchError((hata) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Bu Mail Adresi Kullanımda."),
          duration: Duration(seconds: 5),
        ));
      });
    }
  }

  void veriEkle() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _firestore.collection("users").doc(_kullaniciemailAdress).set({
        "mail": _kullaniciemailAdress,
      }).then((value) {
        debugPrint("veri eklendi");
      }).catchError((e) {
        debugPrint("veri eklenirken hata" + e.toString());
      });
    }
  }
}
