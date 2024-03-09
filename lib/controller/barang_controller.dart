import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/barang_model.dart';

class BarangController extends ChangeNotifier {
  bool isLoading = true;
  bool showCheckboxes = false;
  bool selectAll = false;
  List<Barang> allProductData = [];
  List selectedBarang = [];

  getAllProduct() async {
    final response = await http.get(
      Uri.parse('http://192.168.218.40:80/product-api-php/index.php'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*"
      },
    );
    final data = (json.decode(response.body) as List)
        .map((data) => Barang.fromJson(data))
        .toList();

    allProductData = data;
    notifyListeners();
  }

  addProduct({
    String? namaBarang,
    String? kategoriBarang,
    String? stok,
    String? kelompokBarang,
    String? harga,
  }) async {
    final response = await http.post(
      Uri.parse(
        'http://192.168.218.40:80/product-api-php/barang/create.php',
      ),
      body: {
        'nama_barang': namaBarang,
        'kategori_id': kategoriBarang,
        'stok': stok,
        'kelompok_barang': kelompokBarang,
        'harga': harga,
      },
    );
    getAllProduct();
    notifyListeners();
  }

  updateProduct({
    String? id,
    String? namaBarang,
    String? kategoriBarang,
    String? stok,
    String? kelompokBarang,
    String? harga,
  }) async {
    final response = await http.post(
      Uri.parse(
        'http://192.168.218.40:80/product-api-php/barang/update.php',
      ),
      body: {
        'id': id,
        'nama_barang': namaBarang,
        'kategori_id': kategoriBarang,
        'stok': stok,
        'kelompok_barang': kelompokBarang,
        'harga': harga,
      },
    );
    getAllProduct();
    notifyListeners();
  }

  deleteProduct({String? id}) async {
    final response = await http.delete(
      Uri.parse(
        'http://192.168.218.40:80/product-api-php/barang/delete.php?id=$id',
      ),
    );
    getAllProduct();
    notifyListeners();
  }

  bulkDeleteProduct(BuildContext context) async {
    for (var item in allProductData) {
      if (item.isSelected == true) {
        final response = await http.delete(
          Uri.parse(
            'http://192.168.218.40:80/product-api-php/barang/delete.php?id=${item.id}',
          ),
        );
        getAllProduct();
        notifyListeners();
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data selected!')),
        );
      }
    }
  }
}
