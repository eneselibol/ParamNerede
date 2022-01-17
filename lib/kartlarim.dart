import 'package:flutter/material.dart';
import 'package:paramnerede_app/sqflite_islemleri.dart';
import 'package:provider/provider.dart';

import 'doviz/altinkurlari.dart';
import 'doviz/dovizkurlari.dart';
import 'login_screen/user_repository.dart';

class Kartlarim extends StatefulWidget {
  const Kartlarim({Key key}) : super(key: key);

  @override
  _KartlarimState createState() => _KartlarimState();
}

class _KartlarimState extends State<Kartlarim> {
  var _formKeyKart = GlobalKey<FormState>();
  String kartIsmi = "";
  int kartBakiye;
  String kartW;
  int bakiyeW;
  List<String> kartIsimleri;
  List<int> kartBakiyeleri;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kartIsimleri = List<String>();
    kartBakiyeleri = List<int>();
  }

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
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color.fromRGBO(80, 80, 80, 0.9),
                onPressed: () {
                  kartEkleDialog(context);
                },
                child: Icon(Icons.add),
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
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(70, 70, 70, 1)),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SqfliteIslemleri()));
                                },
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Kartlarim()));
                                },
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DovizKurlari()));
                                },
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AltinKurlari()));
                                },
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Container(
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
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
              body: Column(
                children: [SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Kart Adı",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      Text(
                        "Kart Bakiyesi",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      SizedBox(
                        width: screenWidth * 0.03,
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: kartIsimleri.length,
                      itemBuilder: (context, index) {
                        return kartIsimleri.isEmpty
                            ? Container()
                            : Container(
                                margin: EdgeInsets.all(8.0),
                                height: screenHeight * 0.09,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8)),
                                //  color: Colors.pink,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        child: Center(
                                            child: Text(
                                      kartIsimleri[index],
                                      style: TextStyle(color: Colors.white70),
                                    ))),
                                    Container(
                                        child: Center(
                                            child: Text(
                                                kartBakiyeleri[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white70)))),
                                    Container(
                                      child: Center(
                                        child: GestureDetector(
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade800,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                kartIsimleri.remove(
                                                    kartIsimleri[index]);
                                                kartBakiyeleri.remove(
                                                    kartBakiyeleri[index]);
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  )
                ],
              ),
            ));
  }

  void kartEkleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Color.fromRGBO(70, 70, 70, 1),
            title: Center(
                child: Text(
              "Kart Ekle",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
            children: [
              Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.07)),
                                labelText: "Kart İsmi",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                            validator: (kartIsmi) {
                              if (kartIsmi.length == 0) {
                                return "Lütfen Kart İsmi Giriniz.";
                              }
                            },
                            onSaved: (yeniDeger) {
                              setState(() {
                                kartIsmi = yeniDeger;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.07)),
                                labelText: "Kart Bakiyesi",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                            validator: (girilenTutar) {
                              if (girilenTutar.length == 0) {
                                return "Lütfen Tutar Giriniz.";
                              }
                            },
                            onSaved: (yeniDeger) {
                              setState(() {
                                kartBakiye = int.parse(yeniDeger);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    key: _formKeyKart,
                  ),
                  ButtonBar(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.orangeAccent,
                        child: Text(
                          "Vazgeç",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (_formKeyKart.currentState.validate()) {
                            _formKeyKart.currentState.save();
                            print(
                                "kart ismi $kartIsmi  kart bakiyesi $kartBakiye");
                            setState(() {
                              kartIsimleri.add(kartIsmi);
                              kartBakiyeleri.add(kartBakiye);
                            });
                          }
                        },
                        color: Colors.green,
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }
}
