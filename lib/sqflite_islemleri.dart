import 'package:flutter/material.dart';
import 'package:paramnerede_app/doviz/altinkurlari.dart';
import 'package:paramnerede_app/doviz/dovizkurlari.dart';
import 'package:paramnerede_app/kartlarim.dart';
import 'package:provider/provider.dart';
import 'login_screen/user_repository.dart';
import 'utils/database_helper.dart';
import 'models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class SqfliteIslemleri extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  SqfliteIslemleri({this.onPressed, this.tooltip, this.icon});
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  DatabaseHelper _databaseHelper;
  List<Model> tumGelirler;
  List<Model> tumGiderler;
  List<Model> tumVeriler;
  var formKey = GlobalKey<FormState>();
  var formKeyKategori = GlobalKey<FormState>();
  int girilenTutar;
  String eklenenKategori;
  String girilenAciklama;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String secilenKategori;
  String ekranGelirGider = "Tümü";
  String ekranKategori = "Tümü";
  String ekranKategoriGider = "Tümü";
  String gelirGiderKategoriSecilen;
  DateTime selectedDate = DateTime.now();
  String secilenGelirGiderTuru = "Gelir";
  String formattedDate =
      DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
  String monthDate;
  String dropTarih = "Bugün";
  var tumGelirMapi = new Map<String, double>();
  List<String> tumGelirMapiKeys = List<String>();
  var tumGiderMapi = new Map<String, double>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final _pageController = PageController(initialPage: 0);
  Map<String, double> dataMapGiderBugun = {};
  Map<String, double> dataMapGiderDun = {};
  Map<String, double> dataMapGiderBuAy = {};
  Map<String, double> dataMapGiderOncekiAy = {};
  Map<String, double> dataMapGelirBugun = {};
  Map<String, double> dataMapGelirDun = {};
  Map<String, double> dataMapGelirBuAy = {};
  Map<String, double> dataMapGelirOncekiAy = {};
  List<String> giderKategoriListe = ["Tümü", "Market", "Telefon Faturası"];
  List<String> gelirKategoriListe = ["Tümü", "Burs", "Maaş"];

  double deneme;
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color.fromRGBO(80, 80, 80, 0.9),
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    tumGelirler = List<Model>();
    tumGiderler = List<Model>();
    tumVeriler = List<Model>();
    tumGelirMapiKeys = List<String>();
    _databaseHelper = DatabaseHelper();

    _databaseHelper.tumGelir().then((tumGelirleriTutanMapListesi) {
      for (Map okunanGelirMapi in tumGelirleriTutanMapListesi) {
        tumGelirler.add(Model.fromMap(okunanGelirMapi));
        tumVeriler.add(Model.fromMap(okunanGelirMapi));
      }
      for (int i = 0; i < tumGelirler.length; i++) {
        print("dd" + tumGelirler[i].kategori + tumGelirler[i].tutar.toString());

        pageViewMapGelirEkle(tumGelirler[i].kategori,
            tumGelirler[i].tutar.toDouble(), tumGelirler[i].tarih);
      }
    }).catchError((e) {
      print("hata: " + e.toString());
    });

    _databaseHelper.tumGider().then((tumGiderleriTutanMapListesi) {
      for (Map okunanGiderMapi in tumGiderleriTutanMapListesi) {
        tumGiderler.add(Model.fromMap(okunanGiderMapi));
        tumVeriler.add(Model.fromMap(okunanGiderMapi));
      }
      for (int i = 0; i < tumGiderler.length; i++) {
        print("dd" + tumGiderler[i].kategori + tumGiderler[i].tutar.toString());
        pageViewMapGiderEkle(tumGiderler[i].kategori,
            tumGiderler[i].tutar.toDouble(), tumGiderler[i].tarih);
      }
    }).catchError((e) {
      print("hata gider tablosu: " + e.toString());
    });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget kategoriW() {
    return Container(
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Color.fromRGBO(80, 80, 80, 0.9),
        onPressed: () {
          kategoriEkle(context);
        },
        tooltip: 'Image',
        child: Icon(Icons.add_circle),
      ),
    );
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(80, 80, 80, 0.9),
        onPressed: () {
          gelirGiderVeriEkle(context);
        },
        tooltip: 'Inbox',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  double dememe;
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Transform(
                    transform: Matrix4.translationValues(
                      0.0,
                      _translateButton.value * 2.0,
                      0.0,
                    ),
                    child: kategoriW(),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                      0.0,
                      _translateButton.value,
                      0.0,
                    ),
                    child: add(),
                  ),
                  toggle(),
                ],
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
              body: new Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Color.fromRGBO(70, 70, 70, 1)),
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: [_gelirMapWidget(), _giderMapWidget()],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 14,
                        color: Color.fromRGBO(80, 80, 80, 0.9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: new EdgeInsets.only(left: 12),
                              child: DropdownButton(
                                value: ekranGelirGider,
                                items: <String>[
                                  'Tümü',
                                  'Gelir',
                                  'Gider',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(232, 232, 232, 1)),
                                    ),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Tümü",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (String deger) {
                                  setState(() {
                                    ekranGelirGider = deger;
                                  });
                                },
                              ),
                            ),
                            ekranGelirGider == "Gelir"
                                ? Container(
                                    //margin: new EdgeInsets.only(left: 2),
                                    child: DropdownButton(
                                      value: ekranKategori,
                                      items: gelirKategoriListe
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    232, 232, 232, 1)),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Tümü",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (String deger) {
                                        gelirGiderKategoriSecilen = deger;
                                        print(gelirGiderKategoriSecilen);
                                        setState(() {
                                          ekranKategori = deger;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    //margin: new EdgeInsets.only(left: 2),
                                    child: DropdownButton(
                                      value: ekranKategoriGider,
                                      items: giderKategoriListe
                                          .map((String degerr) {
                                        return DropdownMenuItem<String>(
                                          value: degerr,
                                          child: Text(
                                            degerr,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    232, 232, 232, 1)),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Tümü",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (String degerrr) {
                                        gelirGiderKategoriSecilen = degerrr;
                                        print(gelirGiderKategoriSecilen);
                                        setState(() {
                                          ekranKategoriGider = degerrr;
                                        });
                                      },
                                    ),
                                  ),
                            Container(
                              margin: new EdgeInsets.only(left: 12),
                              child: DropdownButton(
                                value: dropTarih,
                                items: <String>[
                                  'Bugün',
                                  'Dün',
                                  'Bu Ay',
                                  'Önceki Ay',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(232, 232, 232, 1)),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String deger) {
                                  setState(() {
                                    dropTarih = deger;
                                    zamanAyarla(deger);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FutureBuilder(
                          future: _databaseHelper.tumGelir(),
                          builder: (context, snapshot) {
                            //print(snapshot.data);
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (ekranGelirGider == "Gelir") {
                                return tumGelirWidget();
                              } else if (ekranGelirGider == "Tümü") {
                                return gelirGiderTumWidget();
                              } else {
                                return tumGiderWidget();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void zamanAyarla(String zaman) {
    if (zaman == "Bugün") {
      formattedDate =
          DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
      print(formattedDate);
    } else if (zaman == "Dün") {
      formattedDate = DateFormat("dd-MM-yyyy")
          .format(DateTime.now().subtract(Duration(days: 1)))
          .toString();
      print(formattedDate);
    } else if (zaman == "Bu Ay") {
      DateTime thisMonthDate = DateTime.now();
      String thisMonthDateStr = thisMonthDate.toString();
      formattedDate = thisMonthDateStr.substring(5, 7);
      print(monthDate);
    } else {
      var thisMonthDate = new DateTime(
          DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
      String thisMonthDateStr = thisMonthDate.toString();
      formattedDate = thisMonthDateStr.substring(5, 7);
      print(monthDate);
    }
  }

  Widget tumGiderWidget() {
    return ListView.builder(
      itemCount: tumGiderler.length,
      itemBuilder: (context, index) {
        String ata = (tumGiderler[index].tarih);
        print(ata.substring(5, 7));
        return tumGiderler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumGiderler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumGiderler[index].tarih)) ==
                        formattedDate ||
                tumVeriler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate
            ? Card(
                child: Container(
                  color: Color.fromRGBO(70, 70, 70, 1),
                  child: Row(
                    children: [
                      Container(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        width: 320,
                        child: ListTile(
                          leading: Text(
                            tumGiderler[index].tutar.toString(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: tumGiderler[index].tur == "Gelir"
                                    ? Colors.green.shade600
                                    : Colors.red),
                          ),
                          title: Text(
                            tumGiderler[index].kategori,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          subtitle: Text(
                            tumGiderler[index].aciklama,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          trailing: Text(
                            DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(tumGiderler[index].tarih),
                            ),
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.shade800,
                                size: MediaQuery.of(context).size.height * 0.04,
                              ),
                              onTap: () {
                                setState(() {
                                  _giderSil(tumGiderler[index].id, index);
                                  pageViewMapGiderSil(
                                      tumGiderler[index].kategori,
                                      tumGiderler[index].tutar.toDouble());
                                });
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget tumGelirWidget() {
    return ListView.builder(
      itemCount: tumGelirler.length,
      itemBuilder: (context, index) {
        return tumVeriler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                tumVeriler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate
            ? Card(
                child: Container(
                  color: Color.fromRGBO(70, 70, 70, 1),
                  child: Row(
                    children: [
                      Container(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        width: 320,
                        child: ListTile(
                          leading: Text(
                            tumGelirler[index].tutar.toString(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: tumGelirler[index].tur == "Gelir"
                                    ? Colors.green.shade600
                                    : Colors.red),
                          ),
                          title: Text(
                            tumGelirler[index].kategori,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          subtitle: Text(
                            tumGelirler[index].aciklama,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          trailing: Text(
                            DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(tumGelirler[index].tarih),
                            ),
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red.shade800,
                                size: MediaQuery.of(context).size.height * 0.04,
                              ),
                              onTap: () {
                                setState(() {
                                  _gelirSil(tumGelirler[index].id, index);
                                  pageViewMapGelirSil(
                                      tumGelirler[index].kategori,
                                      tumGelirler[index].tutar.toDouble());
                                });
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget gelirGiderTumWidget() {
    return ListView.builder(
      itemCount: tumVeriler.length,
      itemBuilder: (context, index) {
        return tumVeriler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                tumVeriler[index].kategori == gelirGiderKategoriSecilen &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate ||
                gelirGiderKategoriSecilen == "Tümü" &&
                    DateFormat("MM")
                            .format(DateTime.parse(tumVeriler[index].tarih)) ==
                        formattedDate
            ? Card(
                child: Container(
                  color: Color.fromRGBO(70, 70, 70, 1),
                  child: Row(
                    children: [
                      Container(
                        color: Color.fromRGBO(70, 70, 70, 1),
                        width: 320,
                        child: ListTile(
                          leading: Text(
                            tumVeriler[index].tutar.toString(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03,
                                color: tumVeriler[index].tur == "Gelir"
                                    ? Colors.green.shade600
                                    : Colors.red),
                          ),
                          title: Text(
                            tumVeriler[index].kategori,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          subtitle: Text(
                            tumVeriler[index].aciklama,
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                          trailing: Text(
                            DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(tumVeriler[index].tarih),
                            ),
                            style: TextStyle(
                                color: Color.fromRGBO(232, 232, 232, 1)),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red.shade800,
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                            onTap: () {
                              if (tumVeriler[index].tur == "Gelir") {
                                setState(() {
                                  _gelirSil(tumVeriler[index].id, index);
                                  pageViewMapGelirSil(
                                      tumVeriler[index].kategori,
                                      tumVeriler[index].tutar.toDouble());
                                });
                              } else {
                                setState(() {
                                  _giderSil(tumVeriler[index].id, index);
                                  pageViewMapGiderSil(
                                      tumVeriler[index].kategori,
                                      tumVeriler[index].tutar.toDouble());
                                });
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _gelirMapWidget() {
    return FutureBuilder(
      future: _databaseHelper.tumGelir(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return MapAyarlaGelir(dropTarih).isEmpty
              ? Container(
                  color: Color.fromRGBO(70, 70, 70, 0.9),
                )
              : SizedBox(
                  height: 200,
                  child: Container(
                    color: Color.fromRGBO(70, 70, 70, 0.9),
                    child: PieChart(
                      dataMap: MapAyarlaGelir(dropTarih),
                      animationDuration: Duration(milliseconds: 1500),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      centerText: "Gelir",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                );
        }
      },
    );
  }

  Widget _giderMapWidget() {
    return FutureBuilder(
      future: _databaseHelper.tumGider(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return MapAyarlaGider(dropTarih).isEmpty
              ? Container(
                  color: Color.fromRGBO(70, 70, 70, 0.9),
                )
              : SizedBox(
                  height: 200,
                  child: Container(
                    color: Color.fromRGBO(70, 70, 70, 0.9),
                    child: PieChart(
                      dataMap: MapAyarlaGider(dropTarih),
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Gider",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                );
        }
      },
    );
  }

  Future<List<Model>> tumGelirListesiniGetir() async {
    tumGelirler = List<Model>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumGelir().then((tumGelirleriTutanMapListesi) {
      for (Map okunanGelirMapi in tumGelirleriTutanMapListesi) {
        tumGelirler.add(Model.fromMap(okunanGelirMapi));
      }
      print("dbden geln gelir sayısı: " + tumGelirler.length.toString());
      return tumGelirler;
    }).catchError((e) {
      print("hata: " + e.toString());
    });
  }

  void _geliriEkle(Model gelir) async {
    var eklenenYeniGelirinIDsi = await _databaseHelper.gelirEkle(gelir);
    gelir.id = eklenenYeniGelirinIDsi;
    if (eklenenYeniGelirinIDsi > 0) {
      setState(() {
        tumVeriler.insert(0, gelir);
        tumGelirler.insert(0, gelir);
      });
    }
  }

  void _giderEkle(Model gider) async {
    var eklenenYeniGiderinIDsi = await _databaseHelper.giderEkle(gider);
    gider.id = eklenenYeniGiderinIDsi;
    if (eklenenYeniGiderinIDsi > 0) {
      setState(() {
        tumVeriler.insert(0, gider);
        tumGiderler.insert(0, gider);
      });
    }
  }

  void _tumGelirVerisiniSil() async {
    var silinenElemanSayisi = await _databaseHelper.tumGeliriSil();
    setState(() {
      tumGelirler.clear();
    });
  }

  void _gelirSil(int dbdenSilmekIcinId, int listedenSilmekIcinId) async {
    var sonuc = await _databaseHelper.gelirSil(dbdenSilmekIcinId);
    setState(() {
      tumVeriler.removeAt(listedenSilmekIcinId);
      tumGelirler.removeAt(listedenSilmekIcinId);
    });
  }

  void _giderSil(int dbdenSilmekIcinId, int listedenSilmekIcinId) async {
    var sonuc = await _databaseHelper.gideriSil(dbdenSilmekIcinId);
    setState(() {
      tumVeriler.removeAt(listedenSilmekIcinId);
      tumGiderler.removeAt(listedenSilmekIcinId);
    });
  }

  Future<Database> _refresh() {
    return _databaseHelper.dataGonder();
  }

  void _gelirVeriGuncelle(Model gelir) async {
    var sonuc = await _databaseHelper.geliriGuncelle(gelir);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("kayıt güncellendi..."),
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("kayıt güncellenemedi..."),
      ));
    }
  }

  void gelirGiderVeriEkle(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Color.fromRGBO(70, 70, 70, 1),
            title: Center(
                child: Text(
              "Gelir-Gider Ekle",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
            children: [
              Column(
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 18, right: 25),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: new Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Color.fromRGBO(70, 70, 70, 1),
                                ),
                                child: DropdownButton(
                                  value: secilenGelirGiderTuru,
                                  items: <String>[
                                    'Gelir',
                                    'Gider',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text("Gelir"),
                                  onChanged: (String deger) {
                                    setState(() {
                                      secilenGelirGiderTuru = deger;
                                    });
                                  },
                                ),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(left: 18, right: 25),
                            child: secilenGelirGiderTuru == "Gelir"
                                ? Container(
                                    //margin: new EdgeInsets.only(left: 2),
                                    child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor:
                                          Color.fromRGBO(70, 70, 70, 1),
                                    ),
                                    child: DropdownButton(
                                      value: ekranKategori,
                                      items: gelirKategoriListe
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Tümü",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (String deger) {
                                        secilenKategori = deger;

                                        setState(() {
                                          ekranKategori = deger;
                                        });
                                      },
                                    ),
                                  ))
                                : Container(
                                    //margin: new EdgeInsets.only(left: 2),
                                    child: new Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            Color.fromRGBO(70, 70, 70, 1),
                                      ),
                                      child: DropdownButton(
                                        value: ekranKategoriGider,
                                        items: giderKategoriListe
                                            .map((String degerr) {
                                          return DropdownMenuItem<String>(
                                            value: degerr,
                                            child: Text(
                                              degerr,
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text(
                                          "Tümü",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onChanged: (String degerrr) {
                                          secilenKategori = degerrr;
                                          setState(() {
                                            ekranKategoriGider = degerrr;
                                          });
                                        },
                                      ),
                                    ),
                                  )),
                      ],
                    );
                  }),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Tutar",
                                labelStyle: TextStyle(color: Colors.white60),
                                border: OutlineInputBorder()),
                            validator: (girilenTutar) {
                              if (girilenTutar.length == 0) {
                                return "Tutar Boş Girilemez";
                              }
                            },
                            onSaved: (yeniDeger) {
                              girilenTutar = int.parse(yeniDeger);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Açıklama",
                                labelStyle: TextStyle(color: Colors.white60),
                                border: OutlineInputBorder()),
                            onSaved: (yeniDeger) {
                              girilenAciklama = yeniDeger;
                            },
                          ),
                        ),
                      ],
                    ),
                    key: formKey,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(70, 70, 70, 1)),
                      ),
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text(
                        "Tarih Seçiniz...",
                        style: TextStyle(color: Colors.white60),
                      )),
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
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            /**/

                            if (secilenGelirGiderTuru == "Gelir") {
                              _geliriEkle(Model(
                                  "Gelir",
                                  girilenTutar,
                                  girilenAciklama,
                                  secilenKategori,
                                  selectedDate.toString()));
                              pageViewMapGelirEkle(
                                  secilenKategori,
                                  girilenTutar.toDouble(),
                                  selectedDate.toString());
                            } else {
                              _giderEkle(Model(
                                  "Gider",
                                  girilenTutar,
                                  girilenAciklama,
                                  secilenKategori,
                                  selectedDate.toString()));
                              pageViewMapGiderEkle(
                                  secilenKategori,
                                  girilenTutar.toDouble(),
                                  selectedDate.toString());
                            }

                            print(secilenGelirGiderTuru);
                          }
                        },
                        color: Colors.green,
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }

  void kategoriEkle(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Color.fromRGBO(70, 70, 70, 1),
            title: Center(
                child: Text(
              "Kategori Ekle",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
            children: [
              Column(
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 25),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Color.fromRGBO(70, 70, 70, 1),
                              ),
                              child: DropdownButton(
                                value: secilenGelirGiderTuru,
                                items: <String>[
                                  'Gelir',
                                  'Gider',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                hint: Text("Gelir",
                                    style: TextStyle(color: Colors.white)),
                                onChanged: (String deger) {
                                  setState(() {
                                    secilenGelirGiderTuru = deger;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
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
                                labelText: "Kategori",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                            validator: (eklenenKategori) {
                              if (eklenenKategori.length == 0) {
                                return "Kategori Boş Girilemez";
                              }
                            },
                            onSaved: (yeniDeger) {
                              eklenenKategori = yeniDeger;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    key: formKeyKategori,
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
                          if (formKeyKategori.currentState.validate()) {
                            formKeyKategori.currentState.save();
                            listeKategoriEkle(
                                secilenGelirGiderTuru, eklenenKategori);
                            print("kategori" + eklenenKategori);
                            print(
                                "objectgelir" + gelirKategoriListe.toString());
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

  Map<String, double> MapAyarlaGelir(String dropTarihAl) {
    if (dropTarihAl == "Bugün") {
      return dataMapGelirBugun;
    } else if (dropTarihAl == "Dün") {
      return dataMapGelirDun;
    } else if (dropTarihAl == "Bu Ay") {
      return dataMapGelirBuAy;
    } else if (dropTarihAl == "Önceki Ay") {
      return dataMapGelirOncekiAy;
    }
  }

  Map<String, double> MapAyarlaGider(String dropTarihAl) {
    if (dropTarihAl == "Bugün") {
      return dataMapGiderBugun;
    } else if (dropTarihAl == "Dün") {
      return dataMapGiderDun;
    } else if (dropTarihAl == "Bu Ay") {
      return dataMapGiderBuAy;
    } else if (dropTarihAl == "Önceki Ay") {
      return dataMapGiderOncekiAy;
    }
  }

  String bugun = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
  String dun = DateFormat("dd-MM-yyyy")
      .format(DateTime.now().subtract(Duration(days: 1)))
      .toString();
  String buAySayi = DateFormat("MM").format(DateTime.now()).toString();

  void pageViewMapGelirEkle(String kategori, double tutar, dynamic tarih) {
    String gecenAyTam = new DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)
        .toString();
    String gecenAy = gecenAyTam.substring(5, 7).toString();
    String formattedTarih =
        DateFormat("dd-MM-yyyy").format(DateTime.parse(tarih)).toString();
    String formattedTarihAy =
        DateFormat("MM").format(DateTime.parse(tarih)).toString();

    if (formattedTarih == bugun) {
      setState(() {
        if (dataMapGelirBugun[kategori] == null) {
          dataMapGelirBugun[kategori] = tutar;
        } else {
          dataMapGelirBugun.update(
              kategori, (value) => dataMapGelirBugun[kategori] + tutar);
        }
      });
    } else if (formattedTarih == dun) {
      setState(() {
        if (dataMapGelirDun[kategori] == null) {
          dataMapGelirDun[kategori] = tutar;
        } else {
          dataMapGelirDun.update(
              kategori, (value) => dataMapGelirDun[kategori] + tutar);
        }
      });
    }
    if (formattedTarihAy == buAySayi) {
      setState(() {
        if (dataMapGelirBuAy[kategori] == null) {
          dataMapGelirBuAy[kategori] = tutar;
        } else {
          dataMapGelirBuAy.update(
              kategori, (value) => dataMapGelirBuAy[kategori] + tutar);
        }
      });
    } else if (formattedTarihAy == gecenAy) {
      setState(() {
        if (dataMapGelirOncekiAy[kategori] == null) {
          dataMapGelirOncekiAy[kategori] = tutar;
        } else {
          dataMapGelirOncekiAy.update(
              kategori, (value) => dataMapGelirOncekiAy[kategori] + tutar);
        }
      });
    }
  }

  Map<String, double> pageViewMapGelirSil(String kategori, double tutar) {
    double deger = dataMapGelirBugun[kategori];
    setState(() {
      dataMapGelirBugun.update(kategori, (value) => deger - tutar);
      if (dataMapGelirBugun[kategori] == 0) {
        dataMapGelirBugun.remove(kategori);
        print("sildimmm");
      } else {
        print("silinmedi");
      }
    });
  }

  void pageViewMapGiderEkle(String kategori, double tutar, dynamic tarih) {
    String gecenAyTam = new DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)
        .toString();
    String gecenAy = gecenAyTam.substring(5, 7).toString();
    String formattedTarih =
        DateFormat("dd-MM-yyyy").format(DateTime.parse(tarih)).toString();
    String formattedTarihAy =
        DateFormat("MM").format(DateTime.parse(tarih)).toString();

    if (formattedTarih == bugun) {
      setState(() {
        if (dataMapGiderBugun[kategori] == null) {
          dataMapGiderBugun[kategori] = tutar;
        } else {
          dataMapGiderBugun.update(
              kategori, (value) => dataMapGiderBugun[kategori] + tutar);
        }
      });
    } else if (formattedTarih == dun) {
      setState(() {
        if (dataMapGiderDun[kategori] == null) {
          dataMapGiderDun[kategori] = tutar;
        } else {
          dataMapGiderDun.update(
              kategori, (value) => dataMapGiderDun[kategori] + tutar);
        }
      });
    }
    if (formattedTarihAy == buAySayi) {
      setState(() {
        if (dataMapGiderBuAy[kategori] == null) {
          dataMapGiderBuAy[kategori] = tutar;
        } else {
          dataMapGiderBuAy.update(
              kategori, (value) => dataMapGiderBuAy[kategori] + tutar);
        }
      });
    } else if (formattedTarihAy == gecenAy) {
      setState(() {
        if (dataMapGiderOncekiAy[kategori] == null) {
          dataMapGiderOncekiAy[kategori] = tutar;
        } else {
          dataMapGiderOncekiAy.update(
              kategori, (value) => dataMapGiderOncekiAy[kategori] + tutar);
        }
      });
    }
  }

  Map<String, double> pageViewMapGiderSil(String kategori, double tutar) {
    double deger = dataMapGiderBugun[kategori];
    setState(() {
      dataMapGiderBugun.update(kategori, (value) => deger - tutar);
      if (dataMapGiderBugun[kategori] == 0) {
        dataMapGiderBugun.remove(kategori);
        print("sildimmm");
      } else {
        print("silinmedi");
      }
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    print("seçilen tarih" + selectedDate.toString());
  }

  void listeKategoriEkle(String gelirGiderTur, String eklenecekKategori) {
    if (gelirGiderTur == "Gelir") {
      gelirKategoriListe.add(eklenenKategori);
      print(gelirKategoriListe);
    } else {
      giderKategoriListe.add(eklenenKategori);
      print(giderKategoriListe);
    }
  }
}
