import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Poori screen ka background dark gradient
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Top Header Card (Glassmorphic)
                      _buildHeaderCard(),

                      const SizedBox(height: 25),

                      // Details Section
                      const Text(
                        "Job Overview",
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),

                      _buildInfoTile(Icons.location_on_outlined, "Location", jobData['location'] ?? "Remote"),
                      _buildInfoTile(Icons.payments_outlined, "Offered Salary", "Rs. ${jobData['Salary'] ?? 'Negotiable'}"),
                      _buildContactTile(context, Icons.phone_android_outlined, "Contact Employer", jobData['Contact']),

                      const SizedBox(height: 30),

                      // Description Section
                      const Text(
                        "Job Description",
                        style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          jobData['description'] ?? "No description provided by the employer.",
                          style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 40),
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

  // Custom Modern AppBar
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          const Spacer(),
          const Text(
            "Job Details",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance ke liye
        ],
      ),
    );
  }

  // Header Card with Title and Company
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business_center, size: 45, color: Colors.cyanAccent),
          ),
          const SizedBox(height: 15),
          Text(
            jobData['jobTitle'] ?? "Untitled Job",
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            jobData['companyName'] ?? "Unknown Company",
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Information Tile
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  // Contact Tile with Copy Function
  Widget _buildContactTile(BuildContext context, IconData icon, String label, String? value) {
    String contactNumber = value ?? 'N/A';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 2),
                Text(contactNumber, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (contactNumber != 'N/A')
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: contactNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$contactNumber copied!"),
                    backgroundColor: Colors.cyanAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, color: Colors.cyanAccent, size: 20),
            ),
        ],
      ),
    );
  }
}