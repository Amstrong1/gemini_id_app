import 'package:flutter/material.dart';

void showCustomErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Error Icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Error Message
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      children: [
                        TextSpan(text: 'Erreur l’agence '),
                        TextSpan(
                          text: '"Nom de l’agence"',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' n’accepte pas ce type d’identification',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[600],
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst); // Go to home
                    },
                    child: Text('Retour à l’accueil'),
                  ),
                ],
              ),
            ),

            // Close Icon (top right)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }