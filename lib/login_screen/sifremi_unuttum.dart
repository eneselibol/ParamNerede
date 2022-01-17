import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SifremiUnuttumPage extends StatefulWidget {
  @override
  _SifremiUnuttumPageState createState() => _SifremiUnuttumPageState();
}

class _SifremiUnuttumPageState extends State<SifremiUnuttumPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _mail;
  String _kullanicimail;
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
                "Şifremi Unuttum",
                style: TextStyle(fontSize: 25, color: Colors.white),
                minFontSize: 15,
                maxFontSize: 30,
                maxLines: 2,
                stepGranularity: 1,
              ),
            ),
          ),
          SizedBox(height: screenHeight*0.10,),
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
                          controller: _mail,
                          validator: (String girilenmail) {
                            if (girilenmail == "") {
                              return "Mail Alanı Boş Bırakılamaz";
                            } else if (!girilenmail.contains("@")) {
                              return "Geçersiz Mail Adresi Girdiniz";
                            } else
                              return null;
                          },
                          onSaved: (maildeger) => _kullanicimail = maildeger,
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
                  SizedBox(height: screenHeight*0.02,),
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
                        onPressed: _forgotpassword,
                        //child: Text("Kayıt Ol",style: TextStyle(fontSize: 18),),
                        child: AutoSizeText(
                          "Mail Gönder",
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

  void _forgotpassword() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _auth.sendPasswordResetEmail(email: _kullanicimail).then((value) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Sıfırlama Maili Gönderildi."),
          duration: Duration(seconds: 5),
        ));
      }).catchError((e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Sıfırlama Maili Gönderilirken Hata Oluştu."),
          duration: Duration(seconds: 5),
        ));
      });
    }
  }
}
