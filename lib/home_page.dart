import 'package:flutter/material.dart';
import 'feature_page.dart';
import 'profile_page.dart';
import 'notifications_page.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_therapy_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedFeelingIndex = -1;
  late AnimationController _animationController;
  final List<String> _feelings = ["😊", "😐", "😕", "😢", "😡"];
  final List<String> _feelingLabels = ["Great", "Okay", "Meh", "Sad", "Angry"];
  String? _feedbackMessage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName="there";
  bool _isProfileActive = false;
  bool _isNotificationActive = false;

  // Define theme colors to match login/signup
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);

  final List<Map<String, String>> _motivationalQuotes = [
    {
      "quote": "Your mind is a garden, your thoughts are the seeds. You can grow flowers or you can grow weeds.",
      "author": "Unknown"
    },
    {
      "quote": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs"
    },
    {
      "quote": "Happiness is not something ready-made. It comes from your own actions.",
      "author": "Dalai Lama"
    },
    {
      "quote": "Your mental health is a priority. Your happiness is essential. Your self-care is a necessity.",
      "author": "Unknown"
    },
    {
      "quote": "You don't have to control your thoughts. You just have to stop letting them control you.",
      "author": "Dan Millman"
    },
    {
      "quote": "Self-care is not self-indulgence, it is self-preservation.",
      "author": "Audre Lorde"
    },
    {
      "quote": "You are not your illness. You have an individual story to tell. You have a name, a history, a personality.",
      "author": "Julian Seifter"
    },
    {
      "quote": "Be gentle with yourself, you're doing the best you can.",
      "author": "Unknown"
    },
    {
      "quote": "What mental health needs is more sunlight, more candor, and more unashamed conversation.",
      "author": "Glenn Close"
    },
    {
      "quote": "Recovery is not one and done. It is a lifelong journey that takes place one day, one step at a time.",
      "author": "Unknown"
    }
  ];

// Add variable to store the current quote
late Map<String, String> _currentQuote;
  
  @override
void initState() {
  super.initState();
  _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 600),
  )..forward();
  
  _setDailyQuote();
  _loadUserData();
}

// Method to set a quote based on the current day or randomly
void _setDailyQuote() {
  final random = Random();
  _currentQuote = _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
}

Future<void> _loadUserData() async {
  try {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = userData['name'] ?? "there";
        });
      }
    }
  } catch (e) {
    print('Error loading user data: $e');
  }
}

