import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user and uid
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  Future<void> createUserDocument(UserCredential userCredential, String name) async {
    if (userCredential.user != null) {
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": name,
        "email": userCredential.user!.email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> addWaterQualityData(double pH, double tds, double turbidity) async {
    try {
      String uid = getCurrentUid();

      await _firestore.collection("users").doc(uid).collection("water_quality").add({
        "timestamp": FieldValue.serverTimestamp(),
        "pH Level": pH,
        "TDS": tds,
        "Turbidity": turbidity,
      });

      print("Water quality data added successfully!");
    } catch (e) {
      print("Error adding water quality data: $e");
    }
  }


  // ✅ Retrieve Water Quality Data as Stream
  Stream<QuerySnapshot> getWaterQualityData() {
    String uid = getCurrentUid();
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("water_quality")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  //sign out
  Future<void> signOut() async{
    return await _auth.signOut();
  }
  }