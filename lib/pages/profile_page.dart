import 'package:aq/pages/home.dart';
import 'package:aq/pages/profile_edit_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Current User
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
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

          return ListView(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Home())),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 25),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: userData['profileImageUrl'] != null
                          ? NetworkImage(userData['profileImageUrl'])
                          : const AssetImage('assets/images/logo.jpeg') as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['name'] ?? 'No name',
                        style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            userData['city'] ?? 'No city',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const Text(", ", style: TextStyle(fontSize: 20)),
                          Text(
                            userData['country'] ?? 'No country',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ProfileEditPage()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(7, 42, 200, 1),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(7, 42, 200, 1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      "Share Profile",
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text("My Posts", style: TextStyle(color: Colors.grey[600])),
              ),
            ],
          );
        },
      ),
    );
  }
}
