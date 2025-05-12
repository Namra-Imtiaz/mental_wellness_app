import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize the notification service
  Future<void> init() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();
    
    // Initialize Android settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Initialize iOS settings
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        // handle the received notification when app is in foreground (iOS only)
      },
    );
    
    // Initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    
    // Initialize plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tap
        if (notificationResponse.payload != null) {
          // You can navigate to specific screen based on payload
          debugPrint('Notification payload: ${notificationResponse.payload}');
        }
      },
    );
  }

  // Request permissions on iOS
 // Replace requestPermissions() method in notification_service.dart
Future<bool> requestPermissions() async {
  bool permissionsGranted = false;
  
  // For iOS
  try {
    final iOSImplementation = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iOSImplementation != null) {
      final bool? result = await iOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true, // For high priority notifications
      );
      permissionsGranted = result ?? false;
      debugPrint('iOS permissions request result: $permissionsGranted');
    }
  } catch (e) {
    debugPrint('Error requesting iOS permissions: $e');
  }
  
  // For Android
  try {
    final androidImplementation = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? result = await androidImplementation.requestNotificationsPermission();
      permissionsGranted = result ?? false;
      debugPrint('Android permissions request result: $permissionsGranted');
      
      // For some devices, we need to explicitly request exact alarms permission
      if (await androidImplementation.canScheduleExactNotifications() == false) {
        debugPrint('Device cannot schedule exact notifications - user needs to enable this in settings');
      }
    }
  } catch (e) {
    debugPrint('Error requesting Android permissions: $e');
  }
  
  return permissionsGranted;
}

  // Schedule a periodic notification (alternative approach)
Future<void> schedulePeriodicNotification({
  required int id,
  required String title,
  required String body,
  required RepeatInterval repeatInterval,
  String? payload,
}) async {
  try {
    // Cancel any existing notification with this ID
    await flutterLocalNotificationsPlugin.cancel(id);
    
    // Create notification details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'mental_wellness_periodic_channel',
      'Mental Wellness Periodic Reminders',
      channelDescription: 'Periodic reminders for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    
    debugPrint('Scheduling periodic notification $id: "$title" with interval $repeatInterval');
    
    // Use periodic notification scheduling
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
    
    debugPrint('Successfully scheduled periodic notification $id');
  } catch (e) {
    debugPrint('Error scheduling periodic notification: $e');
  }
}

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'mental_wellness_channel',
      'Mental Wellness Notifications',
      channelDescription: 'Notifications for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule a daily notification
 // Schedule a daily notification
// Replace scheduleDailyNotification method in notification_service.dart
Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required TimeOfDay timeOfDay,
  String? payload,
}) async {
  try {
    // Cancel any existing notification with this ID
    await flutterLocalNotificationsPlugin.cancel(id);
    
    // Create notification details
    final androidNotificationDetails = AndroidNotificationDetails(
      'mental_wellness_daily_channel',
      'Mental Wellness Daily Reminders',
      channelDescription: 'Daily reminders for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
    );

    final darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Get the current time zone
    final location = tz.local;
    
    // Calculate the next occurrence of the specified time
    final now = DateTime.now();
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(tz.TZDateTime.now(location))) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    
    debugPrint('Scheduling daily notification $id: "$title" at ${scheduledDate.toString()} in timezone ${location.name}');
    
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    debugPrint('Successfully scheduled daily notification $id');
  } catch (e) {
    debugPrint('Error scheduling daily notification: $e');
  }
}
  
  // Schedule or cancel a daily reminder based on settings
  // Schedule or cancel a daily reminder based on settings
Future<void> updateDailyReminder(bool isEnabled, TimeOfDay reminderTime) async {
  const int dailyReminderId = 101; // Changed from 1 to avoid potential ID conflicts
  
  if (isEnabled) {
    // Try using both approaches for maximum reliability
    await scheduleDailyNotification(
      id: dailyReminderId,
      title: 'Daily Wellness Reminder',
      body: 'Take a moment to check in with yourself today',
      timeOfDay: reminderTime,
    );
    
    // Also schedule as a daily periodic notification (this is a backup approach)
    await schedulePeriodicNotification(
      id: dailyReminderId + 1000, // Use a different ID for the backup
      title: 'Daily Wellness Reminder',
      body: 'Take a moment to check in with yourself today',
      repeatInterval: RepeatInterval.daily,
    );
  } else {
    await flutterLocalNotificationsPlugin.cancel(dailyReminderId);
    await flutterLocalNotificationsPlugin.cancel(dailyReminderId + 1000);
    debugPrint('Cancelled daily reminder notifications');
  }
}

