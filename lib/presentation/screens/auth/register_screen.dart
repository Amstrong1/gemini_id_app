import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'N° Téléphone',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      obscureText: true,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Confirmation de mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF23A4C9,
                          ), // Blue color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Add registration logic
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'S’inscrire',
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
                              context.push('/login');
                            },
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(color: Color(0xFF23A4C9)),
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
}
