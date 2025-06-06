import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Passwords are valid
      final newPassword = _passwordController.text;
      print('Password saved: $newPassword');
      // Handle password update logic
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Nouveau mot de passe',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Veuillez enregistrer un nouveau mot de passe',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 32),

                          /// New password
                          _buildPasswordField(
                            controller: _passwordController,
                            label: 'Nouveau mot de passe',
                            obscureText: _obscurePassword,
                            toggleVisibility: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// Confirm password
                          _buildPasswordField(
                            controller: _confirmController,
                            label: 'Confirmation de mot de passe',
                            obscureText: _obscureConfirm,
                            toggleVisibility: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 60),

                          /// Submit button
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _submit();
                                context.go(
                                  '/login',
                                ); // Navigate to login after submission
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF23A4C9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enregistrer',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un mot de passe';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit comporter au moins 6 caractères';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
