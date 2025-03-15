import 'package:aq/components/icon_container.dart';
import 'package:aq/components/input_box.dart';
import 'package:aq/components/my_button.dart';
import 'package:aq/components/water_quality_box.dart';
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

  void addWaterQuality(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text(
          "Add Water Quality Data",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newQualityPhController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Ph Value"
                ),
              ),
            TextField(
              controller: newQualityTbController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Tb Value"
                ),
              ),
            TextField(
              controller: newQualityTpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Tp Value"
                ),
              ),
            TextField(
              controller: newQualityD2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "D2 Value"
                ),
              ),
          ],
        ),

        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
            ),

          // cancel button
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

  // Assuming we want to update data for the current user. Use a specific identifier if needed
  DocumentReference userDoc = waterData.doc(currentUser.uid);  // Use currentUser.uid to target a specific user's data

  userDoc.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      // If the document already exists, update the existing data
      userDoc.update({
        "phValue": newQualityPhController.text,
        "tbValue": newQualityTbController.text,
        "tpValue": newQualityTpController.text,
        "d2Value": newQualityD2Controller.text,
        "dateTime": Timestamp.now(), // Optionally update the time
      }).then((_) {
        print("Data successfully updated!");
        Navigator.pop(context);
        clear();
      }).catchError((error) {
        print("Failed to update water data: $error");
      });
    } else {
      // If the document doesn't exist, add it as a new entry
      userDoc.set({
        "phValue": newQualityPhController.text,
        "tbValue": newQualityTbController.text,
        "tpValue": newQualityTpController.text,
        "d2Value": newQualityD2Controller.text,
        "dateTime": Timestamp.now(),
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


  void cancel(){
    Navigator.pop(context);
  }

  void clear(){
    newQualityPhController.clear();
    newQualityTbController.clear();
    newQualityTpController.clear();
    newQualityD2Controller.clear();
  }


  @override
  Widget build(BuildContext context) {

    TextEditingController searchController = TextEditingController();
    AuthService _auth = new AuthService();

    List<String> weekDays = ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"];

    DateTime today = DateTime.now();
    int todayIndex = today.weekday % 7;

    List<Map<String, String>> weekDates = List.generate(7, (index){
      DateTime date = today.subtract(Duration(days: todayIndex - index));
      return{
        "day": weekDays[index],
        "date": DateFormat('dd').format(date),
        "isToday": date.day == today.day ? "true" : "false"
      };
    });

    final User currentUser = FirebaseAuth.instance.currentUser!;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(240, 240, 245, 1),
        
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _auth.signOut, icon: Icon(Icons.logout))
          ],
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: addWaterQuality,
          child: const Icon(Icons.add),
          ),

        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }

                if(!snapshot.hasData || !snapshot.data!.exists){
                  return Center(
                    child: Text(
                      "No user data found.",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

              return  Column(
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
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Wanna see today’s progress?",
                            style: GoogleFonts.sora(fontSize: 15),
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
                        onTap: () {},
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
            
                Row(
                    children: [
                      Expanded(
                        child:Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const[
                              BoxShadow(
                                blurRadius: 6, 
                                spreadRadius: -20, 
                                offset: Offset(0, 6),
                              )
                            ]
                          ),
                          child: InputBoxDecoration(
                                  hintText: "Search...",
                                  obscureText: false,
                                  controller: searchController,
                                  icon: const Icon(Icons.search),
                                  radius: 20,
                                ),
                        ),
                            ),
                        IconContainer(
                          onTap: () {},
                          icon: const Icon(Icons.calendar_month),
                        ),
            
                        const SizedBox(width: 10,)
                    ],
                  ),
            
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                dayData["day"]!,
                                style: GoogleFonts.sora(
                                  color: const Color.fromRGBO(0, 53, 102, 1),
                                  fontSize: 13
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
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            
                const SizedBox(height: 20,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(162, 214, 249, 1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), 
                                blurRadius: 3, 
                                spreadRadius: 2, 
                                offset: const Offset(0, 6),
                              )
                            ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(16, 0, 138, 0.1),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  size: 35,
                                  color: Colors.white,
                                ),
            
                                Text(
                                  '${userData['city'] ?? "City"}, ${userData['country'] ?? "Country"}',
                                  
                                  style: GoogleFonts.sora(
                                    fontSize: 12,
                                    fontWeight:FontWeight.bold
                                  ),
                                )
                              ],
                            )
                          ),
            
                          const SizedBox(height: 15,),
            
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: userData['profileImageUrl'] != null
                                    ? NetworkImage(userData['profileImageUrl'])
                                    : const AssetImage('assets/images/logo.jpeg') as ImageProvider,
                                backgroundColor: Colors.grey[200],
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                children: [
                                  
                                  Text(
                                    "Contaminated",
                                    style: GoogleFonts.sora(
                                    fontSize: 15,
                                    fontWeight:FontWeight.bold,
                                    color: const Color.fromRGBO(0, 53, 102, 1),
                                  ),
                                  ),
                                  
                                  const SizedBox(height: 5,),
                                  
                                  Text(
                                    "Last Updated 2:33",
                                    style: GoogleFonts.sora(
                                      fontSize: 12,
                                      color: const Color.fromRGBO(0, 53, 102, 1),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
            
                          const SizedBox(height: 10,),
            
                          Column(
                            children: [
                              Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(100)
                                  ),
                                ),
                              ),
            
                              const SizedBox(width: 10,),
                              
                              Text(
                                "Tb | Tp | D2",
                                style: GoogleFonts.sora(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                              )
                            ],
                          ),
            
                          const SizedBox(height: 7,),
            
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(100)
                                ),
                              ),
            
                              const SizedBox(width: 10,),
                              
                              Text(
                                "Ph",
                                style: GoogleFonts.sora(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                              )
                            ],
                          ),
                            ],
                          )
            
                        ],
                      ),
                    ),
            
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(240, 255, 181, 1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), 
                                blurRadius: 3, 
                                spreadRadius: 1, 
                                offset: const Offset(0, 6),
                              )
                            ]
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Explore",
                            style: GoogleFonts.sora(
                              fontSize: 20,
                              color: Color.fromRGBO(0, 53, 102, 1),
                              fontWeight: FontWeight.bold
                            ),
                          ),
            
                          Text(
                            "Expore policies \n and \n Organization",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sora(
                              fontSize: 15
                            ),
                          ),
            
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: MyButton(
                              color: const Color.fromRGBO(0, 53, 102, 1),
                              onTap: (){}, 
                              text: "Click"
                              ),
                          )
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20,),

                StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection("water_quality")
    .orderBy("dateTime", descending: true) // Latest first
    .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text("No data available"));
    }

    var waterData = snapshot.data!.docs;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: waterData.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          // Fetch the previous value for comparison (or null if it's the first entry)
          String? previousValue = doc.id != waterData.last.id ? data["phValue"] : null;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              WaterQualityBox(
                title: "PH Value",
                value: data["phValue"],
                iconName: "PH",
                previousValue: previousValue,
              ),
              const SizedBox(width: 10),
              WaterQualityBox(
                title: "Turbidity",
                value: data["tbValue"],
                iconName: "Tb",
                previousValue: previousValue,
              ),
              const SizedBox(width: 10),
              WaterQualityBox(
                title: "Temp",
                value: data["tpValue"],
                iconName: "Tp",
                previousValue: previousValue,
              ),
              const SizedBox(width: 10),
              WaterQualityBox(
                title: "Diss O2",
                value: data["d2Value"],
                iconName: "D2",
                previousValue: previousValue,
              ),
              const SizedBox(width: 10),
            ],
          );
        }).toList(),
      ),
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