import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:id_app/app_config.dart';

class RequestCodeScreen extends StatefulWidget {
  RequestCodeScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<RequestCodeScreen> createState() => _RequestCodeButtonState();
}

class _RequestCodeButtonState extends State<RequestCodeScreen> {
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
                      child: Text(
                        'Mot de passe oublié',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Entrez votre email pour recevoir un code de réinitialisation',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    // Email
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      controller: widget.emailController,
                    ),
                    const SizedBox(height: 16),

                    // RequestCode Button
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // Handle RequestCode logic here
                          requestCodeUser(
                            context: context,
                            email: widget.emailController.text.trim(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoading ? 'Chargement...' : 'Envoyer',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void requestCodeUser({
    required BuildContext context,
    required String email,
  }) async {
    // Handle registration logic here

    setState(() {
      isLoading = true;
    });

    if (email.isEmpty) {
      _showMessage(context, "Veuillez remplir tous les champs.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String apiUrl = "${AppConfig.baseUrl}auth/forgot-password";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String message = data["data"]["message"];

        _showMessage(context, message);
        // Redirection vers une page d'accueil par exemple
        context.push('/forgot-password');
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
}

void _showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
