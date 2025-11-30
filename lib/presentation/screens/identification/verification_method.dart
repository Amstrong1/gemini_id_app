import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:id_app/data/services/signaling.dart';
// import 'package:id_app/presentation/screens/identification/video_call_screen.dart';

class VerificationMethodScreen extends StatefulWidget {
  final String selfCallerId;
  const VerificationMethodScreen({super.key, required this.selfCallerId});

  @override
  State<VerificationMethodScreen> createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  // signalling server url
  // final String websocketUrl = "http://192.168.205.241:8080";

  String selectedMethod = "video";

  dynamic incomingSDPOffer;
  final remoteCallerIdTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // listen for incoming video call
    // SignallingService.instance.socket?.on("newCall", (data) {
    //   if (mounted) {
    //     // set SDP Offer of incoming call
    //     setState(() => incomingSDPOffer = data);
    //   }
    // });
  }

  // join Call
  // void _joinCall({
  //   required String callerId,
  //   required String calleeId,
  //   dynamic offer,
  // }) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) =>
  //           CallScreen(callerId: callerId, calleeId: calleeId, offer: offer),
  //     ),
  //   );
  // }

  // void _handleVideoCall() {
  //   final calleeId = remoteCallerIdTextEditingController.text.trim();

  //   if (calleeId.isEmpty) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: const Text("ID requis"),
  //         content: const Text(
  //           "Veuillez entrer l'identifiant de votre interlocuteur.",
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }

  //   _joinCall(callerId: widget.selfCallerId, calleeId: calleeId);
  // }

  @override
  void dispose() {
    remoteCallerIdTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // init signalling service
    // SignallingService.instance.init(
    //   websocketUrl: websocketUrl,
    //   selfCallerID: widget.selfCallerId,
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Logo and App Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 60),
                      const SizedBox(height: 8),
                      const Text(
                        "Je M’identifie",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Success Message
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Identification effectué avec succès",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.check_circle, color: Colors.teal, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choisissez le moyen par lequel vous\nsouhaitez vérifier votre identité",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Method 1 - Video Identification
                  _buildMethodOption(
                    icon: Icons.movie_creation_outlined,
                    title: "Vidéo-identification",
                    value: "video",
                  ),
                  const SizedBox(height: 12),

                  // Method 2 - In-Person Identification
                  _buildMethodOption(
                    icon: Icons.apartment,
                    title: "Identification en agence",
                    value: "in-person",
                  ),
                  const SizedBox(height: 24),

                  // Champ Remote Caller ID (seulement si méthode vidéo sélectionnée)
                  // if (selectedMethod == "video")
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 24),
                  //     child: TextField(
                  //       controller: remoteCallerIdTextEditingController,
                  //       decoration: InputDecoration(
                  //         labelText: "Identifiant de l'interlocuteur",
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (selectedMethod == "video") const SizedBox(height: 16),

                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedMethod == "video") {
                            // _handleVideoCall();
                            context.push('/upload-doc');
                          } else if (selectedMethod == "in-person") {
                            context.push('/in-person-verification');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continuer",
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isSelected = selectedMethod == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () => setState(() => selectedMethod = value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0EA5E9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0EA5E9)
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: selectedMethod,
                onChanged: (val) => setState(() => selectedMethod = val!),
                activeColor: Colors.white,
                fillColor: WidgetStateProperty.all(
                  isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
