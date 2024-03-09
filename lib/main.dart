import 'package:ariiqvalerianromero_frontend/controller/barang_controller.dart';
import 'package:ariiqvalerianromero_frontend/screens/add_barang.dart';
import 'package:ariiqvalerianromero_frontend/screens/edit_barang.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/detail_barang.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BarangController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'List Stok Barang',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final barangController =
        Provider.of<BarangController>(context, listen: false);
    barangController.getAllProduct();
    barangController.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Stok Barang'),
        centerTitle: true,
      ),
      floatingActionButton: Consumer<BarangController>(
        builder: (context, value, child) => Visibility(
          visible: value.showCheckboxes == true ? false : true,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBarangScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Barang'),
          ),
        ),
      ),
      body: Consumer<BarangController>(
        builder: (context, barang, child) {
          return barang.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => barang.getAllProduct(),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${barang.allProductData.length} data ditampilkan'),
                              ),
                              TextButton(
                                onPressed: () {
                                  print(barang.selectedBarang);
                                  if (!barang.showCheckboxes) {
                                    barang.showCheckboxes = true;
                                  } else {
                                    barang.showCheckboxes = false;
                                  }
                                  setState(() {});
                                },
                                child: barang.showCheckboxes
                                    ? const Text('Close Edit Mode')
                                    : const Text('Edit Mode'),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: barang.allProductData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Visibility(
                                  visible: barang.showCheckboxes,
                                  child: Checkbox(
                                    value:
                                        barang.allProductData[index].isSelected,
                                    onChanged: (value) {
                                      barang.allProductData[index].isSelected =
                                          value!;

                                      // if (barang.selectedBarang
                                      //     .contains(index)) {
                                      //   barang.selectedBarang.remove(index);
                                      //   barang.allProductData[index]
                                      //       .isSelected = value; // unselect
                                      // } else {
                                      //   barang.selectedBarang.add(barang
                                      //       .allProductData[index]); // select
                                      // }
                                      print(barang.selectedBarang);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return DetailBarang(
                                        modelBarang:
                                            barang.allProductData[index],
                                        onDeleteButton: () async {
                                          try {
                                            await barang.deleteProduct(
                                              id: barang
                                                  .allProductData[index].id,
                                            );
                                          } catch (e) {
                                            print(e);
                                          }
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        onEditButton: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditBarangScreen(
                                                data: barang
                                                    .allProductData[index],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                title: Text(
                                  barang.allProductData[index].namaBarang ?? '',
                                ),
                                subtitle: Text(
                                  'Stok : ${barang.allProductData[index].stok}',
                                ),
                                trailing: Text(
                                  'Rp. ${barang.allProductData[index].harga ?? '0'}',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Visibility(
                          visible: barang.showCheckboxes,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: barang.selectAll,
                                        onChanged: (val) {
                                          if (barang.selectAll == false) {
                                            for (var item
                                                in barang.allProductData) {
                                              item.isSelected = val!;
                                            }
                                            barang.selectAll = val!;
                                            setState(() {});
                                          } else {
                                            for (var item
                                                in barang.allProductData) {
                                              item.isSelected = val!;
                                            }
                                            barang.selectAll = val!;
                                            setState(() {});
                                          }
                                          // if (barang.selectedBarang.isEmpty) {
                                          //   for (var item
                                          //       in barang.allProductData) {
                                          //     barang.selectedBarang
                                          //         .add(item.isSelected = val!);
                                          //   }
                                          //   barang.selectAll = true;
                                          //   setState(() {});
                                          // } else if (barang.selectAll == true &&
                                          //     barang.selectedBarang.length !=
                                          //         barang
                                          //             .allProductData.length) {
                                          //   barang.selectedBarang.clear();
                                          //   for (var item
                                          //       in barang.allProductData) {
                                          //     item.isSelected = val!;
                                          //   }
                                          //   barang.selectAll = false;
                                          //   setState(() {});
                                          // } else {
                                          //   barang.selectedBarang.clear();
                                          //   for (var item
                                          //       in barang.allProductData) {
                                          //     item.isSelected = val!;
                                          //   }
                                          //   barang.selectAll = false;
                                          //   setState(() {});
                                          // }
                                          print(barang.selectedBarang);
                                        },
                                      ),
                                      const Text('Pilih Semua'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    onPressed: () async {
                                      await barang.bulkDeleteProduct(context);
                                    },
                                    child: const Text(
                                      'Hapus Barang',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