// Schedule or cancel motivational quotes based on settings
Future<void> updateMotivationalQuotes(bool isEnabled) async {
  const int motivationalQuoteId = 102; // Changed from 2
  
  if (isEnabled) {
    // Schedule for noon every day
    await scheduleDailyNotification(
      id: motivationalQuoteId,
      title: 'Your Daily Inspiration',
      body: 'Every day is a new beginning. Take a deep breath and start again.',
      timeOfDay: TimeOfDay(hour: 12, minute: 0),
    );
    
    // Backup approach
    await schedulePeriodicNotification(
      id: motivationalQuoteId + 1000,
      title: 'Your Daily Inspiration',
      body: 'Every day is a new beginning. Take a deep breath and start again.',
      repeatInterval: RepeatInterval.daily,
    );
  } else {
    await flutterLocalNotificationsPlugin.cancel(motivationalQuoteId);
    await flutterLocalNotificationsPlugin.cancel(motivationalQuoteId + 1000);
    debugPrint('Cancelled motivational quote notifications');
  }
}

// Schedule or cancel therapy check-ins based on settings
Future<void> updateTherapyCheckins(bool isEnabled) async {
  const int therapyCheckinId = 103; // Changed from 3
  
  if (isEnabled) {
    // Schedule for 5 PM every day
    await scheduleDailyNotification(
      id: therapyCheckinId,
      title: 'Therapy Check-in',
      body: 'How are you feeling today? Your AI therapist is ready to chat.',
      timeOfDay: TimeOfDay(hour: 17, minute: 0),
    );
    
    // Backup approach
    await schedulePeriodicNotification(
      id: therapyCheckinId + 1000,
      title: 'Therapy Check-in',
      body: 'How are you feeling today? Your AI therapist is ready to chat.',
      repeatInterval: RepeatInterval.daily,
    );
  } else {
    await flutterLocalNotificationsPlugin.cancel(therapyCheckinId);
    await flutterLocalNotificationsPlugin.cancel(therapyCheckinId + 1000);
    debugPrint('Cancelled therapy check-in notifications');
  }
}
  // Add this method to notification_service.dart after init()
Future<void> setupNotificationChannels() async {
  // Only needed for Android
  final androidImplementation = FlutterLocalNotificationsPlugin()
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  
  if (androidImplementation != null) {
    // Main channel for all notifications
    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        'mental_wellness_channel', // same as used in notification details
        'Mental Wellness Notifications',
        description: 'Notifications for the Mental Wellness App',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        showBadge: true,
      ),
    );
    
    // Daily reminders channel
    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        'mental_wellness_daily_channel',
        'Mental Wellness Daily Reminders',
        description: 'Daily reminders for the Mental Wellness App',
        importance: Importance.high,
        enableVibration: true,
        showBadge: true,
      ),
    );
    
    // Test channel
    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        'mental_wellness_test_channel',
        'Mental Wellness Test Notifications',
        description: 'Test notifications for the Mental Wellness App',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
      ),
    );
    
    debugPrint('Android notification channels created');
  }
}
  // Schedule or cancel motivational quotes based on settings
  // Future<void> updateMotivationalQuotes(bool isEnabled) async {
  //   const int motivationalQuoteId = 2;
    
  //   if (isEnabled) {
  //     // Schedule for noon every day
  //     await scheduleDailyNotification(
  //       id: motivationalQuoteId,
  //       title: 'Your Daily Inspiration',
  //       body: 'Every day is a new beginning. Take a deep breath and start again.',
  //       timeOfDay: TimeOfDay(hour: 12, minute: 0),
  //     );
  //   } else {
  //     await flutterLocalNotificationsPlugin.cancel(motivationalQuoteId);
  //   }
  // }
  
  // Schedule or cancel therapy check-ins based on settings
  // Future<void> updateTherapyCheckins(bool isEnabled) async {
  //   const int therapyCheckinId = 3;
    
  //   if (isEnabled) {
  //     // Schedule for 5 PM every other day
  //     await scheduleDailyNotification(
  //       id: therapyCheckinId,
  //       title: 'Therapy Check-in',
  //       body: 'How are you feeling today? Your AI therapist is ready to chat.',
  //       timeOfDay: TimeOfDay(hour: 17, minute: 0),
  //     );
  //   } else {
  //     await flutterLocalNotificationsPlugin.cancel(therapyCheckinId);
  //   }
  // }
  

  // Show a test notification that will trigger after a short delay
