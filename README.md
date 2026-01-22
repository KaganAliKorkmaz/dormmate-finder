# DormMate 🏠

A Flutter-based roommate matching application that uses data-driven algorithms to help students find compatible roommates in dormitories.

## 📱 About

DormMate solves the challenge of finding compatible roommates by collecting detailed lifestyle and preference data from students. The app uses clustering and similarity algorithms to match individuals with similar habits and needs, improving living experiences and reducing conflicts among roommates.

## 🎯 Target Audience

- **Students** living in dorms or shared housing who want to ensure they are paired with compatible roommates
- **Housing staff** who oversee housing assignments and wish to streamline the process through data-driven matchings

## ✨ Key Features

### 🔐 User Authentication
- Secure sign-up and login with Firebase Authentication
- User profile management
- Online status tracking

### 📝 Compatibility Test
A comprehensive questionnaire where students provide information about:
- Desired dorm size
- Daily room time preferences
- Music disturbance tolerance
- Sports preferences
- Cleanliness level
- And more lifestyle factors

### 🧮 Matching Algorithm
- **Clustering**: K-Means algorithm groups students based on test results
- **Weighted Similarity**: Calculates similarity scores between student responses to recommend the best possible roommate matches

### 👥 Match Results
- View best matches based on compatibility scores
- Access previous test results
- Detailed compatibility reports (Premium feature)

### 💎 Membership Features
- Free tier with basic matching
- Premium membership with advanced features:
  - Advanced matching algorithm
  - Priority support
  - Unlimited test attempts
  - Detailed compatibility reports
  - Custom profile themes

### 📧 Email Notifications
- Automatic email confirmations for premium membership purchases
- Feedback submission acknowledgments
- Powered by Firebase Cloud Functions and Brevo (SendInBlue)

### 🏫 Dormitory Information
- Information about Sabancı University dormitories
- Dorm rules and regulations
- Contact information

## 🏗️ Project Structure

```
lib/
├── config/              # Configuration files
│   ├── app_config.dart
│   └── firebase_options.dart
├── constants/          # App-wide constants
│   ├── app_colors.dart
│   ├── app_dimensions.dart
│   ├── app_routes.dart
│   ├── app_strings.dart
│   └── app_theme.dart
├── models/             # Data models
│   ├── best_match_model.dart
│   ├── previous_result_model.dart
│   ├── test_result_model.dart
│   └── user_model.dart
├── providers/          # State management (Provider)
│   ├── auth_provider.dart
│   ├── matches_provider.dart
│   ├── online_status_provider.dart
│   ├── providers.dart
│   ├── test_provider.dart
│   └── user_provider.dart
├── screens/            # UI screens
│   ├── auth/          # Authentication screens
│   ├── home/          # Home screen
│   ├── info/          # Information screens
│   ├── matches/       # Match result screens
│   ├── membership/    # Membership screens
│   └── test/          # Test screens
├── services/          # Business logic services
│   └── user_status_service.dart
├── utils/            # Utility classes
│   └── logger.dart
└── main.dart         # App entry point
```

## 🛠️ Technologies & Dependencies

### Core Framework
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language (SDK >=3.2.3 <4.0.0)

### State Management
- **Provider** (^6.1.1) - State management solution

### Firebase Services
- **Firebase Core** - Firebase initialization
- **Cloud Firestore** - NoSQL database for user profiles, test results, and matches
- **Firebase Authentication** - Secure user registration and login
- **Firebase Realtime Database** - Real-time data synchronization for user answers and online status
- **Firebase Cloud Functions** - Serverless backend for email notifications

### UI & Design
- **Google Fonts** (^6.2.1) - Custom typography (Montserrat)
- **Material Design 3** - Modern UI components
- **Google Maps Flutter** (^2.5.3) - Map integration

### Development Tools
- **flutter_lints** (^5.0.0) - Code quality and linting

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.2.3)
- Dart SDK
- Firebase account and project
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/KaganAliKorkmaz/dormmate-finder.git
   cd dormmate-finder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Realtime Database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories
   - Run `flutterfire configure` to generate `firebase_options.dart`

4. **Configure Firebase Realtime Database URL**
   - Update `lib/config/app_config.dart` with your Firebase Realtime Database URL

5. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34

#### iOS
- Minimum iOS version: 12.0
- Requires CocoaPods: `cd ios && pod install`

## 📦 Features Breakdown

### Authentication Flow
1. Welcome screen with app introduction
2. User registration with email and password
3. Secure login with Firebase Authentication
4. User profile creation in Firestore

### Test Flow
1. Test confirmation screen
2. Comprehensive compatibility questionnaire
3. Answer submission and storage
4. Results processing with matching algorithm

### Matching Flow
1. View best matches based on compatibility scores
2. Access previous test results
3. Detailed match information

### Membership Flow
1. Browse membership features
2. Select membership tier (Free/Premium/Pro)
3. Payment processing
4. Email confirmation

## 🔒 Security & Privacy

- Secure authentication with Firebase Auth
- Encrypted data transmission
- User data stored securely in Firestore
- Privacy-first approach to user information

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is part of CS310 Group 14 coursework.

## 👥 Team

CS310 Group 14

## 📞 Contact & Support

For questions or support, please use the in-app feedback feature or contact the development team.

## 🔮 Future Enhancements

- [ ] Enhanced matching algorithm with machine learning
- [ ] Real-time chat between matched users
- [ ] Advanced filtering options
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Push notifications
- [ ] Social media integration

## 📚 Documentation

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)

## 🐛 Known Issues

- Performance optimization needed for large datasets
- Enhanced error handling for network issues
- Improved offline support

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## 🎯 Unique Selling Points

1. **Data-Driven Matching**: Uses advanced algorithms (K-Means clustering + weighted similarity) instead of random pairings
2. **Comprehensive Compatibility Test**: Detailed questionnaire covering multiple lifestyle factors
3. **User-Friendly Interface**: Modern, intuitive UI built with Material Design 3
4. **Real-Time Updates**: Live online status and match updates
5. **Scalable Architecture**: Professional code structure ready for growth

---

**Made with ❤️ using Flutter**
