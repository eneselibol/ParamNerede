class KategoriModel {
  int _id;
  String _kategoriAd;

  int get id => this._id;

  set id(int value) => this._id = value;

  get kategoriAd => this._kategoriAd;

  set kategoriAd(value) => this._kategoriAd = value;

  KategoriModel(this._kategoriAd);
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["kategori"] = _kategoriAd;
    return map;
  }

  KategoriModel.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._kategoriAd = map["kategori"];
  }
}
