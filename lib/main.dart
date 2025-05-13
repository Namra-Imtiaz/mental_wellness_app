import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'features/notification/services/notification_service.dart';
import 'features/homePage/splash_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCUeoRrnEibNZBakS_YaHLtIwf7VvDYum0",
        authDomain: "mental-wellness-app-77f5e.firebaseapp.com",
        projectId: "mental-wellness-app-77f5e",
        storageBucket: "mental-wellness-app-77f5e.firebasestorage.app",
        messagingSenderId: "236136326896",
        appId: "1:236136326896:web:0e7b8c246fabc922bac435",
        measurementId: "G-8CZ1TGKCKT"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  
  // Initialize timezone data
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC'));
  try {
    final now = DateTime.now();
    final timeZoneOffset = now.timeZoneOffset;
    debugPrint('Using timezone offset: $timeZoneOffset');
  } catch (e) {
    debugPrint('Error with timezone: $e');
  }
  
  // Initialize notification service
  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  await notificationService.setupNotificationChannels(); // Setup Android notification channels
  debugPrint('Notification service initialized');
  
  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const MentalWellnessApp());
}

class MentalWellnessApp extends StatefulWidget {
  const MentalWellnessApp({Key? key}) : super(key: key);

  @override
  _MentalWellnessAppState createState() => _MentalWellnessAppState();
}

class _MentalWellnessAppState extends State<MentalWellnessApp> {
  final NotificationService _notificationService = NotificationService();
  
  @override
  void initState() {
    super.initState();
    // Request notification permissions when app starts
    _requestPermissions();
    // Load notification settings from Firestore when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.updateAllNotificationsFromSettings();
    });
  }
  
  Future<void> _requestPermissions() async {
    final permissionsGranted = await _notificationService.requestPermissions();
    debugPrint('Notification permissions granted: $permissionsGranted');
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Wellness',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8F6FF),
        primaryColor: const Color(0xFF9D7CF4),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF9D7CF4),
          secondary: Color(0xFFA48CF1),
          tertiary: Color(0xFFBFA9F9),
        ),
      ),
      home: InitialBrandingSplash(), // Use SplashScreen as the initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}