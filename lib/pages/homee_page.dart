import 'package:aq/components/icon_container.dart';
import 'package:aq/components/my_button.dart';
import 'package:aq/components/search_bar.dart';
import 'package:aq/data/water_quality_box.dart';
import 'package:aq/models/home_quality_analysis.dart';
import 'package:aq/pages/settings_page.dart';
import 'package:aq/services/authentication/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeePage extends StatefulWidget {
  const HomeePage({super.key});

  @override
  State<HomeePage> createState() => _HomeePageState();
}

class _HomeePageState extends State<HomeePage> {
  final newQualityPhController = TextEditingController();
  final newQualityTbController = TextEditingController();
  final newQualityTpController = TextEditingController();
  final newQualityD2Controller = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;

  void addWaterQuality() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Water Quality Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              controller: newQualityTpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Tp Value"),
            ),
            TextField(
              controller: newQualityD2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "D2 Value"),
            ),
          ],
        ),
        actions: [
          // Save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),
          // Cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void save() {
  CollectionReference waterData = FirebaseFirestore.instance.collection("water_quality");

  // Use currentUser.uid as the document ID
  DocumentReference userDoc = waterData.doc(currentUser.uid);

  Timestamp now = Timestamp.now();
  userDoc.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      // Update existing data
      userDoc.update({
        "phValue": newQualityPhController.text.isNotEmpty ? newQualityPhController.text : "0",
        "tbValue": newQualityTbController.text.isNotEmpty ? newQualityTbController.text : "0",
        "tpValue": newQualityTpController.text.isNotEmpty ? newQualityTpController.text : "0",
        "d2Value": newQualityD2Controller.text.isNotEmpty ? newQualityD2Controller.text : "0",
        "dateTime": now,
      }).then((_) {
        print("Data successfully updated!");
        Navigator.pop(context);
        clear();
      }).catchError((error) {
        print("Failed to update water data: $error");
      });
    } else {
      // Add new entry
      userDoc.set({
        "phValue": newQualityPhController.text.isNotEmpty ? newQualityPhController.text : "0",
        "tbValue": newQualityTbController.text.isNotEmpty ? newQualityTbController.text : "0",
        "tpValue": newQualityTpController.text.isNotEmpty ? newQualityTpController.text : "0",
        "d2Value": newQualityD2Controller.text.isNotEmpty ? newQualityD2Controller.text : "0",
        "dateTime": now,
      }).then((_) {
        print("Data successfully added!");
        Navigator.pop(context);
        clear();
      }).catchError((error) {
        print("Failed to add water data: $error");
      });
    }
  }).catchError((error) {
    print("Error fetching data: $error");
  });
}

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newQualityPhController.clear();
    newQualityTbController.clear();
    newQualityTpController.clear();
    newQualityD2Controller.clear();
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
          child:  Icon(Icons.add),
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
                          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingsPage(),)),
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

                  const SizedBox(height: 10,),

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
                        .doc(currentUser.uid) // Fetch data for the current user
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
                              
                              HomeQualityAnalysis(
                                city: userData["city"] ?? "N/A",
                                country: userData["country"] ?? "N/A",
                                userData: userData,
                                waterQualityData: waterData,
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "PH Value",
                                  value: waterData["phValue"] ?? "N/A", // Handle null
                                  iconName: "PH",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Turbidity",
                                  value: waterData["tbValue"] ?? "N/A", // Handle null
                                  iconName: "Tb",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Temp",
                                  value: waterData["tpValue"] ?? "N/A", // Handle null
                                  iconName: "Tp",
                                ),
                                const SizedBox(width: 10),
                                WaterQualityBox(
                                  title: "Diss O2",
                                  value: waterData["d2Value"] ?? "N/A", // Handle null
                                  iconName: "D2",
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}