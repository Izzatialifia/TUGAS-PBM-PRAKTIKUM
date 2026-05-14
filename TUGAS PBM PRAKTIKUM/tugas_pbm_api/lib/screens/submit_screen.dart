import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../utils/app_theme.dart';

class SubmitScreen
    extends StatefulWidget {
  const SubmitScreen({
    super.key,
  });

  @override
  State<SubmitScreen>
      createState() =>
          _SubmitScreenState();
}

class _SubmitScreenState
    extends State<SubmitScreen> {
  final nameController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final githubController =
      TextEditingController();

  bool isLoading = false;

  Future<void> submitTask() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController
            .text
            .isEmpty ||
        githubController.text
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

    bool success =
        await ApiService.submitTask(
      name: nameController.text,
      price: int.parse(
        priceController.text,
      ),
      description:
          descriptionController.text,
      githubUrl:
          githubController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Tugas berhasil disubmit',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Submit gagal',
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
          'Submit Tugas',
          style:
              GoogleFonts.poppins(
            color: AppTheme.gold,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
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
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  githubController,
              style:
                  const TextStyle(
                color: Colors.white,
              ),
              decoration:
                  const InputDecoration(
                hintText:
                    'GitHub URL',
                hintStyle:
                    TextStyle(
                  color:
                      Colors.white54,
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
                        : submitTask,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.gold,
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.black,
                          )
                        : Text(
                            'SUBMIT TUGAS',
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