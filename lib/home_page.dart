import 'package:flutter/material.dart';
import 'login_screen/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, UserRepository userRepo, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color.fromRGBO(70, 70, 70, 1),
        ),
        drawer: Drawer(
          child: Container(
            color: Color.fromRGBO(70, 70, 70, 0.9),
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(bottom: 0),
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(70, 70, 70, 1)),
                    accountName: Text(""),
                    accountEmail: Text(
                      userRepo.user.email,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: [
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Anasayfa",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Kartlarım",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Döviz Kuru",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Altın Kuru",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Yatırım",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: ListTile(
                            title: Text(
                              "Hesap Makinesi",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Container(
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                userRepo.signOut();
                              },
                              child: Text(
                                "Çıkış yap",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(children: [
          Container(
            //color: Colors.white,
            width: screenWidth,
            height: screenHeight * 0.3,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.white, width: 1.0),
                  bottom: BorderSide(color: Colors.white, width: 1.0)),
            ),
            //color: Colors.red,
            width: screenWidth, height: screenHeight * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Kategori",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Tutar",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Harcama",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Açıklama",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
              ],
            ),
          ),
          Container(
            //color: Colors.blue,
            width: screenWidth, height: screenHeight * 0.46,
            child: Column(
              children: [
                
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
