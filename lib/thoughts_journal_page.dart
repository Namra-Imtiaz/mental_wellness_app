import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ThoughtsJournalPage extends StatefulWidget {
  @override
  _ThoughtsJournalPageState createState() => _ThoughtsJournalPageState();
}

class _ThoughtsJournalPageState extends State<ThoughtsJournalPage> {
  // Storage for journal entries
  List<JournalEntry> _entries = [];
  final TextEditingController _thoughtController = TextEditingController();
  
  final Color primaryPurple = Color(0xFF9D7CF4);
  final Color darkPurple = Color(0xFF7C60D5);
  final Color lightPurple = Color(0xFFEDE7FF);
  
  // Key for SharedPreferences
  static const String STORAGE_KEY = 'journal_entries';
  
  @override
  void initState() {
    super.initState();
    // Load entries when the page initializes
    _loadEntries();
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  // Load entries from SharedPreferences
  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getStringList(STORAGE_KEY) ?? [];
      
      setState(() {
        _entries = entriesJson.map((json) {
          final Map<String, dynamic> data = jsonDecode(json);
          return JournalEntry.fromJson(data);
        }).toList();
      });
    } catch (e) {
      print('Error loading entries: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load your thoughts'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Save entries to SharedPreferences
  Future<void> _saveEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = _entries.map((entry) => jsonEncode(entry.toJson())).toList();
      await prefs.setStringList(STORAGE_KEY, entriesJson);
    } catch (e) {
      print('Error saving entries: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save your thought'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addEntry() {
    if (_thoughtController.text.trim().isNotEmpty) {
      setState(() {
        _entries.add(
          JournalEntry(
            thought: _thoughtController.text,
            timestamp: DateTime.now(),
          ),
        );
        _thoughtController.clear();
      });
      
      // Save entries after adding
      _saveEntries();
      
      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your thought was saved'),
          backgroundColor: darkPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
  
  void _deleteEntry(JournalEntry entry) {
    setState(() {
      _entries.remove(entry);
    });
    // Save entries after deleting
    _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Thoughts Journal',
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: darkPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Using ResizeToAvoidBottomInset to prevent overflow
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: _entries.isEmpty
                    ? _buildEmptyState()
                    : _buildJournalEntries(),
              ),
              _buildInputSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 70,
              color: darkPurple.withOpacity(0.3),
            ),
            SizedBox(height: 12),
            Text(
              'Your journal is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkPurple.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Write down your thoughts, worries or anything that\'s on your mind',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalEntries() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _entries.length,
      reverse: true, // Show newest entries first
      itemBuilder: (context, index) {
        final entry = _entries[_entries.length - 1 - index];
        return _buildEntryCard(entry);
      },
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: primaryPurple.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: lightPurple.withOpacity(0.3),
          highlightColor: lightPurple.withOpacity(0.1),
          onTap: () {}, // Could be expanded for viewing detailed entry
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: darkPurple,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(entry.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: darkPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          _deleteEntry(entry);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: Colors.red.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  entry.thought,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Important for proper sizing
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 18, color: darkPurple),
              SizedBox(width: 8),
              Text(
                'What\'s on your mind?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkPurple,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: lightPurple.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _thoughtController,
              maxLines: MediaQuery.of(context).viewInsets.bottom > 0 ? 2 : 3, // Adjust based on keyboard
              decoration: InputDecoration(
                hintText: 'Write your thoughts here...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: darkPurple,
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).viewInsets.bottom > 0 ? 12 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: darkPurple.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save_outlined, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Save Thought',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple date formatting
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final entryDate = DateTime(date.year, date.month, date.day);
    
    String formattedTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    
    if (entryDate == today) {
      return 'Today, $formattedTime';
    } else if (entryDate == yesterday) {
      return 'Yesterday, $formattedTime';
    } else {
      return '${date.day}/${date.month}/${date.year}, $formattedTime';
    }
  }
}

class JournalEntry {
  final String thought;
  final DateTime timestamp;

  JournalEntry({required this.thought, required this.timestamp});
  
  // Convert JournalEntry to JSON
  Map<String, dynamic> toJson() {
    return {
      'thought': thought,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
  
  // Create JournalEntry from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      thought: json['thought'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}