import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgencySelectionScreen extends StatefulWidget {
  const AgencySelectionScreen({super.key});

  @override
  State<AgencySelectionScreen> createState() => _AgencySelectionScreenState();
}

class _AgencySelectionScreenState extends State<AgencySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> agencies = [
    "Société d'Identification",
    "Société de référence technologique",
    "Société d'Identification",
    "Société d'Identification",
    "Société d'Identification",
  ];

  int? selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildAgencyList(),
                const SizedBox(height: 16),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF1DACE8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 40),
              const SizedBox(width: 12),
              const Text(
                "Je M'identifie",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Choisissez l'agence avec laquelle vous souhaitez faire la vérification",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: "Rechercher le nom de l'agence",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildAgencyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: agencies.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: isSelected
                    ? Border.all(color: const Color(0xFF0EA5E9), width: 1.5)
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: RadioListTile<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged: (val) => setState(() => selectedIndex = val),
                title: Text(agencies[index]),
                activeColor: const Color(0xFF0EA5E9),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 52,
        child: ElevatedButton(
          onPressed: selectedIndex != null
              ? () => context.push('/tracking-code')
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5E9),
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
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
    );
  }
}
