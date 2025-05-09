import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  late AnimationController _animationController;
  bool isLoading = true;

  // Notification settings
  bool dailyReminderEnabled = false;
  bool motivationalQuotesEnabled = false;  
  bool therapyCheckinsEnabled = false;
  TimeOfDay reminderTime = TimeOfDay(hour: 9, minute: 0);
  
  // Define theme colors to match home_page.dart
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..forward();
    
    // Request permissions when page loads
    _requestNotificationPermissions();
    
    // Load user notification preferences
    _loadNotificationSettings();
  }
  
  Future<void> _requestNotificationPermissions() async {
    await _notificationService.requestPermissions();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() {
      isLoading = true;
    });
    
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
          setState(() {
            dailyReminderEnabled = data['dailyReminder'] ?? false;
            motivationalQuotesEnabled = data['motivationalQuotes'] ?? false;
            therapyCheckinsEnabled = data['therapyCheckins'] ?? false;
            
            // Parse time
            if (data['reminderTimeHour'] != null && data['reminderTimeMinute'] != null) {
              reminderTime = TimeOfDay(
                hour: data['reminderTimeHour'],
                minute: data['reminderTimeMinute'],
              );
            }
          });
        }
      }
    } catch (e) {
      print('Error loading notification settings: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _saveNotificationSettings() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('settings')
            .doc('notifications')
            .set({
              'dailyReminder': dailyReminderEnabled,
              'motivationalQuotes': motivationalQuotesEnabled,
              'therapyCheckins': therapyCheckinsEnabled,
              'reminderTimeHour': reminderTime.hour,
              'reminderTimeMinute': reminderTime.minute,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
        
        // Update notifications using the service
        await _notificationService.updateDailyReminder(dailyReminderEnabled, reminderTime);
        await _notificationService.updateMotivationalQuotes(motivationalQuotesEnabled);
        await _notificationService.updateTherapyCheckins(therapyCheckinsEnabled);
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification settings saved!'),
            backgroundColor: darkPurple,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _selectReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkPurple,
              onPrimary: Colors.white,
              onSurface: Color(0xFF333333),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: darkPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null && pickedTime != reminderTime) {
      setState(() {
        reminderTime = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightPurple, Color(0xFFF0E9FF)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: darkPurple))
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSettingsCard(),
                              SizedBox(height: 24),
                              _buildTestNotificationButton(),
                              SizedBox(height: 16),
                              _buildSaveButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: darkPurple.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: darkPurple,
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.1, 0.6, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1, 0.6, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: darkPurple.withOpacity(0.12),
                blurRadius: 16,
                offset: Offset(0, 8),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: 22,
                      color: darkPurple,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Notification Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildSwitchTile(
                title: "Daily Wellness Reminder",
                subtitle: "Get reminded to check in daily",
                value: dailyReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    dailyReminderEnabled = value;
                  });
                },
              ),
              Divider(height: 24),
              _buildSwitchTile(
                title: "Motivational Quotes",
                subtitle: "Receive inspirational quotes",
                value: motivationalQuotesEnabled,
                onChanged: (value) {
                  setState(() {
                    motivationalQuotesEnabled = value;
                  });
                },
              ),
              Divider(height: 24),
              _buildSwitchTile(
                title: "Therapy Check-ins",
                subtitle: "Reminders to chat with your AI therapist",
                value: therapyCheckinsEnabled,
                onChanged: (value) {
                  setState(() {
                    therapyCheckinsEnabled = value;
                  });
                },
              ),
              if (dailyReminderEnabled) ...[
                Divider(height: 24),
                _buildTimeSelector(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectReminderTime,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reminder Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "When to send daily",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical:  8,
              ),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: darkPurple.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: darkPurple,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: darkPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
 // Replace _buildTestNotificationButton() in notifications_page.dart
Widget _buildTestNotificationButton() {
  return FadeTransition(
    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    ),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.2, 0.7, curve: Curves.easeOut),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          // children: [
          //   Text(
          //     "Test Notifications",
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //       color: darkPurple,
          //     ),
          //   ),
          //   SizedBox(height: 12),
          //   Row(
          //     children: [
          //       Expanded(
          //         child: OutlinedButton(
          //           onPressed: () async {
          //             await _notificationService.showTestNotification();
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(
          //                 content: Text('Immediate test notification sent!'),
          //                 backgroundColor: darkPurple,
          //                 behavior: SnackBarBehavior.floating,
          //                 margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //               )
          //             );
          //           },
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: darkPurple,
          //             side: BorderSide(color: darkPurple),
          //             padding: EdgeInsets.symmetric(vertical: 16),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //           ),
          //           child: Text(
          //             'Immediate',
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 8),
          //       Expanded(
          //         child: OutlinedButton(
          //           onPressed: () async {
          //             await _notificationService.showDelayedTestNotification();
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(
          //                 content: Text('Notification scheduled in 10 seconds!'),
          //                 backgroundColor: darkPurple,
          //                 behavior: SnackBarBehavior.floating,
          //                 margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //               )
          //             );
          //           },
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: darkPurple,
          //             side: BorderSide(color: darkPurple),
          //             padding: EdgeInsets.symmetric(vertical: 16),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //           ),
          //           child: Text(
          //             'Delayed (10s)',
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   SizedBox(height: 8),
          //   OutlinedButton(
          //     onPressed: () async {
          //       await _notificationService.testExactDailyNotification();
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('Daily notification scheduled in 1 minute!'),
          //           backgroundColor: darkPurple,
          //           behavior: SnackBarBehavior.floating,
          //           margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //         )
          //       );
          //     },
          //     style: OutlinedButton.styleFrom(
          //       foregroundColor: darkPurple,
          //       side: BorderSide(color: darkPurple),
          //       padding: EdgeInsets.symmetric(vertical: 16),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //     child: Text(
          //       'Test Daily (1 min)',
          //       style: TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ], 
        ),
      ),
    ),
  );
}

  Widget _buildSaveButton() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 0.8, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveNotificationSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: darkPurple.withOpacity(0.4),
            ),
            child: Text(
              'Save Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkPurple,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: darkPurple,
            activeTrackColor: primaryPurple.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}