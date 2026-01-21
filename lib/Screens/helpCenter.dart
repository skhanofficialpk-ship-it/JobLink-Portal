import 'dart:ui';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Wahi signature gradient jo baaki screens par hai
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
              _buildAppBar(),

              // Custom Search Bar
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
                    onChanged: (value) => setState(() => query = value.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search help topics...",
                      hintStyle: const TextStyle(color: Colors.white24),
                      prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (query.isEmpty || "about joblink portal".contains(query))
                        _buildHelpCard(
                          "About JobLink Portal",
                          "JobLink Portal is a job searching and hiring application designed to connect job seekers and employers on a single platform. The app allows users to search for jobs, create profiles, and apply for relevant opportunities.",
                          Icons.info_outline,
                        ),

                      if (query.isEmpty || "common issues".contains(query))
                        _buildHelpCard(
                          "Common Issues & Solutions",
                          "Sometimes users may face issues such as jobs not appearing or profile updates not saving. These are usually caused by internet connectivity problems. Please make sure your connection is stable.",
                          Icons.bug_report_outlined,
                        ),

                      if (query.isEmpty || "job search".contains(query))
                        _buildHelpCard(
                          "Job Search Problems",
                          "If you are unable to find jobs, ensure that you have selected the correct job title, category, and location. Refresh the page or restart the app if the problem continues.",
                          Icons.search_off_outlined,
                        ),

                      if (query.isEmpty || "password reset".contains(query))
                        _buildHelpCard(
                          "Password Reset Guide",
                          "If you didn't receive the reset email, please check your Spam or Junk folder. Sometimes automated emails are filtered by providers. Try requesting again with a valid email.",
                          Icons.lock_reset_outlined,
                        ),

                      if (query.isEmpty || "contact".contains(query))
                        _buildContactCard(),

                      const SizedBox(height: 20),
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

  Widget _buildAppBar() {
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
            "Help Center",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(String title, String description, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
              Icon(icon, color: Colors.cyanAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyanAccent.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Still need help?",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our support team is available 24/7 to assist you.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.email_outlined, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 10),
              const Text(
                "skhanofficial.pk@gmail.com",
                style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}