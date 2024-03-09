import 'dart:convert';

import 'package:ariiqvalerianromero_frontend/controller/barang_controller.dart';
import 'package:ariiqvalerianromero_frontend/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/barang_model.dart';
import '../models/category_model.dart';

class EditBarangScreen extends StatefulWidget {
  final Barang data;
  const EditBarangScreen({super.key, required this.data});

  @override
  State<EditBarangScreen> createState() => _EditBarangScreenState();
}

class _EditBarangScreenState extends State<EditBarangScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaBarangC = TextEditingController();
  TextEditingController kategoriBarangC = TextEditingController();
  TextEditingController kelompokBarangC = TextEditingController();
  TextEditingController stokC = TextEditingController();
  TextEditingController hargaC = TextEditingController();

  @override
  void initState() {
    namaBarangC.text = widget.data.namaBarang!;
    kategoriBarangC.text = widget.data.kategoriId!;
    kelompokBarangC.text = widget.data.kelompokBarang!;
    stokC.text = widget.data.stok!;
    hargaC.text = widget.data.harga!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
      ),
      body: Consumer<BarangController>(
        builder: (context, barang, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextBox(
                        controller: namaBarangC,
                        title: 'Nama Barang',
                        hintText: 'Masukkan Nama Barang',
                        onChanged: (val) {
                          namaBarangC.text = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama barang belum diisi';
                          }
                          return null;
                        },
                      ),
                      const Text('Kategori Barang'),
                      DropdownSearch<Category>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan Kategori Barang",
                          ),
                        ),
                        asyncItems: (filter) async {
                          final response = await http.get(
                            Uri.parse(
                                'http://192.168.218.40:80/product-api-php/kategori/read.php'),
                          );
                          final data = (json.decode(response.body) as List)
                              .map((data) => Category.fromJson(data))
                              .toList();
                          return data;
                        },
                        itemAsString: (item) => item.namaKategori!,
                        onChanged: (value) {
                          kategoriBarangC.text = value!.id!;
                          print(kategoriBarangC.text);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori belum diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text('Kelompok Barang'),
                      DropdownSearch<String>(
                        items: const [
                          "Komputer",
                          "Kamus",
                          "Pena",
                        ],
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan Kelompok Barang",
                          ),
                        ),
                        selectedItem: widget.data.kelompokBarang,
                        onChanged: (value) {
                          kelompokBarangC.text = value.toString();
                          print(kelompokBarangC.text);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kelompok barang belum diisi';
                          }
                          return null;
                        },
                      ),
                      MyTextBox(
                        controller: stokC,
                        title: 'Stok',
                        hintText: 'Masukkan Stok',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          stokC.text = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stok belum diisi';
                          }
                          return null;
                        },
                      ),
                      MyTextBox(
                        controller: hargaC,
                        title: 'Harga',
                        hintText: 'Masukkan Harga',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          hargaC.text = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '0') {
                            return 'Harga tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              barang.updateProduct(
                                id: widget.data.id,
                                namaBarang: namaBarangC.text,
                                kategoriBarang: kategoriBarangC.text,
                                stok: stokC.text,
                                kelompokBarang: kelompokBarangC.text,
                                harga: hargaC.text,
                              );
                            } catch (e) {
                              print(e);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: const Text('Update Barang'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const MyTextBox({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                TextFormField(
                  controller: controller,
                  onChanged: onChanged,
                  validator: validator,
                  keyboardType: keyboardType ?? TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
