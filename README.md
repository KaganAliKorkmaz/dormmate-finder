# DormMate Finder 🏠

**DormMate Finder** is a Flutter-based roommate matching application designed to help students find compatible roommates in dormitories and shared housing environments using data-driven matching algorithms.

---

## 📋 Overview

Finding a compatible roommate is often challenging due to differences in lifestyle, habits, and personal preferences.  
DormMate Finder addresses this problem by collecting structured user data and applying clustering and similarity-based algorithms to recommend the most compatible roommate matches.

The application focuses on improving living experiences, reducing conflicts, and supporting more informed housing decisions.

---

## 🎯 Target Users

- Students living in dormitories or shared housing
- Housing administrators seeking data-driven roommate assignment support

---

## ✨ Key Features

- **User Authentication**
  - Secure sign-up and login using Firebase Authentication
  - User profile management
  - Online status tracking

- **Compatibility Questionnaire**
  - Lifestyle and preference-based survey including:
    - Dorm size preferences
    - Daily room usage
    - Noise tolerance
    - Cleanliness habits
    - Sports and activity preferences

- **Matching System**
  - K-Means clustering to group similar users
  - Weighted similarity scoring to rank compatibility between users

- **Match Results**
  - Recommended roommate matches with compatibility scores
  - Access to previous test results
  - Detailed compatibility summaries (premium feature)

- **Membership System**
  - Free tier with basic matching
  - Premium tier with advanced matching, reports, and additional features

- **Email Notifications**
  - Automated emails for membership actions and feedback
  - Implemented via Firebase Cloud Functions

- **Dormitory Information**
  - Dormitory details, rules, and contact information

---

## 🛠️ Technology Stack

### Mobile Application
- **Flutter**
- **Dart**

### State Management
- **Provider**

### Backend & Services
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Realtime Database**
- **Firebase Cloud Functions**

### UI & Design
- **Material Design 3**
- **Google Fonts**

---

## 🏗️ Architecture Highlights

- Modular and scalable Flutter project structure
- Separation of concerns using models, providers, services, and UI layers
- Real-time data synchronization for user status and test results
- Cloud-based backend with serverless functions

---

## 🔒 Security & Privacy

- Secure authentication via Firebase
- Encrypted data transmission
- Privacy-focused handling of user information
- No sensitive credentials stored on the client

---

## 🚀 Supported Platforms

- Android  
- iOS  
- Web  
- Desktop (macOS, Windows, Linux)

---

## 🔮 Future Improvements

- Machine learning–based matching enhancements
- Real-time chat between matched users
- Advanced filtering and recommendation options
- Multi-language support
- Push notifications
- Dark mode

---

## 📄 License

This project was developed as part of **CS310 coursework** and is intended for educational and demonstration purposes.

---

## 👤 Project Type

Academic group project focused on **mobile development**, **data-driven matching**, and **scalable application design**.

---

**Built with Flutter and Firebase**
