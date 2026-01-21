import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostProfileScreen extends StatefulWidget {
  const PostProfileScreen({super.key});

  @override
  State<PostProfileScreen> createState() => _PostProfileScreenState();
}

class _PostProfileScreenState extends State<PostProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addLocationController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  final List<String> allCities = [
    "Abbottabad", "Ahmedpur East", "Akhunabad", "Alipur", "Alipur Chatha", "Ali Khan Abad", "Arifwala", "Attock", "Awaran", "Badin",
    "Bahawalnagar", "Bahawalpur", "Bakhsh Town (Karachi East)", "Bakrani", "Baldia Town (Karachi West)", "Bannu", "Barikot", "Basirpur", "Bastorian", "Bela",
    "Bhakkar", "Bhalwal", "Bhimber", "Burewala", "Cantt (Karachi South)", "Chak Jhumra", "Chakwal", "Chaman", "Chamkani (Peshawar)", "Charsadda","Charbagh",
    "Chichawatni", "Chiniot", "Chishtian", "Chitral", "Chunian", "Dadu", "Dajkot", "Dargai", "Darya Khan", "Daska",
    "Dera Ghazi Khan", "Dera Ismail Khan", "Dera Murad Jamali", "DHA (Karachi South)", "Dhabeji (Malir)", "Digri", "Dina", "Dinga", "Dir", "Dubai Town",
    "Dunyapur", "Faisalabad", "Fateh Jang", "Ferozewala", "Gambat", "Gambar Shah Jamali", "Ghakhar Mandi", "Gharo", "Ghotki", "Gilgit",
    "Gojra", "Gujar Khan", "Gujranwala", "Gujrat", "Gwadar", "Habibabad", "Hafizabad", "Hala", "Hangu", "Haripur",
    "Harnai", "Hasilpur", "Hassan Abdal", "Havelian", "Hayatabad (Peshawar)", "Hazro", "Hinglaj", "Hingorja", "Hub", "Hujra Shah Muqeem",
    "Hyderabad", "Islamabad", "Jacobabad", "Jahanian", "Jalalpur Jattan", "Jalalpur Pirwala", "Jamesabad", "Jamshoro", "Jampur", "Jaranwala",
    "Jatoi", "Jauharabad", "Jhang", "Jhelum", "Jiwani", "Johi", "Kabal (Swat)", "Kadam", "Kahuta", "Kalabagh",
    "Kallar Kahar", "Kallar Syedan", "Kalat", "Kamber Shahdadkot", "Kamokey", "Kamra", "Kandhkot", "Karachi", "Karachi Central", "Karachi East",
    "Karachi South", "Karachi West", "Karak", "Karor Lal Esan", "Kashmore", "Kasur", "Kerman", "Keti Bander", "Khairpur", "Khairpur Nathan Shah",
    "Khairpur Tamewali", "Khanewal", "Khanpur", "Kharadar (Karachi South)", "Kharian", "Khar", "Khipro", "Khushab", "Khuzdar", "Kohat",
    "Kohlu", "Kot Addu", "Kotli", "Kotli Sattian", "Kotri", "Kulachi", "Kunri", "Lahore", "Lakki Marwat", "Lalamusa",
    "Larkana", "Latifabad (Hyderabad)", "Layyah", "Liaquatabad (Karachi Central)", "Liaquatpur", "Lodhran", "Loralai", "Mailsi", "Malakand", "Malir",
    "Mandi Bahauddin", "Mandra", "Mansa", "Mansehra", "Mardan", "Mastung", "Matli", "Mehar", "Meerut", "Mian Channu",
    "Mianwali", "Mingora", "Miranshah", "Mirpur Khas", "Mirpur Mathelo", "Mithi", "Moro", "Multan", "Muridke", "Murree",
    "Muzaffarabad", "Muzaffargarh", "Nankana Sahib", "Narowal", "Naushahro Feroze", "Nawabshah (Shaheed Benazirabad)", "New Mirpur", "Nooriabad", "Nowshera", "Okara",
    "Orangi Town (Karachi West)", "Pabbi", "Pakpattan", "Pano Aqil", "Pasni", "Pasrur", "Pattoki", "Peshawar", "Pishin", "Pithoro",
    "Qasimabad (Hyderabad)", "Qila Didar Singh", "Quetta", "Rabwah", "Rahim Yar Khan", "Raiwind", "Rajanpur", "Ratodero", "Rawalakot", "Rawalpindi",
    "Renala Khurd", "Risalpur", "Rohi", "Sadiqabad", "Safoora (Karachi East)", "Sahiwal", "Sakrand", "Samaro", "Samundri", "Sanghar",
    "Sangla Hill", "Sanjwal", "Sarai Alamgir", "Sargodha", "Sehwan Sharif", "Shabqadar", "Shahdadkot", "Shahdadpur", "Shah Faisal Colony (Karachi East)", "Shah Latif Town (Malir)",
    "Shahpur", "Shakargarh", "Sheikhupura", "Shikarpur", "Shor Kot", "Shujabad", "Sialkot", "Sibi", "Sindhri", "Skardu",
    "Sohawa", "Sojawal", "Sukkur", "Swabi", "Swat", "Takht-i-Bahi", "Talagang", "Talhar", "Tando Adam", "Tando Allahyar",
    "Tando Bago", "Tando Jam", "Tank", "Taunsa Sharif", "Taxila", "Thal", "Thatta", "Timergara", "Toba Tek Singh", "Topi",
    "Turbat", "Ubauro", "Uch Sharif", "Umerkot", "Usta Mohammad", "Vehari", "Wah Cantt", "Warah", "Wazirabad", "Zafarwal",
    "Zhob", "Ziarat"
  ];

  List<String> filteredCities = [];

  void _onLocationChanged(String value) {
    setState(() {
      filteredCities = allCities
          .where((city) => city.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> postProfileToFirestore() async {
    if (nameController.text.isEmpty ||
        skillController.text.isEmpty ||
        locationController.text.isEmpty) {
      _showSnackBar("Please fill all required fields", Colors.orangeAccent);
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );

      await FirebaseFirestore.instance.collection('PostProfile').add({
        'userId': currentUser?.uid,
        'Full Name': nameController.text.trim(),
        'Skill / Profession': skillController.text.trim(),
        'Experience': expController.text.trim(),
        'Contact': contactController.text.trim(),
        'Location': locationController.text.trim(),
        'Additional Location': addLocationController.text.trim(),
        'Profile Summary': summaryController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      _showSnackBar("Profile Posted Successfully!", Colors.greenAccent);

      _clearFields();
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar("Error: ${e.toString()}", Colors.redAccent);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: color,
      ),
    );
  }

  void _clearFields() {
    nameController.clear();
    skillController.clear();
    expController.clear();
    contactController.clear();
    locationController.clear();
    addLocationController.clear();
    summaryController.clear();
    setState(() => filteredCities.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 30),

                _inputField("Full Name", "Enter your name", nameController,
                    Icons.person),
                _inputField("Skill / Profession", "e.g. Graphics Designer",
                    skillController, Icons.work_outline),
                _inputField("Experience", "e.g. 2 Years", expController,
                    Icons.timeline),
                _inputField("Contact", "03xx-xxxxxxx", contactController,
                    Icons.phone_android,
                    keyboardType: TextInputType.phone),

                // Location with dropdown
                Stack(
                  children: [
                    _inputField("Location", "Search City", locationController,
                        Icons.location_on_outlined,
                        onChanged: _onLocationChanged),
                    if (filteredCities.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 85),
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(filteredCities[index],
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              setState(() {
                                locationController.text = filteredCities[index];
                                filteredCities.clear();
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),

                _inputField("Additional Location", "Optional",
                    addLocationController, Icons.map_outlined),

                _inputField(
                  "Profile Summary",
                  "Write short summary...",
                  summaryController,
                  Icons.description_outlined,
                  maxLines: 5,
                  isMultiline: true,
                ),

                const SizedBox(height: 30),
                _buildPublishButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        const Text("Add Profile Post",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _inputField(
      String label,
      String hint,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
        Function(String)? onChanged,
        TextInputType keyboardType = TextInputType.text,
        bool isMultiline = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              onChanged: onChanged,
              keyboardType:
              isMultiline ? TextInputType.multiline : keyboardType,
              textInputAction:
              isMultiline ? TextInputAction.newline : TextInputAction.next,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                const TextStyle(color: Colors.white24, fontSize: 14),
                prefixIcon: Icon(icon, color: Colors.white54, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: postProfileToFirestore,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          shadowColor: Colors.cyanAccent.withOpacity(0.4),
        ),
        child: const Text("POST PROFILE",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
