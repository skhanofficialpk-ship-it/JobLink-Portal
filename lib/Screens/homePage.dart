import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 1. Import karein
import 'package:joblink_portal/Screens/postJob.dart';
import 'package:joblink_portal/Screens/postProfile.dart';
import 'package:joblink_portal/Screens/profile.dart';
import 'package:joblink_portal/Screens/searchEmployee.dart';
import 'package:joblink_portal/Screens/searchJob.dart';
import 'helpCenter.dart';

class homePage extends StatelessWidget {
  homePage({super.key});

  // 2. Link launch karne ka function
  Future<void> _launchRateUs() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.skhan.joblink');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildModernDrawer(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "JobLink Portal",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 20)],
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Find jobs or hire employees easily", style: TextStyle(fontSize: 16, color: Colors.white60)),
                const Spacer(),
                _actionButton(
                  context: context,
                  icon: Icons.search_rounded,
                  title: "Search Job",
                  glowColor: Colors.cyanAccent,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchJobScreen())),
                ),
                const SizedBox(height: 15),
                _actionButton(
                  context: context,
                  icon: Icons.person_search_rounded,
                  title: "Search Employee",
                  glowColor: const Color(0xff11998E),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchEmployeeScreen())),
                ),
                const Spacer(),
                const Text("Built with passion by MR_MJ", style: TextStyle(fontSize: 12, color: Colors.white24)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF24243E)],
          ),
        ),
        child: Column(
          children: [
            _drawerHeader(),
            const SizedBox(height: 10),
            _drawerItem(context, Icons.person_outline, "Profile", const UserProfileScreen()),
            _drawerItem(context, Icons.add_box_outlined, "Post a Job", const PostJobScreen()),
            _drawerItem(context, Icons.badge_outlined, "Post Profile", const PostProfileScreen()),
            _aboutItem(context),
            const Divider(color: Colors.white12, indent: 20, endIndent: 20),
            _drawerItem(context, Icons.help_center_outlined, "Help Center", const HelpCenterScreen()),

            // Rate Us Button
            ListTile(
              leading: const Icon(Icons.star_border_rounded, color: Colors.orangeAccent),
              title: const Text("Rate Us", style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context);
                _launchRateUs();
              },
            ),

            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Exit App", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () async => await FirebaseAuth.instance.signOut(),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent),
            child: const CircleAvatar(radius: 35, backgroundColor: Color(0xFF0F0C29), child: Icon(Icons.work, color: Colors.white, size: 30)),
          ),
          const SizedBox(height: 10),
          const Text("JobLink Portal", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Navigator.pop(context);
        if (screen != null) Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
      },
    );
  }

  Widget _aboutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: Colors.cyanAccent),
      title: const Text("About App", style: TextStyle(color: Colors.white70)),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),

            title: const Text("About JobLink", style: TextStyle(color: Colors.white)),

            content: const Text(
              "JobLink Portal app helps people find and post jobs in one place. Users can create an account, search for openings, contact, and manage their profiles. Employers can post jobs, review candidates. The app is designed with a smooth interface, secure login, and plans for future features like AI job searching and improved job matching. It’s built to make hiring and job searching faster and easier for everyone.",
              style: TextStyle(color: Colors.white70),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cool", style: TextStyle(color: Colors.cyanAccent)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(icon, color: glowColor, size: 28),
                const SizedBox(width: 20),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
