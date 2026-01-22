import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/logger.dart';
import '../constants/app_dimensions.dart';

class OnlineStatusProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  
  List<Map<String, dynamic>> _onlineUsers = [];
  StreamSubscription<QuerySnapshot>? _onlineUsersSubscription;
  StreamSubscription<DatabaseEvent>? _connectedSubscription;
  
  bool _isSetup = false;
  
  List<Map<String, dynamic>> get onlineUsers => _onlineUsers;
  
  OnlineStatusProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null && !_isSetup) {
        _setupOnlineStatus();
        _listenToOnlineUsers();
        _isSetup = true;
      } else if (user == null) {
        _cleanupSubscriptions();
        _isSetup = false;
      }
    });
  }
  
  @override
  void dispose() {
    _cleanupSubscriptions();
    super.dispose();
  }
  
  void _cleanupSubscriptions() {
    _onlineUsersSubscription?.cancel();
    _connectedSubscription?.cancel();
    _onlineUsers = [];
    notifyListeners();
  }
  
  void _setupOnlineStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      final databaseRef = _database.ref().child('status/${user.uid}');
      
      databaseRef.onDisconnect().update({'status': 'offline'});
      databaseRef.update({'status': 'online'});
      
      _connectedSubscription = _database.ref('.info/connected').onValue.listen((event) {
        if (event.snapshot.value == false) {
          return;
        }
        
        databaseRef.onDisconnect().update({'status': 'offline'});
        databaseRef.update({'status': 'online'});
      });
      
      _firestore.collection('user_status').doc(user.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'displayName': user.displayName,
        'email': user.email,
      }, SetOptions(merge: true));
    }
  }
  
  void _listenToOnlineUsers() {
    final user = _auth.currentUser;
    if (user != null) {
      final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: AppDimensions.onlineStatusMinutes));
      final timestamp = Timestamp.fromDate(twoMinutesAgo);
      
      _onlineUsersSubscription = _firestore
        .collection('user_status')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          final List<Map<String, dynamic>> users = [];
          for (var doc in snapshot.docs) {
            if (doc.id != user.uid) {
              final data = doc.data();
              
              bool isRecentlyActive = true;
              if (data['lastSeen'] != null) {
                final lastSeen = data['lastSeen'] as Timestamp;
                isRecentlyActive = lastSeen.compareTo(timestamp) >= 0;
              }
              
              if (isRecentlyActive) {
                users.add({
                  'uid': doc.id,
                  'displayName': data['displayName'] ?? 'Unknown User',
                  'email': data['email'] ?? '',
                  'lastSeen': data['lastSeen'],
                });
              }
            }
          }
          
          _onlineUsers = users;
          notifyListeners();
        }, onError: (error) {
          Logger.error('Error listening to online users', error);
        });
    }
  }
  
  Future<void> updateUserStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _database.ref().child('status/${user.uid}').update({
        'status': isOnline ? 'online' : 'offline',
      });
      
      await _firestore.collection('user_status').doc(user.uid).set({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
  
  Future<bool> getUserOnlineStatus(String userId) async {
    try {
      final doc = await _firestore.collection('user_status').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['isOnline'] == true) {
          if (data['lastSeen'] != null) {
            final lastSeen = data['lastSeen'] as Timestamp;
            final twoMinutesAgo = DateTime.now().subtract(const Duration(seconds: 5));
            return lastSeen.toDate().isAfter(twoMinutesAgo);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      Logger.error('Error checking user status', e);
      return false;
    }
  }
} 