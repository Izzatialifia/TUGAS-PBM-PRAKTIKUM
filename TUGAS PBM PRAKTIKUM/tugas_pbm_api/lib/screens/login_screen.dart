import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final usernameController =
      TextEditingController(
    text: '242410103085',
  );

  final passwordController =
      TextEditingController(
    text: '242410103085',
  );

  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    bool success =
        await ApiService.login(
      usernameController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Login gagal',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color:
                        AppTheme.gold,
                    size: 90,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Text(
                    'ANTAM GOLD',
                    style:
                        GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppTheme.gold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Premium Gold Store',
                    style:
                        GoogleFonts.poppins(
                      color:
                          Colors.white70,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  TextField(
                    controller:
                        usernameController,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                    decoration:
                        const InputDecoration(
                      hintText:
                          'Username',
                      hintStyle:
                          TextStyle(
                        color:
                            Colors.white54,
                      ),
                      prefixIcon:
                          Icon(
                        Icons.person,
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
                        passwordController,
                    obscureText: true,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                    decoration:
                        const InputDecoration(
                      hintText:
                          'Password',
                      hintStyle:
                          TextStyle(
                        color:
                            Colors.white54,
                      ),
                      prefixIcon:
                          Icon(
                        Icons.lock,
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
                              : login,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.gold,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
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
                                  'LOGIN',
                                  style:
                                      GoogleFonts.poppins(
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        Colors.black,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Text(
                    'Official Antam Gold App',
                    style:
                        GoogleFonts.poppins(
                      color:
                          Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}