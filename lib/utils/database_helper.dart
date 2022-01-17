import 'dart:async';
import 'dart:io';
import 'package:paramnerede_app/login_screen/user_repository.dart';
import 'package:paramnerede_app/models/kategorimodel.dart';
import 'package:paramnerede_app/models/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _gelirTablo = "gelir";
  String _giderTablo = "gider";
  String _kategoriTabloGelir = "gelirkategorileri";
  String _kategoriTabloGider = "giderkategorileri";
  String _columnID = "id";
  String _columnTur = "tur";
  String _columnTutar = "tutar";
  String _columnAciklama = "aciklama";
  String _columnKategori = "kategori";
  String _columnTarih = "tarih";
  List<Map<String, Object>> tumVeriListesi;
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      print("DatabaseHelper null idi oluşturuldu");
      return _databaseHelper;
    } else {
      print("DatabaseHelper Null değildi var olan kullanılacak");
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      print("DB null idi oluşturulacak");
      _database = await _intializeDatabase();
      return _database;
    } else {
      print("DB null değildi var olan kullanılacak");
      return _database;
    }
  }

  Future<Database> dataGonder() async {
    return _getDatabase();
  }

  _intializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = "${klasor.path}/gelir.db";
    print("DB pathi:" + dbPath);
    var gelirDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return gelirDB;
  }

  Future<List<Map<String, dynamic>>> tumGelir() async {
    var db = await _getDatabase();

    var sonuc = await db.query(_gelirTablo, orderBy: '$_columnID DESC');
    return sonuc;
  }
  Future<List<Map<String, dynamic>>> tumGelirKategori() async {
    var db = await _getDatabase();

    var sonuc = await db.query(_kategoriTabloGelir, orderBy: '$_columnID DESC');
    return sonuc;
  }
  Future<List<Map<String, dynamic>>> tumGiderKategori() async {
    var db = await _getDatabase();

    var sonuc = await db.query(_kategoriTabloGider, orderBy: '$_columnID DESC');
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumGider() async {
    var db = await _getDatabase();

    var sonuc = await db.query(_giderTablo, orderBy: '$_columnID DESC');
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumVeri() async {
    tumGelir().then((tumGelirdenGelenDeger) {
      for (Map okunanGelirMapi in tumGelirdenGelenDeger) {
        tumVeriListesi.add(okunanGelirMapi);
      }
    });
    tumGider().then((tumGiderdenGelenDeger) {
      for (Map okunanGiderMapi in tumGiderdenGelenDeger) {
        tumVeriListesi.add(okunanGiderMapi);
      }
    });
    return tumVeriListesi;
  }

  Future<int> geliriGuncelle(Model gelir) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_gelirTablo, gelir.toMap(),
        where: '$_columnID = ?', whereArgs: [gelir.id]);
    return sonuc;
  }

  Future<int> gideriGuncelle(Model gider) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_giderTablo, gider.toMap(),
        where: '$_columnID = ?', whereArgs: [gider.id]);
    return sonuc;
  }

  Future<int> gelirSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_gelirTablo, where: '$_columnID = ? ', whereArgs: [id]);
    return sonuc;
  }
  Future<int> gelirKategoriSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_kategoriTabloGelir, where: '$_columnID = ? ', whereArgs: [id]);
    return sonuc;
  }
  Future<int> giderKategoriSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_kategoriTabloGider, where: '$_columnID = ? ', whereArgs: [id]);
    return sonuc;
  }

  Future<int> gideriSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_giderTablo, where: '$_columnID = ? ', whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumGeliriSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_gelirTablo);
    return sonuc;
  }

  Future<int> tumGideriSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_giderTablo);
    return sonuc;
  }

  Future<void> _createDB(Database db, int version) {
    print("create db metodu çalıştı tablo oluşturulacak");
    db.execute(
        "CREATE TABLE $_gelirTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTur TEXT, $_columnTutar INTEGER, $_columnAciklama TEXT, $_columnKategori TEXT, $_columnTarih TEXT )");
    db.execute(
        "CREATE TABLE $_giderTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTur TEXT, $_columnTutar INTEGER, $_columnAciklama TEXT, $_columnKategori TEXT, $_columnTarih TEXT )");
    db.execute(
        "CREATE TABLE $_kategoriTabloGelir ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnKategori TEXT )");
         db.execute(
        "CREATE TABLE $_kategoriTabloGider ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnKategori TEXT )");
  }

  Future<int> gelirEkle(Model gelir) async {
    var db = await _getDatabase();

    var sonuc = await db.insert(_gelirTablo, gelir.toMap(),
        nullColumnHack: "$_columnID");
    print("gelir eklendi " + sonuc.toString());
    return sonuc;
  }

  Future<int> gelirKategoriEkle(KategoriModel kategori) async {
    var db = await _getDatabase();

    var sonuc = await db.insert(_kategoriTabloGelir, kategori.toMap(),
        nullColumnHack: "$_columnID");
    print("Kategori eklendi " + sonuc.toString());
    return sonuc;
  }
  Future<int> giderKategoriEkle(KategoriModel kategori) async {
    var db = await _getDatabase();

    var sonuc = await db.insert(_kategoriTabloGider, kategori.toMap(),
        nullColumnHack: "$_columnID");
    print("Kategori gider eklendi " + sonuc.toString());
    return sonuc;
  }

  Future<int> giderEkle(Model gider) async {
    var db = await _getDatabase();

    var sonuc = await db.insert(_giderTablo, gider.toMap(),
        nullColumnHack: "$_columnID");
    print("gider eklendi " + sonuc.toString());
    return sonuc;
  }
}
