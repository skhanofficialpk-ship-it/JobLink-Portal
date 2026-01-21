import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostScreen extends StatefulWidget {
  final String collection;
  final String docId;
  final Map<String, dynamic> initialData;

  const EditPostScreen({
    super.key,
    required this.collection,
    required this.docId,
    required this.initialData,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController jobTitleController;
  late TextEditingController jobDescController;
  late TextEditingController companyNameController;
  late TextEditingController salaryController;
  late TextEditingController locationController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    // Load existing data
    jobTitleController = TextEditingController(text: widget.initialData['jobTitle'] ?? '');
    jobDescController = TextEditingController(text: widget.initialData['description'] ?? '');
    contactController = TextEditingController(text: widget.initialData['Contact'] ?? '');
    companyNameController = TextEditingController(text: widget.initialData['companyName'] ?? '');
    salaryController = TextEditingController(text: widget.initialData['Salary'] ?? '');
    locationController = TextEditingController(text: widget.initialData['location'] ?? '');
  }

  Future<void> updatePost() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.docId)
        .update({
      "jobTitle": jobTitleController.text.trim(),
      "description": jobDescController.text.trim(),
      "companyName": companyNameController.text.trim(),
      "Salary": salaryController.text.trim(),
      "location": locationController.text.trim(),
      "Contact": contactController.text.trim(),
      "updatedAt": DateTime.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Post updated successfully", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration fieldStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyanAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0C29),
        title: const Text("Edit Post", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: jobTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Job Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: contactController,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Contact Number"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: companyNameController,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Company Name"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: salaryController,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Salary"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: locationController,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Location"),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: jobDescController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: fieldStyle("Job Description"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: updatePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                child: const Text("Update Post", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
