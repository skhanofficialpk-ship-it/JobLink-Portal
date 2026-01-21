import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfileDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Signature Dark Gradient
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
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Profile Header Card
                      _buildProfileHeader(),

                      const SizedBox(height: 25),
                      _buildSectionTitle("Professional Information"),

                      // Details Container
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(Icons.history_edu, "Experience", data['Experience']),
                            _buildDivider(),
                            _buildDetailRow(Icons.location_on_outlined, "Base Location", data['Location']),
                            _buildDivider(),
                            _buildDetailRow(Icons.map_outlined, "Detailed Address", data['Additional Location']),
                            _buildDivider(),
                            _buildContactRow(context, Icons.phone_android, "Contact Number", data['Contact']),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      _buildSectionTitle("Profile Summary"),

                      // Bio Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          data['Profile Summary'] ?? 'No bio provided for this profile.',
                          style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          const Text(
            "Candidate Profile",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xFF0F0C29),
              child: Text(
                (data['Full Name'] ?? "U")[0].toUpperCase(),
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            data['Full Name'] ?? 'N/A',
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['Skill / Profession'] ?? 'General',
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.cyanAccent, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Text(value ?? 'N/A', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String label, String? value) {
    String contactNumber = value ?? 'N/A';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.cyanAccent, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Text(contactNumber, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (contactNumber != 'N/A')
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: contactNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Copied: $contactNumber"),
                    backgroundColor: Colors.cyanAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.copy_all_rounded, color: Colors.cyanAccent, size: 22),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 55);
  }
}