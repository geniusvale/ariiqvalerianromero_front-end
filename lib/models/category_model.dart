class Category {
  String? id;
  String? namaKategori;

  Category({this.id, this.namaKategori});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaKategori = json['nama_kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_kategori'] = namaKategori;
    return data;
  }
}