import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joblink_portal/Screens/employeeDetails.dart';

class SearchEmployeeScreen extends StatefulWidget {
  const SearchEmployeeScreen({super.key});

  @override
  State<SearchEmployeeScreen> createState() => _SearchEmployeeScreenState();
}

class _SearchEmployeeScreenState extends State<SearchEmployeeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    String _sortBy = 'newest';
    return Scaffold(
      body: Container(
        // Purple & Navy Dark Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search name, skill or location...",
                      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('PostProfile').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState("No profiles found");
                    }

                    var filteredDocs = snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      // Expiry Logic
                      bool isExpired = false;
                      if (data.containsKey('expiresAt') && data['expiresAt'] != null) {
                        DateTime expiryDate = (data['expiresAt'] as Timestamp).toDate();
                        if (expiryDate.isBefore(DateTime.now())) isExpired = true;
                      }

                      // Search Logic
                      String name = (data['Full Name'] ?? "").toString().toLowerCase();
                      String skill = (data['Skill / Profession'] ?? "").toString().toLowerCase();
                      String location = (data['Location'] ?? "").toString().toLowerCase();
                      bool matchesSearch = name.contains(searchQuery) || skill.contains(searchQuery) || location.contains(searchQuery);

                      return !isExpired && matchesSearch;
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return _buildEmptyState("No active profiles match your search");
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        var data = filteredDocs[index].data() as Map<String, dynamic>;
                        return _employeeCard(data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            "Find Talent",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> data) {
    // Calculate remaining time
    DateTime? expiryDate;
    if (data.containsKey('expiresAt') && data['expiresAt'] != null) {
      expiryDate = (data['expiresAt'] as Timestamp).toDate();
    }

    String timeLeftText = '';
    if (expiryDate != null) {
      final difference = expiryDate.difference(DateTime.now());
      if (difference.inDays > 0) {
        timeLeftText = '${difference.inDays} days left';
      } else if (difference.inHours > 0) {
        timeLeftText = '${difference.inHours} hours left';
      } else if (difference.inMinutes > 0) {
        timeLeftText = '${difference.inMinutes} minutes left';
      } else {
        timeLeftText = 'Expiring soon';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                child: Text(
                  (data['Full Name'] ?? "U")[0].toUpperCase(),
                  style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['Full Name'] ?? 'Unnamed',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['Skill / Profession'] ?? 'No Skill Mentioned',
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10, height: 1),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconInfo(Icons.work_outline, data['Experience'] ?? 'N/A'),
              _iconInfo(Icons.location_on_outlined, data['Location'] ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 10),

          // Show time left
          if (timeLeftText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                timeLeftText,
                style: TextStyle(
                  color: expiryDate != null && expiryDate.difference(DateTime.now()).inDays <= 1
                      ? Colors.red
                      : Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailScreen(data: data))
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text("VIEW FULL PROFILE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 15),
          Text(message, style: const TextStyle(color: Colors.white24, fontSize: 16)),
        ],
      ),
    );
  }
}
