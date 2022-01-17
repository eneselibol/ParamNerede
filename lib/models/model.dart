class Model {
  int _id;
  int _tutar;
  String _aciklama;
  String _kategori;
  String _tarih;
  String _tur;

  int get id => this._id;

  set id(int value) => this._id = value;

  int get tutar => this._tutar;

  set tutar(int value) => this._tutar = value;

  get aciklama => this._aciklama;

  set aciklama(value) => this._aciklama = value;

  get kategori => this._kategori;

  set kategori(value) => this._kategori = value;

  get tur => this._tur;

  set tur(value) => this._tur = value;

  get tarih => this._tarih;

  set tarih(value) => this._tarih = value;

  Model(this._tur,this._tutar, this._aciklama, this._kategori,this._tarih);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"]=_id;
    map["tur"]=_tur;
    map["tutar"] = _tutar;
    map["aciklama"] = _aciklama;
    map["kategori"] = _kategori;
    map["tarih"] = _tarih;
    return map;
  }

  Model.fromMap(Map<String, dynamic> map) {
    this._id=map["id"];
    this._tur=map["tur"];
    this._tutar = map["tutar"];
    this._aciklama = map["aciklama"];
    this._kategori = map["kategori"];
    this._tarih = map["tarih"];
  }

  @override
  String toString() {
    return 'Gelir{_id: $_id, _tur: $_tur, tutar: $_tutar, _açıklama: $_aciklama, _kategori: $_kategori,}';
  }
}
