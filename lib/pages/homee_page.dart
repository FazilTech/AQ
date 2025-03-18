import 'package:aq/components/icon_container.dart';
import 'package:aq/components/my_button.dart';
import 'package:aq/components/search_bar.dart';
import 'package:aq/data/water_quality_box.dart';
import 'package:aq/models/contamination_graph.dart';
import 'package:aq/models/home_quality_analysis.dart';
import 'package:aq/pages/settings_page.dart';
import 'package:aq/services/authentication/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeePage extends StatefulWidget {
  const HomeePage({super.key});

  @override
  State<HomeePage> createState() => _HomeePageState();
}

class _HomeePageState extends State<HomeePage> {
  final newQualityPhController = TextEditingController();
  final newQualityTbController = TextEditingController();
  final newQualityHdController = TextEditingController();
  final newQualitySoController = TextEditingController();
  final newQualityChController = TextEditingController();
  final newQualitySuController = TextEditingController();
  final newQualityCoController = TextEditingController();
  final newQualityOcController = TextEditingController();
  final newQualityTrController = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;

  void addWaterQuality() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Prevents bottom overlay error
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Water Quality Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newQualityPhController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Ph Value"),
              ),
              TextField(
                controller: newQualityTbController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Tb Value"),
              ),
              TextField(
                controller: newQualityHdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Hd Value"),
              ),
              TextField(
                controller: newQualitySoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "So Value"),
              ),
              TextField(
                controller: newQualityChController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Ch Value"),
              ),
              TextField(
                controller: newQualitySuController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Su Value"),
              ),
              TextField(
                controller: newQualityCoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Co Value"),
              ),
              TextField(
                controller: newQualityOcController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Oc Value"),
              ),
              TextField(
                controller: newQualityTrController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Tr Value"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: save,
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: cancel,
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> predictContamination(Map<String, double> data) async {
    const String flaskUrl = "http://192.168.0.202:5555/predict"; // Replace with your Flask server IP

    try {
      print("Sending data to Flask server: $data"); // Debug statement

      final response = await http.post(
        Uri.parse(flaskUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "features": [
            data["phValue"],
            data["tbValue"],
            data["HdValue"],
            data["SoValue"],
            data["ChValue"],
            data["SuValue"],
            data["CoValue"],
            data["OcValue"],
            data["TrValue"],
          ],
        }),
      );

      print("Response status code: ${response.statusCode}"); // Debug statement
      print("Response body: ${response.body}"); // Debug statement

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to get prediction: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during prediction: $e");
      return null;
    }
  }

  void save() async {
    print("Save button clicked"); // Debug statement

    CollectionReference waterData = FirebaseFirestore.instance.collection("water_quality");

    // Use currentUser.uid as the document ID
    DocumentReference userDoc = waterData.doc(currentUser.uid);

    Timestamp now = Timestamp.now();

    // Prepare data for Firestore
    Map<String, dynamic> waterQualityData = {
      "phValue": newQualityPhController.text.isNotEmpty ? newQualityPhController.text : "0",
      "tbValue": newQualityTbController.text.isNotEmpty ? newQualityTbController.text : "0",
      "HdValue": newQualityHdController.text.isNotEmpty ? newQualityHdController.text : "0",
      "SoValue": newQualitySoController.text.isNotEmpty ? newQualitySoController.text : "0",
      "ChValue": newQualityChController.text.isNotEmpty ? newQualityChController.text : "0",
      "SuValue": newQualitySuController.text.isNotEmpty ? newQualitySuController.text : "0",
      "CoValue": newQualityCoController.text.isNotEmpty ? newQualityCoController.text : "0",
      "OcValue": newQualityOcController.text.isNotEmpty ? newQualityOcController.text : "0",
      "TrValue": newQualityTrController.text.isNotEmpty ? newQualityTrController.text : "0",
      "dateTime": now,
    };

    print("Data to be saved: $waterQualityData"); // Debug statement

    try {
      // Send data to Flask for prediction
      final predictionResponse = await predictContamination({
        "phValue": double.tryParse(newQualityPhController.text) ?? 0.0,
        "tbValue": double.tryParse(newQualityTbController.text) ?? 0.0,
        "HdValue": double.tryParse(newQualityHdController.text) ?? 0.0,
        "SoValue": double.tryParse(newQualitySoController.text) ?? 0.0,
        "ChValue": double.tryParse(newQualityChController.text) ?? 0.0,
        "SuValue": double.tryParse(newQualitySuController.text) ?? 0.0,
        "CoValue": double.tryParse(newQualityCoController.text) ?? 0.0,
        "OcValue": double.tryParse(newQualityOcController.text) ?? 0.0,
        "TrValue": double.tryParse(newQualityTrController.text) ?? 0.0,
      });

      print("Prediction response: $predictionResponse"); // Debug statement

      // Save the contamination probability to Firestore
      if (predictionResponse != null) {
        waterQualityData["contam_prob_rf"] = predictionResponse['contam_prob_rf'];
      }

      // Save to main document
      await userDoc.set(waterQualityData, SetOptions(merge: true));

      // Save to history subcollection
      await userDoc.collection("history").add(waterQualityData);

      print("Data saved to Firestore successfully"); // Debug statement

      // Show the prediction result to the user
      if (predictionResponse != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Contamination Prediction"),
            content: Text("Contamination Probability: ${predictionResponse['contam_prob_rf']}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }

      Navigator.pop(context); // Close the dialog
      clear(); // Clear the text fields
    } catch (e) {
      print("Error saving data: $e"); // Debug statement
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to save data: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newQualityPhController.clear();
    newQualityTbController.clear();
    newQualityHdController.clear();
    newQualitySoController.clear();
    newQualityChController.clear();
    newQualitySuController.clear();
    newQualityCoController.clear();
    newQualityOcController.clear();
    newQualityTrController.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    AuthService _auth = AuthService();

    List<String> weekDays = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"];

    DateTime today = DateTime.now();
    int todayIndex = today.weekday % 7;

    List<Map<String, String>> weekDates = List.generate(7, (index) {
      DateTime date = today.subtract(Duration(days: todayIndex - index));
      return {
        "day": weekDays[index],
        "date": DateFormat('dd').format(date),
        "isToday": date.day == today.day ? "true" : "false"
      };
    });

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(240, 240, 245, 1),
        floatingActionButton: FloatingActionButton(
          onPressed: addWaterQuality,
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(162, 214, 249, 1),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    "No user data found.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                );
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                children: [
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi ${userData['name'] ?? "User"}",
                              style: GoogleFonts.sora(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Wanna see today’s progress?",
                              style: GoogleFonts.sora(fontSize: 13),
                            )
                          ],
                        ),
                        const Spacer(),
                        IconContainer(
                          onTap: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                        const SizedBox(width: 10),
                        IconContainer(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MySearchBar(
                        controller: searchController,
                        hintText: "Search",
                        preFixIcon: const Icon(Icons.search),
                      ),
                      IconContainer(
                        onTap: () {},
                        icon: const Icon(Icons.calendar_month),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekDates.map((dayData) {
                        bool isToday = dayData["isToday"] == "true";
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: isToday ? const Color.fromRGBO(162, 214, 249, 1) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  dayData["day"]!,
                                  style: GoogleFonts.sora(
                                    color: const Color.fromRGBO(0, 53, 102, 1),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  dayData["date"]!,
                                  style: GoogleFonts.sora(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("water_quality")
                        .doc(currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text("No data available"));
                      }

                      var waterData = snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: HomeQualityAnalysis(
                                  city: userData["city"] ?? "N/A",
                                  country: userData["country"] ?? "N/A",
                                  userData: userData,
                                  waterQualityData: waterData,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(240, 255, 181, 1),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8,
                                      spreadRadius: -4,
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Explore",
                                      style: GoogleFonts.sora(
                                        fontSize: 18,
                                        color: const Color.fromRGBO(0, 53, 102, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Explore policies \n and \n Organization",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.sora(fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: MyButton(
                                        color: const Color.fromRGBO(0, 53, 102, 1),
                                        onTap: () {},
                                        text: "Click",
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 20),

                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("water_quality")
                                .doc(currentUser.uid)
                                .collection("history")
                                .orderBy("dateTime", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text("No historical data available"));
                              }

                              // Process data for the graph
                              List<Map<String, dynamic>> dataPoints = [];
                              for (var doc in snapshot.data!.docs) {
                                var data = doc.data() as Map<String, dynamic>;
                                dataPoints.add({
                                  "time": (data["dateTime"] as Timestamp).toDate().hour.toDouble(), // Extract hour
                                  "contam_prob_rf": data["contam_prob_rf"] ?? "0.0", // Default to "0.0" if null
                                });
                              }

                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(162, 214, 249, 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 280),
                                          child: Column(
                                            children: [
                                              Text(
                                            "${waterData["contam_prob_rf"] ?? "N/A"}",
                                            style: GoogleFonts.sora(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            "Contamination \nLevel",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sora(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromRGBO(0, 53, 102, 1),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                            const SizedBox(height: 10),
                                            ContaminationGraph(dataPoints: dataPoints),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),

                          const SizedBox(height: 20),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "PH Value",
                                  value: waterData["phValue"] ?? "N/A",
                                  iconName: "PH",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Turbidity",
                                  value: waterData["tbValue"] ?? "N/A",
                                  iconName: "Tb",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Hardness",
                                  value: waterData["HdValue"] ?? "N/A", 
                                  iconName: "Hd",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Solids",
                                  value: waterData["SoValue"] ?? "N/A", 
                                  iconName: "So",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Chlo",
                                  value: waterData["ChValue"] ?? "N/A",
                                  iconName: "Ch",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Sulp",
                                  value: waterData["SuValue"] ?? "N/A",
                                  iconName: "Su",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Conduct",
                                  value: waterData["CoValue"] ?? "N/A", 
                                  iconName: "Co",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Org Car",
                                  value: waterData["OcValue"] ?? "N/A",
                                  iconName: "Oc",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Triha",
                                  value: waterData["TrValue"] ?? "N/A", 
                                  iconName: "Tr",
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,)
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

