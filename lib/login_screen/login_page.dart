import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'user_repository.dart';
import 'package:provider/provider.dart';
import 'sifremi_unuttum.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _email;
  TextEditingController _sifre;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController(text: "");
    _sifre = TextEditingController(text: "");    
  }

  @override
    Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      final userRepo = Provider.of<UserRepository>(context);
      return Scaffold(
        key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        SizedBox(
          height: screenHeight * 0.1,
        ),
        SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0, 0),
            child: Text(
              "Giriş Yap",
              style: TextStyle(
                  color: Colors.white, fontSize: screenHeight * 0.035),
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
                      "Bir Hesaba Sahip Değil Misin?",
                      style: TextStyle(
                        fontSize: screenHeight * 0.022, color: Colors.white),
                      maxFontSize: 14,
                    ),
                  GestureDetector(
                      child:  AutoSizeText(
                        " Hemen Kayıt Ol!",
                        style: TextStyle(
                            fontSize: screenHeight * 0.022, color: Colors.blue),
                        maxFontSize: 14,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      })
                ],
              ),
            )),
        SizedBox(
          height: screenHeight * 0.10,
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
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.grey),
                        validator: (String girilenmail) {
                          if (girilenmail == "") {
                            return "Mail Alanı Boş Bırakılamaz";
                          } else if (!girilenmail.contains("@")) {
                            return "Geçersiz Mail Adresi Girdiniz";
                          } else
                            return null;
                        },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: GestureDetector(
                        child: Text("Şifremi Unuttum"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SifremiUnuttumPage()));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.05,
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (!await userRepo.signIn(
                              _email.text, _sifre.text)) {
                            
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content: new Text("Mail/Şifre Hatalı")));
                          } else if (userRepo.user.emailVerified == false) {
                            
                            debugPrint(userRepo.user.emailVerified.toString());
                           _scaffoldKey.currentState.showSnackBar(
                                new SnackBar(content: new Text("Mailinizi Kontrol Ediniz.")));
                          } else if (userRepo.user.emailVerified == true){               
                            
                            _scaffoldKey.currentState.showSnackBar(
                                new SnackBar(content: new Text("Giriş Başarılı")));
                          }
                        }                        
                      },
                      color: Colors.blue,
                      highlightColor: Colors.grey,
                      child: Text("Giriş Yap"),
                    ),
                  ),
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
                      onPressed: () async {
                        userRepo.signInWithGoogle();
                      },
                      color: Colors.yellow,
                      highlightColor: Colors.grey,
                      child: Text("Gmail İle Giriş Yap"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
