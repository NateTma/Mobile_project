// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/snackbar_service.dart';
import '../services/navigation_service.dart';
import '../services/db_service.dart';

enum AuthStatus {
  // ignore: duplicate_ignore
  // ignore: constant_identifier_names
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

class AuthProvider extends ChangeNotifier {
  User? user;
  AuthStatus status = AuthStatus.NotAuthenticated;

  late FirebaseAuth _auth;

  static AuthProvider instance = AuthProvider();

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() async {
    if (user != null) {
      await DBService.instance.updateUserLastSeenTime(user!.uid);
      return NavigationService.instance.navigateToReplacement("home");
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = _auth.currentUser!;
    if (user != null) {
      notifyListeners();
      /**await*/ _autoLogin();
    }
  }

  void loginUserWithEmailAndPassword(String email, String password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSnackBarSuccess("Welcome, ${user!.email}");
      await DBService.instance.updateUserLastSeenTime(user!.uid);
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      SnackBarService.instance.showSnackBarError("Error Authenticating");
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String email, String password,
      Future<void> Function(String uid) onSuccess) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user!.uid);
      SnackBarService.instance.showSnackBarSuccess("Welcome, ${user!.email}");
      await DBService.instance.updateUserLastSeenTime(user!.uid);
      NavigationService.instance.goBack();
      NavigationService.instance.navigateToReplacement("home");
    } catch (e) {
      status = AuthStatus.Error;
      user = null;
      SnackBarService.instance.showSnackBarError("Error Registering User");
    }
    notifyListeners();
  }

  Future<void> logoutUser(Future<void> Function() onSuccess) async {
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement("login");
      SnackBarService.instance.showSnackBarSuccess("Logged Out Successfully!");
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out");
    }
    notifyListeners();
  }
}