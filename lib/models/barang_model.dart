class Barang {
  String? id;
  String? namaBarang;
  String? kategoriId;
  String? stok;
  String? kelompokBarang;
  String? harga;
  bool isSelected = false;

  Barang(
      {this.id,
      this.namaBarang,
      this.kategoriId,
      this.stok,
      this.kelompokBarang,
      this.harga,
      required this.isSelected});

  Barang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaBarang = json['nama_barang'];
    kategoriId = json['kategori_id'];
    stok = json['stok'];
    kelompokBarang = json['kelompok_barang'];
    harga = json['harga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_barang'] = namaBarang;
    data['kategori_id'] = kategoriId;
    data['stok'] = stok;
    data['kelompok_barang'] = kelompokBarang;
    data['harga'] = harga;
    return data;
  }
}
