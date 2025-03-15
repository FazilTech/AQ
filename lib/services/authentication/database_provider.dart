import 'package:aq/models/user.dart';
import 'package:aq/services/authentication/database_service.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier{

  final _db = DataBaseService();

  // USER PROFILE

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioFirebase(bio);
}