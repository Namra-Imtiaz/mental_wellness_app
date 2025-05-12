import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../homePage/home_page.dart';
import 'login_page.dart';

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isAuthenticated = false;
  
  @override
  void initState() {
    super.initState();
    // Check auth state after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthState();
    });
  }
  
  Future<void> checkAuthState() async {
    setState(() {
      isLoading = true;
    });
    
    // Wait for Firebase to initialize and check auth state
    User? user = _auth.currentUser;
    
    // Add a small delay to ensure Firebase has time to properly initialize
    await Future.delayed(Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        isAuthenticated = user != null;
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        // If waiting for connection or initial state check
        if (isLoading || snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9D7CF4),
              ),
            ),
          );
        }
        
        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          print("User is logged in: ${snapshot.data!.email}");
          return HomePage();
        } 
        // No user logged in
        else {
          print("No user logged in, showing LoginPage");
          return LoginPage();
        }
      },
    );
  }
}