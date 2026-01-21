import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:joblink_portal/Screens/editprofile.dart';
import 'package:joblink_portal/Screens/jobDetails.dart';
import 'package:joblink_portal/Screens/employeeDetails.dart';
import 'editpost.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController aboutController = TextEditingController();
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (image != null) {
        File file = File(image.path);
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child('${currentUser!.uid}.jpg');

        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({'profilePic': downloadUrl});
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.cyanAccent),
            title: const Text("Change Photo",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _pickAndUploadImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text("Remove Photo",
                style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .update({'profilePic': FieldValue.delete()});
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E)
            ],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text("User not found",
                    style: TextStyle(color: Colors.white)),
              );
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 380,
                  pinned: true,
                  backgroundColor: const Color(0xFF0F0C29),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeader(userData),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.cyanAccent,
                        labelColor: Colors.cyanAccent,
                        unselectedLabelColor: Colors.white54,
                        tabs: const [
                          Tab(text: "My Profiles"),
                          Tab(text: "My Job Posts"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyPostsList('PostProfile', Icons.person_search),
                  _buildMyPostsList('jobs', Icons.business_center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> userData) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.cyanAccent),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF0F0C29),
                    backgroundImage: userData['profilePic'] != null
                        ? NetworkImage(userData['profilePic'])
                        : null,
                    child: userData['profilePic'] == null
                        ? const Icon(Icons.person,
                        size: 45, color: Colors.white)
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: _showImageOptions,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.cyanAccent, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              userData['name'] ?? "User",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              userData['email'] ?? "",
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _infoCardWithEdit(
                title: "About Me",
                value: userData['about'] ??
                    "Hey there! I'm using JobLink Portal",
                onEdit: () => _showEditAboutDialog(userData['about'] ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCardWithEdit(
      {required String title,
        required String value,
        required VoidCallback onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit_note,
                    color: Colors.cyanAccent, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  void _showEditAboutDialog(String currentAbout) {
    aboutController.text = currentAbout;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.cyanAccent, width: 0.5)),
        title: const Text("Edit About Me",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: aboutController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
              const Text("Cancel", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .update({'about': aboutController.text.trim()});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPostsList(String collection, IconData icon) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent));
        }

        var docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return _EmptyState(message: "No posts found", icon: icon);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;

            String title;
            String mainSubtitle;

            if (collection == 'PostProfile') {
              title = data['Full Name'] ?? "No Name";
              mainSubtitle = data['Experience'] ?? "No Experience";
            } else {
              title = data['jobTitle'] ?? "Title not specified";
              mainSubtitle = data['companyName'] ?? "Company not specified";
            }

            // Calculate time left
            var timeLeftText = '';
            if (data.containsKey('expiresAt') && data['expiresAt'] != null) {
              DateTime expiryDate = (data['expiresAt'] as Timestamp).toDate();
              final difference = expiryDate.difference(DateTime.now());

              if (difference.inDays > 0) {
                timeLeftText = '${difference.inDays} days left';
              } else if (difference.inHours > 0) {
                timeLeftText = '${difference.inHours} hours left';
              } else if (difference.inMinutes > 0) {
                timeLeftText = '${difference.inMinutes} minutes left';
              } else {
                timeLeftText = 'Expired';
              }
            }

            Widget subtitleWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mainSubtitle, style: const TextStyle(color: Colors.white54)),
                if (timeLeftText.isNotEmpty)
                  Text(
                    timeLeftText,
                    style: TextStyle(
                      color: data.containsKey('expiresAt') &&
                          (data['expiresAt'] as Timestamp)
                              .toDate()
                              .difference(DateTime.now())
                              .inDays <=
                              1
                          ? Colors.red
                          : Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
              ],
            );

            return _itemCard(
              title: title,
              subtitleWidget: subtitleWidget,
              icon: icon,
              onTap: () {
                if (collection == 'jobs') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobDetailsScreen(jobData: data)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileDetailScreen(data: data)));
                }
              },
              onDelete: () => _confirmDelete(collection, docs[index].id),
              onEdit: () {
                if (collection == 'jobs') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostScreen(
                        collection: collection,
                        docId: docs[index].id,
                        initialData: data,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        collection: collection,
                        docId: docs[index].id,
                        initialData: data,
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _itemCard({
    required String title,
    required Widget subtitleWidget,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.cyanAccent),
        ),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: subtitleWidget,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_note, color: Colors.cyanAccent), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: onDelete),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String collection, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("Confirm Delete", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this post?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await FirebaseFirestore.instance.collection(collection).doc(id).delete();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 60, color: Colors.white10),
          const SizedBox(height: 10),
          Text(message, style: const TextStyle(color: Colors.white24)),
        ]));
  }
}
