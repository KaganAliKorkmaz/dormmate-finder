import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/info/contact_screen.dart';
import 'screens/info/feedback_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/test/test_confirmation_screen.dart';
import 'screens/test/test_screen.dart';
import 'screens/membership/upgrade_membership_screen.dart';
import 'screens/membership/payment_success_screen.dart';
import 'screens/matches/previous_results_screen.dart';
import 'screens/matches/best_matches_screen.dart';
import 'screens/info/sabanci_dorms_screen.dart';
import 'screens/info/dorm_rules_screen.dart';
import 'screens/membership/membership_features_screen.dart';
import 'config/firebase_options.dart';
import 'config/app_config.dart';
import 'constants/app_routes.dart';
import 'constants/app_colors.dart';
import 'constants/app_dimensions.dart';
import 'utils/logger.dart';
import 'providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FirebaseDatabase database = FirebaseDatabase.instance;
  database.databaseURL = AppConfig.firebaseDatabaseUrl;
  
  SystemChannels.lifecycle.setMessageHandler((msg) async {
    try {
      if (msg == AppLifecycleState.detached.toString() || 
          msg == AppLifecycleState.paused.toString()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('user_status').doc(user.uid).set({
            'isOnline': false,
            'lastSeen': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          Logger.info('User set to offline on app lifecycle change: ${user.uid}');
        }
      } else if (msg == AppLifecycleState.resumed.toString()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('user_status').doc(user.uid).set({
            'isOnline': true,
            'lastSeen': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          Logger.info('User set to online on app resume: ${user.uid}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Error in lifecycle handler', e, stackTrace);
    }
    return null;
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TestProvider()..initializeTest()),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => OnlineStatusProvider()),
      ],
      child: MaterialApp(
        title: 'DormMate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        home: const WelcomeScreen(),
        routes: {
          AppRoutes.welcome: (context) => const WelcomeScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegistrationScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.contact: (context) => const ContactScreen(),
          AppRoutes.feedback: (context) => const FeedbackScreen(),
          AppRoutes.testConfirmation: (context) => const TestConfirmationScreen(),
          AppRoutes.test: (context) => const TestScreen(),
          AppRoutes.upgradeMembership: (context) => const UpgradeMembershipScreen(),
          AppRoutes.paymentSuccess: (context) =>
              const PaymentSuccessScreen(membershipType: 'Premium'),
          AppRoutes.previousResults: (context) => const PreviousResultsScreen(),
          AppRoutes.bestMatches: (context) => const BestMatchesScreen(),
          AppRoutes.dorms: (context) => const SabanciDormsScreen(),
          AppRoutes.rules: (context) => const DormRulesScreen(),
          AppRoutes.membershipFeatures: (context) => MembershipFeaturesScreen(),
        },
      ),
    );
  }
}
