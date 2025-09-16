import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:id_app/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  State<SignupScreen> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<SignupScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 20.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Center(
                      child: const Text(
                        'Inscription',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: const Text(
                        'Créer un nouveau compte',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Full name
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'Nom Complet',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      controller: widget.fullnameController,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      controller: widget.emailController,
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'N° Téléphone',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      controller: widget.phoneController, // Placeholder
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      controller: widget.passwordController,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Confirmation de mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      controller: widget.confirmPasswordController,
                    ),

                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          // Blue color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          registerUser(
                            context: context,
                            fullname: widget.fullnameController.text.trim(),
                            email: widget.emailController.text.trim(),
                            password: widget.passwordController.text.trim(),
                            passwordConfirmation: widget
                                .confirmPasswordController
                                .text
                                .trim(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoading ? 'Chargement...' : 'S’inscrire',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Bottom link
                    Center(
                      child: Wrap(
                        children: [
                          const Text("Vous avez déjà un compte? "),
                          GestureDetector(
                            onTap: () {
                              context.go('/login');
                            },
                            child: Text(
                              "Se connecter",
                              style: TextStyle(color: AppConfig.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerUser({
    required BuildContext context,
    required String fullname,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    // Handle registration logic here

    setState(() {
      isLoading = true;
    });

    if (email.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        passwordConfirmation.isEmpty) {
      _showMessage(context, "Veuillez remplir tous les champs.");
      setState(() {
        isLoading = false;
      });
      return;
    }
    String apiUrl = "${AppConfig.baseUrl}auth/register";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["data"]["token"] != null && data["data"]["user"] != null) {
          // Sauvegarde dans SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", data["data"]["token"]);
          await prefs.setString("user", data["data"]["user"].toString());

          // Redirection vers une page d'accueil par exemple
          context.go('/home');
        } else {
          _showMessage(context, "Réponse invalide du serveur.");
        }
      } else {
        String message = "Erreur: ${response.statusCode}";
        message = data["errors"]["message"];

        _showMessage(context, message);
      }
    } catch (e) {
      _showMessage(context, "Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