// This is useful for testing if scheduled notifications work
// Replace the showDelayedTestNotification method in notification_service.dart

// 1. Test immediate notification (shows immediately)
Future<void> showTestNotification() async {
  try {
    const int testId = 998;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'mental_wellness_test_channel',
      'Mental Wellness Test Notifications',
      channelDescription: 'Test notifications for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      category: AndroidNotificationCategory.reminder,
      fullScreenIntent: true, // This will make notification show even if device is locked
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active, // Higher priority on iOS
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    debugPrint('Showing immediate test notification');
    
    await flutterLocalNotificationsPlugin.show(
      testId,
      'Test Notification',
      'This notification should appear immediately. Time: ${DateTime.now().toString()}',
      details,
    );
    
    debugPrint('Immediate test notification sent');
  } catch (e) {
    debugPrint('Error showing test notification: $e');
  }
}

// 2. Test delayed notification (shows after 10 seconds)
// Replace the showDelayedTestNotification method in notification_service.dart
Future<void> showDelayedTestNotification() async {
  try {
    const int testId = 999;
    
    await flutterLocalNotificationsPlugin.cancel(testId);
    
    final androidDetails = AndroidNotificationDetails(
      'mental_wellness_test_channel',
      'Mental Wellness Test Notifications',
      channelDescription: 'Test notifications for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      // On Android 12+ we need to be more explicit about the notification type
      category: AndroidNotificationCategory.reminder,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Use a simpler approach - schedule for exactly 10 seconds from now
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(seconds: 10));
    
    // Create a timezone-aware datetime with explicit timezone
    final location = tz.local;
    final scheduledTzDate = tz.TZDateTime.from(scheduledTime, location);
    
    debugPrint('Scheduling test notification to appear at ${scheduledTzDate.toString()} with timezone ${location.name}');
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      testId,
      'Scheduled Test',
      'This notification should appear 10 seconds after being created',
      scheduledTzDate,
      details,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    
    debugPrint('Successfully scheduled test notification');
  } catch (e) {
    debugPrint('Error scheduling test notification: $e');
  }
}

// Replace testExactDailyNotification method
Future<bool> testExactDailyNotification() async {
  try {
    const int testId = 997;
    
    await flutterLocalNotificationsPlugin.cancel(testId);
    
    final androidDetails = AndroidNotificationDetails(
      'mental_wellness_daily_channel',
      'Mental Wellness Daily Reminders',
      channelDescription: 'Daily reminders for the Mental Wellness App',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for exactly 1 minute from now
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: 1));
    
    // Create a timezone-aware datetime
    final location = tz.local;
    final scheduledTzDate = tz.TZDateTime.from(scheduledTime, location);
    
    debugPrint('Scheduling daily test notification at ${scheduledTzDate.toString()}');
    
    // First try a direct approach without matchDateTimeComponents
    await flutterLocalNotificationsPlugin.zonedSchedule(
      testId,
      'Test Daily Notification',
      'This is testing the daily notification mechanism',
      scheduledTzDate,
      details,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    
    debugPrint('Daily test notification scheduled');
    return true;
  } catch (e) {
    debugPrint('Error scheduling daily test notification: $e');
    return false;
  }
}

  // Update all notifications based on user settings
  Future<void> updateAllNotificationsFromSettings() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot notifSnapshot = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('settings')
            .doc('notifications')
            .get();
            
        if (notifSnapshot.exists) {
          Map<String, dynamic> data = notifSnapshot.data() as Map<String, dynamic>;
          
          bool dailyReminderEnabled = data['dailyReminder'] ?? false;
          bool motivationalQuotesEnabled = data['motivationalQuotes'] ?? false;
          bool therapyCheckinsEnabled = data['therapyCheckins'] ?? false;
          
          // Parse time
          TimeOfDay reminderTime = TimeOfDay(hour: 9, minute: 0); // Default
          if (data['reminderTimeHour'] != null && data['reminderTimeMinute'] != null) {
            reminderTime = TimeOfDay(
              hour: data['reminderTimeHour'],
              minute: data['reminderTimeMinute'],
            );
          }
          
          // Update notifications
          await updateDailyReminder(dailyReminderEnabled, reminderTime);
          await updateMotivationalQuotes(motivationalQuotesEnabled);
          await updateTherapyCheckins(therapyCheckinsEnabled);
        }
      }
    } catch (e) {
      debugPrint('Error updating notifications from settings: $e');
    }
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}