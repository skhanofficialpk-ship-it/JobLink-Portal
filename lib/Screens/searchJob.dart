import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joblink_portal/Screens/jobDetails.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  String _sortBy = 'newest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 25),
                _buildSearchBox(),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No jobs found", style: TextStyle(color: Colors.white70)));
                      }

                      // 1. Filtering Logic
                      List<QueryDocumentSnapshot> docs = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final title = (data['jobTitle'] ?? "").toString().toLowerCase();
                        final loc = (data['location'] ?? "").toString().toLowerCase();
                        return title.contains(searchQuery) || loc.contains(searchQuery);
                      }).toList();

                      // 2. SAFE Sorting Logic (Crash Prevention)
                      if (_sortBy == 'newest') {
                        docs.sort((a, b) {
                          final dataA = a.data() as Map<String, dynamic>;
                          final dataB = b.data() as Map<String, dynamic>;

                          Timestamp t1 = dataA.containsKey('createdAt') && dataA['createdAt'] != null
                              ? dataA['createdAt']
                              : Timestamp.now();
                          Timestamp t2 = dataB.containsKey('createdAt') && dataB['createdAt'] != null
                              ? dataB['createdAt']
                              : Timestamp.now();

                          return t2.compareTo(t1);
                        });
                      } else if (_sortBy == 'salary') {
                        docs.sort((a, b) {
                          final sA = double.tryParse((a.data() as Map<String, dynamic>)['Salary']?.toString() ?? '0') ?? 0;
                          final sB = double.tryParse((b.data() as Map<String, dynamic>)['Salary']?.toString() ?? '0') ?? 0;
                          return sB.compareTo(sA);
                        });
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) => _buildJobCard(docs[index].data() as Map<String, dynamic>),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: const PopupMenuThemeData(
                  color: Colors.blueAccent,
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.tune, color: Colors.cyanAccent),
                  onSelected: (value) => setState(() => _sortBy = value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'newest', child: Text('Newest First', style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(value: 'salary', child: Text('Highest Salary', style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Text("Explore Jobs", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const Text("Find your next big move", style: TextStyle(color: Colors.white60, fontSize: 16)),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search title, company...",
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> jobData) {
    // Calculate remaining time
    DateTime? expiryDate;
    if (jobData.containsKey('expiresAt') && jobData['expiresAt'] != null) {
      expiryDate = (jobData['expiresAt'] as Timestamp).toDate();
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobData['jobTitle'] ?? "Untitled",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              jobData['companyName'] ?? "Company",
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.white54),
                const SizedBox(width: 4),
                Text(jobData['location'] ?? "Remote", style: const TextStyle(color: Colors.white54)),
                const Spacer(),
                Text(
                  "Rs. ${jobData['Salary']}",
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
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
              height: 45,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(jobData: jobData))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("View Details", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
