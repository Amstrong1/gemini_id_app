import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_app/app_config.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _otpCode = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      'Mot de passe oublié',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      'assets/images/password_illustration.svg',
                      height: 180,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Veuillez entrer le code de sécurité à 6 chiffres qui a été envoyé à votre adresse e-mail.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) => _otpCode = value,
                      animationType: AnimationType.scale,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        inactiveColor: Colors.grey.shade300,
                        activeColor: Colors.blue,
                        selectedColor: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   'Renvoyer dans $_timer Sec',
                    //   style: TextStyle(color: Colors.grey[700]),
                    // ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // handle OTP submission
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('otpCode', _otpCode);
                          if (_otpCode.length == 6) {
                            // Navigate to the next screen or perform verification
                            context.push('/reset-password');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Veuillez entrer un code valide.',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Envoyer',
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
                    const SizedBox(height: 24),
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
