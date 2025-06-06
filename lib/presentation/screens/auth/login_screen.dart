import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                        'Connexion',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Connecter vous pour accéder à votre compte',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    // Email
                    TextField(
                      decoration: inputDecoration.copyWith(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
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

                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context.push('/forgot-password');
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          "Mot de passe oublié?",
                          style: TextStyle(color: Color(0xFF23A4C9)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Login Button
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23A4C9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          // Handle login logic here
                          context.push('/home');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Se connecter',
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
                          const Text("Pas encore de compte? "),
                          GestureDetector(
                            onTap: () {
                              context.push('/register');
                            },
                            child: const Text(
                              "S’inscrire",
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
