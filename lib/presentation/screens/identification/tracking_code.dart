import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TrackingCodeScreen extends StatefulWidget {
  const TrackingCodeScreen({super.key});

  @override
  State<TrackingCodeScreen> createState() => _TrackingCodeScreenState();
}

class _TrackingCodeScreenState extends State<TrackingCodeScreen> {
  String trackingCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 40),
                SizedBox(width: 12),
                Text(
                  "Je M’identifie",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Instruction Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: const [
                  Text(
                    "Veuillez saisir votre numéro de suivi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "qui vous a été fourni par l’entreprise ou l’organisme pour lequel vous souhaitez vous identifier.",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pin Code Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PinCodeTextField(
                appContext: context,
                length: 7,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() => trackingCode = value);
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: Color(0xFF0EA5E9),
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Color(0xFF0EA5E9),
                  activeFillColor: Colors.white,
                  inactiveFillColor: Color(0xFFF5F5F5),
                  selectedFillColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Validate Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: trackingCode.length == 7
                      ? () {
                          context.push('/verification-method');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Valider",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
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
