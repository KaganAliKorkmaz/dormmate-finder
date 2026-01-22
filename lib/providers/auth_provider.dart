import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../utils/logger.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<User?>? _authStateSubscription;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;
  
  AuthProvider() {
    _init();
  }
  
  void _init() {
    _user = _auth.currentUser;
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
  
  Future<bool> signUp({
    required String email, 
    required String password, 
    required String username
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await userCredential.user?.updateDisplayName(username);
      
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'totalTests': 0,
        'averageScore': 0.0,
      });
      
      await _firestore.collection('user_status').doc(userCredential.user?.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': username,
        'email': email,
      });
      
      _user = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _firestore.collection('user_status').doc(userCredential.user?.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': userCredential.user?.displayName,
        'email': email,
      });
      
      final userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();
      
      if (userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user?.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'email': email,
          'username': userCredential.user?.displayName ?? 'User',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'totalTests': 0,
          'averageScore': 0.0,
        });
        
        Logger.info('Created new user document for existing auth user: ${userCredential.user?.uid}');
      }
      
      _user = userCredential.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      if (_user != null) {
        await _firestore.collection('user_status').doc(_user!.uid).set({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      
      await _auth.signOut();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e);
      notifyListeners();
    }
  }
  
  String _getAuthErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return AppStrings.noUserFound;
        case 'wrong-password':
          return AppStrings.wrongPassword;
        case 'email-already-in-use':
          return AppStrings.emailAlreadyInUse;
        case 'weak-password':
          return AppStrings.weakPassword;
        case 'invalid-email':
          return AppStrings.invalidEmail;
        case 'operation-not-allowed':
          return AppStrings.operationNotAllowed;
        case 'user-disabled':
          return AppStrings.userDisabled;
        case 'too-many-requests':
          return AppStrings.tooManyRequests;
        case 'network-request-failed':
          return AppStrings.networkError;
        default:
          return '${AppStrings.unknownError}: ${e.code}';
      }
    }
    return '${AppStrings.errorOccurred}: $e';
  }
} 