import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerificationHistoryScreen extends StatefulWidget {
  const VerificationHistoryScreen({super.key});

  @override
  _VerificationHistoryScreenState createState() =>
      _VerificationHistoryScreenState();
}

class _VerificationHistoryScreenState extends State<VerificationHistoryScreen> {
  String selectedTab = 'Terminés'; // "En attente" or "Terminés"
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historyItems = [
      {
        'name': 'Société d’Identification',
        'date': 'Le 12/05/2025 à 12h',
        'method': 'Vidéo-Identification',
        'code': '52DF8KD',
        'status': 'Succès',
      },
      {
        'name': 'Société d’Identification',
        'date': 'Le 12/05/2025 à 12h',
        'method': 'Vidéo-Identification',
        'code': '52DF8KD',
        'status': 'Échec',
      },
    ];
    final List<Map<String, dynamic>> waitingItems = [
      {
        'name': 'Société d’Identification',
        'date': 'Le 12/05/2025 à 12h',
        'method': 'Vidéo-Identification',
        'code': '52DF8KD',
        'status': 'Rappeler',
      },
      {
        'name': 'Société d’Identification',
        'date': 'Le 12/05/2025 à 12h',
        'method': 'Vidéo-Identification',
        'code': '52DF8KD',
        'status': 'Rappeler',
      },
    ];

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
            indicatorColor: Color(0xFF23A4C9),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            indicator: BoxDecoration(
              color: Color(0xFF23A4C9),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFF23A4C9)),
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

                  // History List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: waitingItems.length,
                    itemBuilder: (context, index) {
                      final item = waitingItems[index];
                      return _buildHistoryCard(item);
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: historyItems.length,
                    itemBuilder: (context, index) {
                      final item = historyItems[index];
                      return _buildHistoryCard(item);
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