// Function to refresh the quote manually
void _refreshQuote() {
  setState(() {
    final random = Random();
    _currentQuote = _motivationalQuotes[random.nextInt(_motivationalQuotes.length)];
  });
}

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E9FF), // Updated to match login/signup background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightPurple, Color(0xFFF0E9FF)], // Match login/signup gradient
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildHeader(),
                      SizedBox(height: 30),
                      _buildWelcomeText(),
                      SizedBox(height: 24),
                      _buildFeelingSelector(),
                      if (_feedbackMessage != null) ...[
                        SizedBox(height: 12),
                        _buildMoodFeedback(),
                      ],
                      SizedBox(height: 24),
                      _buildMotivationalQuoteCard(),
                      SizedBox(height: 24),
                      _buildSectionTitle("Features"),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: _buildFeatureGrid(),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconButton(
          icon: Icons.notifications_outlined,
          isActive: _isNotificationActive,
          onTap: () {
            setState(() {
              _isNotificationActive = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            ).then((_) {
              setState(() {
                _isNotificationActive = false;
              });
            });
          },
          delay: 0.0,
        ),
        _buildProfileButton(delay: 0.1),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required double delay,
    bool isActive = false,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
          ),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? darkPurple.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: darkPurple.withOpacity(0.15),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: isActive ? darkPurple : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive ? darkPurple : primaryPurple,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton({required double delay}) {
  return FadeTransition(
    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
      ),
    ),
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isProfileActive = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          ).then((_) {
            setState(() {
              _isProfileActive = false;
            });
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isProfileActive ? darkPurple.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: darkPurple.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: _isProfileActive ? darkPurple : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person_rounded,
            size: 24,
            color: _isProfileActive ? darkPurple : primaryPurple,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildWelcomeText() {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.2, 0.6, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.2, 0.6, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello $_userName,",
              style: TextStyle(
                fontSize: 18,
                color: darkPurple.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkPurple,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeelingSelector() {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.3, 0.7, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.3, 0.7, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _feelings.length,
              (index) => _buildMoodOption(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(int index) {
    bool isSelected = _selectedFeelingIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFeelingIndex = index;
          
          // Set different feedback message based on selected feeling
          switch(index) {
            case 0:
              _feedbackMessage = "Great! Let's keep that positive energy going!";
              break;
            case 1:
              _feedbackMessage = "Feeling okay is perfectly fine. How can we improve your day?";
              break;
            case 2:
              _feedbackMessage = "Feeling meh? Maybe try one of our mood-boosting activities.";
              break;
            case 3:
              _feedbackMessage = "Sorry you're feeling down. Our guided meditation might help.";
              break;
            case 4:
              _feedbackMessage = "It's okay to feel angry. Try our breathing exercises to cool down.";
              break;
          }
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isSelected ? 60 : 52,
            height: isSelected ? 60 : 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? darkPurple.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.07),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? darkPurple
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: darkPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                _feelings[index],
                style: TextStyle(
                  fontSize: isSelected ? 28 : 24,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? darkPurple : Colors.grey[600],
            ),
            child: Text(_feelingLabels[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodFeedback() {
    return AnimatedOpacity(
      opacity: _feedbackMessage != null ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: darkPurple.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: darkPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: darkPurple,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                _feedbackMessage ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: darkPurple.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuoteCard() {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.4, 0.8, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.4, 0.8, curve: Curves.easeOut),
          ),
        ),
        child: GestureDetector(
          onTap: _refreshQuote,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  darkPurple,
                  primaryPurple,
                ],
                stops: [0.2, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: darkPurple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -15,
                  right: -15,
                  child: Icon(
                    Icons.format_quote,
                    size: 70,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "TODAY'S INSPIRATION",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.refresh,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      _currentQuote["quote"] ?? "Your mind is a garden, your thoughts are the seeds.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "— ${_currentQuote["author"] ?? "Unknown"}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.5, 0.9, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.5, 0.9, curve: Curves.easeOut),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 24,
              decoration: BoxDecoration(
                color: darkPurple,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid _buildFeatureGrid() {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'AI Therapy',
        'icon': Icons.chat_bubble_rounded,
        'description': 'Talk to an AI therapist',
        'iconBgColor': Color(0xFFE8E1FF),
        'iconColor': darkPurple,
      },
      {
        'title': 'Meditation',
        'icon': Icons.self_improvement,
        'description': 'Guided sessions',
        'iconBgColor': Color(0xFFFFE8E5),
        'iconColor': Color(0xFFF5716C),
      },
      {
        'title': 'Anxiety Relief',
        'icon': Icons.healing,
        'description': 'Exercises & techniques',
        'iconBgColor': Color(0xFFE3F4FF),
        'iconColor': Color(0xFF5CAEF9),
      },
      {
        'title': 'Music Therapy',
        'icon': Icons.music_note,
        'description': 'Calm your mind',
        'iconBgColor': Color(0xFFE5F7ED),
        'iconColor': Color(0xFF49C67A),
      },
      {
        'title': 'Mood Tracker',
        'icon': Icons.bar_chart,
        'description': 'Track your progress',
        'iconBgColor': Color(0xFFFFF2E2),
        'iconColor': Color(0xFFFFAD41),
      },
      {
        'title': 'Decisions',
        'icon': Icons.psychology,
        'description': 'Clear your thoughts',
        'iconBgColor': Color(0xFFEBE5FF),
        'iconColor': Color(0xFF7B66FF),
      },
      {
        'title': 'Screen Time',
        'icon': Icons.timer,
        'description': 'Digital well-being',
        'iconBgColor': Color(0xFFE0F2F3),
        'iconColor': Color(0xFF57BEC3),
      },
    ];

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feature = features[index];
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.5 + (index * 0.05), 1.0, curve: Curves.easeOut),
              ),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.5 + (index * 0.05), 1.0, curve: Curves.easeOut),
                ),
              ),
              child: _buildFeatureTile(
                context,
                title: feature['title'],
                icon: feature['icon'],
                description: feature['description'],
                iconBgColor: feature['iconBgColor'],
                iconColor: feature['iconColor'],
              ),
            ),
          );
        },
        childCount: features.length,
      ),
    );
  }

  Widget _buildFeatureTile(
  BuildContext context, {
  required String title,
  required IconData icon,
  required String description,
  required Color iconBgColor,
  required Color iconColor,
}) {
  return GestureDetector(
    onTap: () {
      // Special handling for AI Therapy
      if (title == 'AI Therapy') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AITherapyPage(),
          ),
        );
      } else {
        // Default handling for other features
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeaturePage(title: title),
          ),
        );
      }
    },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: iconColor,
                ),
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                ),
              ),
              SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}