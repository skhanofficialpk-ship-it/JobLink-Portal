import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final String collection;
  final String docId;
  final Map<String, dynamic> initialData;

  const EditProfileScreen({
    super.key,
    required this.collection,
    required this.docId,
    required this.initialData,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> controllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controllers = {
      'fullName': TextEditingController(text: widget.initialData['Full Name'] ?? ''),
      'experience': TextEditingController(text: widget.initialData['Experience'] ?? ''),
      'contact': TextEditingController(text: widget.initialData['Contact'] ?? ''),
      'location': TextEditingController(text: widget.initialData['Location'] ?? ''),
      'additionalLocation': TextEditingController(text: widget.initialData['Additional Location'] ?? ''),
      'summary': TextEditingController(text: widget.initialData['Profile Summary'] ?? ''),
    };
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedData = {
        'Full Name': controllers['fullName']!.text.trim(),
        'Experience': controllers['experience']!.text.trim(),
        'Contact': controllers['contact']!.text.trim(),
        'Location': controllers['location']!.text.trim(),
        'Additional Location': controllers['additionalLocation']!.text.trim(),
        'Profile Summary': controllers['summary']!.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection(widget.collection).doc(widget.docId).update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.cyanAccent,
        ),
      );

      Navigator.pop(context, updatedData); // Pass updated data back
    } catch (e) {
      debugPrint("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update profile", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF1A1A2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Full Name', 'fullName'),
              _buildTextField('Experience', 'experience'),
              _buildTextField('Contact', 'contact', keyboard: TextInputType.phone),
              _buildTextField('Location', 'location'),
              _buildTextField('Additional Location', 'additionalLocation'),
              _buildTextField('Profile Summary', 'summary', maxLines: 4),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[key],
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
