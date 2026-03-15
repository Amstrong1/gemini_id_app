import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'package:id_app/app_config.dart';
import 'dart:convert';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  String? fileName;
  String? filePath;

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path;
      });
    }
  }

  Future<void> sendFile(String filePath) async {
    final urlUpload = Uri.parse('${AppConfig.baseUrl}file-uploads');

    final token = await AppConfig.getToken();

    final kycGetId = Uri.parse("${AppConfig.baseUrl}customer/kycs");
    String? kycId;

    try {
      final responseKyc = await http.get(
        kycGetId,
        headers: {"Authorization": "Bearer $token"},
      );

      if (responseKyc.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseKyc.body);
        kycId = data["data"]["items"][0]["id"];
      } else {
        print("Erreur lors de la récupération de l'ID du KYC");
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'ID du KYC: $e");
    }
    ;

    final urlKycs = Uri.parse(
      '${AppConfig.baseUrl}customer/kycs/$kycId/add-document',
    );

    var request = http.MultipartRequest("POST", urlUpload);

    // Ajouter le fichier
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      http.StreamedResponse streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Après avoir obtenu l'ID du fichier, vous pouvez l'associer au KYC
        final responseKycs = await http.post(
          urlKycs,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "file_uuid": data["data"]["id"],
            "comments": "Document justificatif",
          }),
        );

        if (responseKycs.statusCode == 201) {
          // Document associé avec succès
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Document associé au KYC avec succès")),
          );
          context.push('/video-screen');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur lors de l'association du document au KYC"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du chargement des agences")),
        );
        throw Exception("Failed to load companies");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des agences")),
      );
      throw Exception("Failed to load companies");
    }
  }

  // late Future<String> uuid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    // Branding
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 60),
                        const SizedBox(width: 8),
                        const Text(
                          "Je M'identifie",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Title
                    Text(
                      'Document justificatif',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    Text(
                      'Veuillez téléverser le document que vous souhaitez utiliser pour effectuer la vérification',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // Upload Area
                    GestureDetector(
                      onTap: pickDocument,
                      child: DottedBorder(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                fileName ?? 'Ajouter le document',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: fileName != null
                                      ? Colors.black
                                      : Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Ou glisser-déposer le fichier (.pdf)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Send Button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (filePath != null) {
                            sendFile(filePath!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Veuillez sélectionner un fichier",
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Envoyer',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
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
}
