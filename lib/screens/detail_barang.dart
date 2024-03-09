import 'package:flutter/material.dart';

import '../models/barang_model.dart';

class DetailBarang extends StatelessWidget {
  final Barang modelBarang;
  final Function()? onDeleteButton;
  final Function()? onEditButton;

  const DetailBarang({
    super.key,
    required this.modelBarang,
    required this.onDeleteButton,
    required this.onEditButton,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 250,
            child: Icon(Icons.broken_image),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: Border.all(),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Nama Barang'),
                  trailing: Text(modelBarang.namaBarang ?? ''),
                ),
                ListTile(
                  title: const Text('Kategori'),
                  trailing: Text(modelBarang.kategoriId ?? "?"),
                ),
                ListTile(
                  title: const Text('Kelompok'),
                  trailing: Text(modelBarang.kelompokBarang ?? '?'),
                ),
                ListTile(
                  title: const Text('Stok'),
                  trailing: Text(modelBarang.stok ?? '0'),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Harga'),
                  trailing: Text('Rp. ${modelBarang.harga}'),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: onDeleteButton,
                  child: const Text(
                    'Hapus Barang',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onEditButton,
                  child: const Text('Edit Barang'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}