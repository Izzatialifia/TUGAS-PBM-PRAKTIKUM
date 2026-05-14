import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class AddProductScreen
    extends StatefulWidget {
  const AddProductScreen({
    super.key,
  });

  @override
  State<AddProductScreen>
      createState() =>
          _AddProductScreenState();
}

class _AddProductScreenState
    extends State<AddProductScreen> {
  final nameController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  bool isLoading = false;

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController
            .text
            .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Semua field wajib diisi',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Product product = Product(
      name: nameController.text,
      price: int.parse(
        priceController.text,
      ),
      description:
          descriptionController.text,
    );

    bool success =
        await ApiService.addProduct(
      product,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menambahkan produk',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Emas Antam',
          style:
              GoogleFonts.poppins(
            color: AppTheme.gold,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller:
                  nameController,
              style:
                  const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    'Nama Produk',
                hintStyle:
                    TextStyle(
                  color:
                      Colors.white54,
                ),
                prefixIcon: Icon(
                  Icons.workspace_premium,
                  color:
                      AppTheme.gold,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  priceController,
              keyboardType:
                  TextInputType.number,
              style:
                  const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    'Harga',
                hintStyle:
                    TextStyle(
                  color:
                      Colors.white54,
                ),
                prefixIcon: Icon(
                  Icons.attach_money,
                  color:
                      AppTheme.gold,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  descriptionController,
              maxLines: 3,
              style:
                  const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    'Deskripsi',
                hintStyle:
                    TextStyle(
                  color:
                      Colors.white54,
                ),
                prefixIcon: Icon(
                  Icons.description,
                  color:
                      AppTheme.gold,
                ),
              ),
            ),

            const SizedBox(
              height: 35,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 55,
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : saveProduct,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.gold,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.black,
                          )
                        : Text(
                            'SIMPAN PRODUK',
                            style:
                                GoogleFonts.poppins(
                              color:
                                  Colors.black,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}