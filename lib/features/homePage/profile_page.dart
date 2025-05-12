import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? currentUser;
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  late AnimationController _animationController;
  
  // Define theme colors to match login/home pages
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
    getCurrentUser();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
  
  Future<void> getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    
    currentUser = _auth.currentUser;
    
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            nameController.text = userData['name'] ?? '';
            ageController.text = userData['age']?.toString() ?? '';
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    
    setState(() {
      isLoading = false;
    });
  }
  
  Future<void> updateProfile() async {
    if (currentUser == null) return;
    
    setState(() {
      isLoading = true;
    });
    
    try {
      // First, update local state immediately for better UX
      setState(() {
        userData['name'] = nameController.text.trim();
        userData['age'] = int.tryParse(ageController.text.trim()) ?? 0;
      });
      
      // Then update Firebase
      await _firestore.collection('users').doc(currentUser!.uid).set({
        'name': nameController.text.trim(),
        'age': int.tryParse(ageController.text.trim()) ?? 0,
        'email': currentUser!.email,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Also update display name in Firebase Auth for consistency
      await currentUser!.updateDisplayName(nameController.text.trim());
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: darkPurple,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
    }
    
    setState(() {
      isLoading = false;
    });
  }
  
  Future<void> signOut() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      await _auth.signOut();
      
      // Force navigation to login page after sign out
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e'))
      );
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Match background color with login/home
      backgroundColor: Color(0xFFF0E9FF),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: darkPurple,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: darkPurple,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sign Out'),
                  content: Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: darkPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        signOut();
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // Add gradient background to match login/home
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightPurple, Color(0xFFF0E9FF)],
            stops: [0.0, 1.0],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: darkPurple))
            : SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      darkPurple,
                                      primaryPurple,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkPurple.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: primaryPurple,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        FadeTransition(
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
                              padding: EdgeInsets.all(24),
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
                                        width: 5,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: darkPurple,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Personal Information",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: darkPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  _buildTextField(
                                    controller: nameController,
                                    label: 'Name',
                                    icon: Icons.person_outline,
                                  ),
                                  SizedBox(height: 20),
                                  _buildTextField(
                                    controller: ageController,
                                    label: 'Age',
                                    icon: Icons.calendar_today_outlined,
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(height: 20),
                                  _buildEmailField(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.4, 0.9, curve: Curves.easeOut),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(0.4, 0.9, curve: Curves.easeOut),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: darkPurple,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 3,
                                  shadowColor: darkPurple.withOpacity(0.5),
                                ),
                                child: Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 24,
            color: darkPurple,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryPurple, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
 Widget _buildEmailField() {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: lightPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.email_outlined,
          size: 24,
          color: darkPurple,
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Cannot be changed',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              currentUser?.email ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
}