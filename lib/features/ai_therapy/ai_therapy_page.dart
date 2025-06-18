import 'package:flutter/material.dart';
import 'chat_service.dart';

class AITherapyPage extends StatefulWidget {
  @override
  _AITherapyPageState createState() => _AITherapyPageState();
}

class _AITherapyPageState extends State<AITherapyPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  // Define theme colors to match app style
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);
  
  // Create instance of chat service
  final ChatService _chatService = ChatService();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final userMessage = _messageController.text;

    setState(() {
      // Add user message
      _messages.add({'text': userMessage, 'isUser': true});

      // Show typing indicator
      _isTyping = true;
    });

    // Clear the input field
    _messageController.clear();

    // Scroll to bottom
    _scrollToBottom();

    try {
      // Send message to backend
      final response = await _chatService.sendMessage(userMessage);
      
      setState(() {
        _isTyping = false;
        
        if (response['success']) {
          // Add AI response from backend
          _messages.add({
            'text': response['data'],
            'isUser': false,
          });
        } else {
          // Show error message
          _messages.add({
            'text': response['error'],
            'isUser': false,
            'isError': true,
          });
        }
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        // Add error as a system message
        _messages.add({
          'text': "Something went wrong. Please try again later.",
          'isUser': false,
          'isError': true,
        });
      });
    }

    // Scroll to bottom again after response
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F6FF),
      appBar: AppBar(
        title: Text(
          "AI Therapy",
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFF8F6FF),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: primaryPurple,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Chat area
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF0E9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:
                    _messages.isEmpty
                        ? _buildWelcomeMessage()
                        : ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          padding: EdgeInsets.only(bottom: 16, top: 16),
                          itemBuilder: (context, index) {
                            // Display typing indicator
                            if (_isTyping && index == _messages.length) {
                              return _buildTypingIndicator();
                            }

                            // Display message
                            final message = _messages[index];
                            return _buildMessageBubble(
                              text: message['text'],
                              isUser: message['isUser'],
                              isError: message['isError'] ?? false,
                            );
                          },
                        ),
              ),
            ),

            // Input area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: lightPurple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
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

  Widget _buildWelcomeMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: primaryPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_rounded,
                size: 52,
                color: primaryPurple,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Welcome to AI Therapy",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Share your thoughts and feelings with our AI therapist. Your conversations are private and secure.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Add initial welcome message from bot
                  _messages.add({
                    'text': "Hello! I'm your AI therapy assistant. How are you feeling today?",
                    'isUser': false,
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  "Start Chatting",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({required String text, required bool isUser, bool isError = false}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          bottom: 10,
          left: isUser ? 50 : 0,
          right: isUser ? 0 : 50,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser 
              ? primaryPurple 
              : isError 
                  ? Color(0xFFFFF0F0) // Light red for error messages
                  : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? Radius.circular(5) : Radius.circular(20),
            bottomLeft: isUser ? Radius.circular(20) : Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser 
                ? Colors.white 
                : isError 
                    ? Colors.red.shade700 // Dark red text for error messages
                    : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => Container(
              margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: primaryPurple.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Center(child: _TypingDot()),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  @override
  _TypingDotState createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Color(0xFF9D7CF4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}