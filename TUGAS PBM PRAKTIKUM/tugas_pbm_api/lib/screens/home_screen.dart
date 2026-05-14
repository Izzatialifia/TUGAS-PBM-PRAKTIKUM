import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import 'add_product_screen.dart';
import 'submit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data =
        await ApiService.getProducts();

    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ANTAM GOLD',
          style:
              GoogleFonts.poppins(
            color: AppTheme.gold,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.send,
              color: AppTheme.gold,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SubmitScreen(),
                ),
              );
            },
          )
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            AppTheme.gold,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddProductScreen(),
            ),
          );

          loadProducts();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    AppTheme.gold,
              ),
            )
          : products.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada produk emas',
                    style:
                        GoogleFonts.poppins(
                      color:
                          Colors.white,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh:
                      loadProducts,
                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets
                            .all(16),
                    itemCount:
                        products.length,
                    itemBuilder:
                        (context,
                            index) {
                      final product =
                          products[
                              index];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 18,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.black,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          border:
                              Border.all(
                            color:
                                AppTheme.gold,
                            width: 1,
                          ),
                        ),

                        child:
                            ListTile(
                          contentPadding:
                              const EdgeInsets.all(
                            18,
                          ),

                          leading:
                              const CircleAvatar(
                            backgroundColor:
                                AppTheme.gold,
                            child: Icon(
                              Icons.workspace_premium,
                              color:
                                  Colors.black,
                            ),
                          ),

                          title: Text(
                            product.name,
                            style:
                                GoogleFonts.poppins(
                              color:
                                  AppTheme.gold,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          subtitle:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const SizedBox(
                                height:
                                    6,
                              ),

                              Text(
                                'Rp ${product.price}',
                                style:
                                    GoogleFonts.poppins(
                                  color:
                                      Colors.white,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    6,
                              ),

                              Text(
                                product
                                    .description,
                                style:
                                    GoogleFonts.poppins(
                                  color:
                                      Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}