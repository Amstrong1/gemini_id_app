import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:id_app/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationHistoryScreen extends StatefulWidget {
  const VerificationHistoryScreen({super.key});

  @override
  _VerificationHistoryScreenState createState() =>
      _VerificationHistoryScreenState();
}

class _VerificationHistoryScreenState extends State<VerificationHistoryScreen> {
  String selectedTab = 'Terminés';
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Map<String, dynamic>>> historyFuture;

  Future<List<Map<String, dynamic>>> getHistory() async {
    final url = Uri.parse("${AppConfig.baseUrl}customer/kycs");

    final token = await AppConfig.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> items = data['data']['items'];
        return items.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to load history");
      }
    } catch (e) {
      throw Exception("Failed to load history: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    historyFuture = getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Historique de vérification',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.pop();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          bottom: TabBar(
            indicatorColor: AppConfig.primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            indicator: BoxDecoration(
              color: AppConfig.primaryColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppConfig.primaryColor),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),

            tabs: [
              Tab(text: 'En attente'),
              Tab(text: 'Terminés'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenu de l'onglet "En attente"
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  FutureBuilder(
                    future: historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Erreur : ${snapshot.error}"),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Aucune entreprise trouvée"),
                        );
                      }
                      final items = snapshot.data!;
                      final waitingItems = items
                          .where((item) => item['status'] == 'En attente')
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: waitingItems.length,
                        itemBuilder: (context, index) {
                          final item = waitingItems[index];
                          return _buildHistoryCard(item);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Contenu de l'onglet "Terminés"
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // History List
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Erreur : ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Aucune entreprise trouvée"),
                        );
                      } else {
                        final items = snapshot.data!;
                        final historyItems = items
                            .where((item) => item['status'] == 'Terminé')
                            .toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: historyItems.length,
                          itemBuilder: (context, index) {
                            final item = historyItems[index];
                            return _buildHistoryCard(item);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Rechercher le nom de l’agence',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  // Widget to build each history card

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    Color statusColor = item['status'] == 'Succès'
        ? Colors.green[100]!
        : item['status'] == 'Rappeler'
        ? Color(0xFF23A4C9)
        : Colors.red[100]!;

    Color textColor = item['status'] == 'Succès'
        ? Colors.green
        : item['status'] == 'Rappeler'
        ? Colors.white
        : Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.apartment, color: Colors.blue),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entreprise ou organisme',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          item['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date\n${item['date']}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Méthode\n${item['method']}',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Code\n${item['code']}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(color: textColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
