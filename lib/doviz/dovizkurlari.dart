import 'package:flutter/material.dart';
import 'package:paramnerede_app/doviz/altinkurlari.dart';
import 'package:paramnerede_app/login_screen/user_repository.dart';
import 'package:provider/provider.dart';
import '../kartlarim.dart';
import '../sqflite_islemleri.dart';
import 'kurlar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DovizKurlari extends StatefulWidget {
  const DovizKurlari({Key key}) : super(key: key);

  @override
  _DovizKurlariState createState() => _DovizKurlariState();
}

class _DovizKurlariState extends State<DovizKurlari> {
  Future<Currency> getCurrency() async {
    final baseUrl = "https://finans.truncgil.com/today.json";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception("Veri getirelemedi");
    }
    final convertedResponse = utf8.decode(response.body.runes.toList());
    final myjson = json.decode(convertedResponse);
    return Currency.fromJson(myjson);
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SqfliteIslemleri()));
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
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Kartlarim()));
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
                                    builder: (context) => DovizKurlari()));
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
                                    builder: (context) => AltinKurlari()));
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
        body: FutureBuilder(
          future: getCurrency(),
          builder: (context, AsyncSnapshot<Currency> currency) {
            if (!currency.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(children: [
                Column(
                  children: [
                    Table(
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            child: Text('İsim',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white70)),
                          )),
                          TableCell(
                              child: Container(
                            padding: EdgeInsets.only(
                                left: 55, right: 0, bottom: 10, top: 10),
                            child: Text('Alış',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white70)),
                          )),
                          TableCell(
                              child: Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, bottom: 10, top: 10),
                            child: Text('Satış',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white70)),
                          )),
                        ]),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "USD",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "ABD Doları",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 15, top: 15),
                                child: Text(
                                  currency.data.usd.al,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.usd.sat,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "AUD",
                                                  style:
                                                      TextStyle(fontSize: 18,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Avustralya Doları",
                                                  style:
                                                      TextStyle(fontSize: 12,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.aud.al,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.aud.sat,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "DKK",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Danimarka Kronu",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.dkk.al,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.dkk.sat,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "EUR",
                                                  style:
                                                      TextStyle(fontSize: 18,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Euro",
                                                  style:
                                                      TextStyle(fontSize: 12,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.eur.al,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.eur.sat,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "GBP",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "İngiliz Sterlini",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.gbp.al,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.gbp.sat,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "CHF",
                                                  style:
                                                      TextStyle(fontSize: 18,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "İsviçre Frangı",
                                                  style:
                                                      TextStyle(fontSize: 12,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.chf.al,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.chf.sat,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "SEK",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "İsveç Kronu",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.sek.al,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.sek.sat,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "CAD",
                                                  style:
                                                      TextStyle(fontSize: 18,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Kanada Doları",
                                                  style:
                                                      TextStyle(fontSize: 12,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.cad.al,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.cad.sat,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "KWD",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Kuveyt Dinarı",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.kwd.al,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.kwd.sat,
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            children: [
                              TableCell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "NOK",
                                                  style:
                                                      TextStyle(fontSize: 18,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                child: Text(
                                                  "Norveç Kronu",
                                                  style:
                                                      TextStyle(fontSize: 12,color: Colors.white70),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              )
                                            ],
                                          ),
                                        ],
                                      ))),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 50, right: 0, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.kwd.al,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                              TableCell(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 10, bottom: 10, top: 15),
                                child: Text(
                                  currency.data.kwd.sat,
                                  style: TextStyle(fontSize: 15,color: Colors.white70),
                                ),
                              )),
                            ]),
                      ],
                    ),
                  ],
                ),
              ]);
            }
          },
        ),
      ),
    );
  }
}
