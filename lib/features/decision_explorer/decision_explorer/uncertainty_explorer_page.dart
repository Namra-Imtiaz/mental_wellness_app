import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _salaryKey = 'uncertainty_salary';
  static const String _mentalHealthKey = 'uncertainty_mental_health';
  static const String _aiRiskComfortKey = 'uncertainty_ai_risk';
  static const String _workHoursKey = 'uncertainty_work_hours';
  static const String _workStyleKey = 'uncertainty_work_style';
  static const String _stabilityVsPassionKey = 'uncertainty_stability';
  static const String _interestsKey = 'uncertainty_interests';

  static Future<void> savePreferences({
    required double salary,
    required int mentalHealth,
    required int aiRiskComfort,
    required int workHours,
    required String workStyle,
    required int stabilityVsPassion,
    required List<String> interests,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_salaryKey, salary);
    await prefs.setInt(_mentalHealthKey, mentalHealth);
    await prefs.setInt(_aiRiskComfortKey, aiRiskComfort);
    await prefs.setInt(_workHoursKey, workHours);
    await prefs.setString(_workStyleKey, workStyle);
    await prefs.setInt(_stabilityVsPassionKey, stabilityVsPassion);
    await prefs.setStringList(_interestsKey, interests);
  }

  static Future<Map<String, dynamic>?> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_salaryKey)) return null;

    return {
      'salary': prefs.getDouble(_salaryKey) ?? 80000.0,
      'mentalHealth': prefs.getInt(_mentalHealthKey) ?? 3,
      'aiRiskComfort': prefs.getInt(_aiRiskComfortKey) ?? 2,
      'workHours': prefs.getInt(_workHoursKey) ?? 40,
      'workStyle': prefs.getString(_workStyleKey) ?? 'hybrid',
      'stabilityVsPassion': prefs.getInt(_stabilityVsPassionKey) ?? 3,
      'interests': prefs.getStringList(_interestsKey) ?? [],
    };
  }
}

class UserPreferences {
  final double salary;
  final int mentalHealth;
  final int aiRiskComfort;
  final List<String> interests;
  final int workHours;
  final String workStyle;
  final int stabilityVsPassion;

  UserPreferences({
    required this.salary,
    required this.mentalHealth,
    required this.aiRiskComfort,
    required this.interests,
    required this.workHours,
    required this.workStyle,
    required this.stabilityVsPassion,
  });

  Map<String, dynamic> toMap() {
    return {
      'salary': salary,
      'mentalHealth': mentalHealth,
      'aiRiskComfort': aiRiskComfort,
      'interests': interests,
      'workHours': workHours,
      'workStyle': workStyle,
      'stabilityVsPassion': stabilityVsPassion,
    };
  }
}

class SimulationResult {
  final String job;
  final double fitScore;
  final double incomePotential;
  final double riskOfAutomation;
  final double workLifeBalance;
  final double joyScore;

  SimulationResult({
    required this.job,
    required this.fitScore,
    required this.incomePotential,
    required this.riskOfAutomation,
    required this.workLifeBalance,
    required this.joyScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'job': job,
      'fitScore': fitScore,
      'incomePotential': incomePotential,
      'riskOfAutomation': riskOfAutomation,
      'workLifeBalance': workLifeBalance,
      'joyScore': joyScore,
    };
  }
}

class UncertaintyExplorerPage extends StatefulWidget {
  @override
  _UncertaintyExplorerPageState createState() => _UncertaintyExplorerPageState();
}

class _UncertaintyExplorerPageState extends State<UncertaintyExplorerPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _diceAnimationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  int _currentStep = 0;
  bool _isSimulating = false;
  double _simulationProgress = 0.0;
  List<SimulationResult>? _simulationResults;
  int _currentDiceValue = 1;
  int _currentMessageIndex = 0;
  
  // User Preferences
  double _salary = 80000;
  int _mentalHealth = 3;
  int _aiRiskComfort = 2;
  List<String> _selectedInterests = [];
  int _workHours = 40;
  String _workStyle = 'hybrid';
  int _stabilityVsPassion = 3;

  final List<String> _availableInterests = [
    'Design', 'Development', 'Data Science', 'Marketing',
    'Writing', 'Management', 'Research', 'Education',
    'Healthcare', 'Finance', 'Art', 'Music'
  ];

  final List<String> _workStyles = ['remote', 'hybrid', 'in-office'];

  final List<String> _loadingMessages = [
    "Rolling the dice of destiny...",
    "Calculating possible futures...",
    "Analyzing career paths...",
    "Simulating life scenarios...",
    "Finding your perfect match...",
    "Exploring opportunities...",
    "Mapping your journey...",
    "Discovering possibilities...",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..forward();

    _diceAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await PreferencesService.loadPreferences();
    if (prefs != null) {
      setState(() {
        _salary = prefs['salary'] as double;
        _mentalHealth = prefs['mentalHealth'] as int;
        _aiRiskComfort = prefs['aiRiskComfort'] as int;
        _workHours = prefs['workHours'] as int;
        _workStyle = prefs['workStyle'] as String;
        _stabilityVsPassion = prefs['stabilityVsPassion'] as int;
        _selectedInterests = List<String>.from(prefs['interests'] as List);
      });
    }
  }

  Future<void> _saveCurrentPreferences() async {
    await PreferencesService.savePreferences(
      salary: _salary,
      mentalHealth: _mentalHealth,
      aiRiskComfort: _aiRiskComfort,
      workHours: _workHours,
      workStyle: _workStyle,
      stabilityVsPassion: _stabilityVsPassion,
      interests: _selectedInterests,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _diceAnimationController.dispose();
    super.dispose();
  }

  void _rollDice() {
    setState(() {
      _currentDiceValue = Random().nextInt(6) + 1;
      _currentMessageIndex = (_currentMessageIndex + 1) % _loadingMessages.length;
    });
    _diceAnimationController.forward(from: 0.0);
  }

  Future<List<SimulationResult>> _runSimulations() async {
    setState(() {
      _isSimulating = true;
      _simulationProgress = 0.0;
    });

    final random = Random();
    List<SimulationResult> results = [];
    final prefs = UserPreferences(
      salary: _salary,
      mentalHealth: _mentalHealth,
      aiRiskComfort: _aiRiskComfort,
      interests: _selectedInterests,
      workHours: _workHours,
      workStyle: _workStyle,
      stabilityVsPassion: _stabilityVsPassion,
    );

    for (int i = 0; i < 1000; i++) {
      await Future.delayed(Duration(milliseconds: 1));
      setState(() {
        _simulationProgress = (i + 1) / 1000;
      });

      // Roll dice every 100 iterations
      if (i % 100 == 0) {
        _rollDice();
      }

      // Simulate different job paths
      for (String interest in _selectedInterests) {
        double income = prefs.salary + (random.nextInt(20000) - 10000).toDouble();
        double risk = random.nextDouble() * 100;
        double workLifeBalance = 5 - (prefs.workHours / 20);
        double joy = prefs.interests.contains(interest) ? (70 + random.nextInt(20)).toDouble() : 50.0;

        // New, more realistic fit score calculation
        double salaryMatch = 1 - ((income - prefs.salary).abs() / prefs.salary);
        double aiRiskPenalty = (risk / 100) * (prefs.aiRiskComfort / 5);
        double workLifeMatch = 1 - ((prefs.workHours - 40).abs() / 40);
        double joyFactor = joy / 100;
        double mentalHealthPenalty = (prefs.mentalHealth / 5) * (risk / 100);

        double fit = (0.3 * salaryMatch + 0.2 * workLifeMatch + 0.2 * joyFactor + 0.2 * (1 - aiRiskPenalty) + 0.1 * (1 - mentalHealthPenalty)) * 100;
        fit = fit.clamp(0, 100);

        results.add(SimulationResult(
          job: interest,
          fitScore: fit,
          incomePotential: income,
          riskOfAutomation: risk,
          workLifeBalance: workLifeBalance,
          joyScore: joy,
        ));
      }
    }

    setState(() {
      _isSimulating = false;
    });

    return results;
  }

  Future<void> _saveSimulationResult() async {
    if (_simulationResults != null) {
      await _firestore.collection('career_simulations').add({
        'userPrefs': UserPreferences(
          salary: _salary,
          mentalHealth: _mentalHealth,
          aiRiskComfort: _aiRiskComfort,
          interests: _selectedInterests,
          workHours: _workHours,
          workStyle: _workStyle,
          stabilityVsPassion: _stabilityVsPassion,
        ).toMap(),
        'simulationResults': _simulationResults!.map((r) => r.toMap()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Icon(
              Icons.psychology,
              size: 80,
              color: Color(0xFF7B66FF),
            ),
          ),
          SizedBox(height: 24),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  'Turn Anxiety Into Clarity',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C60D5),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Explore your future possibilities',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7C60D5).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7B66FF),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Start My Exploration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C60D5),
            ),
          ),
          SizedBox(height: 24),
          _buildPreferenceSection(
            'Desired Salary',
            '\$${_salary.toStringAsFixed(0)}',
            Slider(
              value: _salary,
              min: 30000,
              max: 200000,
              divisions: 17,
              label: '\$${_salary.toStringAsFixed(0)}',
              onChanged: (value) {
                setState(() {
                  _salary = value;
                });
              },
            ),
          ),
          _buildPreferenceSection(
            'Mental Health Sensitivity',
            '${_mentalHealth}/5',
            Slider(
              value: _mentalHealth.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_mentalHealth',
              onChanged: (value) {
                setState(() {
                  _mentalHealth = value.toInt();
                });
              },
            ),
          ),
          _buildPreferenceSection(
            'Comfort with AI Risk',
            '${_aiRiskComfort}/5',
            Slider(
              value: _aiRiskComfort.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_aiRiskComfort',
              onChanged: (value) {
                setState(() {
                  _aiRiskComfort = value.toInt();
                });
              },
            ),
          ),
          _buildPreferenceSection(
            'Work Hours per Week',
            '$_workHours hours',
            Slider(
              value: _workHours.toDouble(),
              min: 20,
              max: 60,
              divisions: 8,
              label: '$_workHours',
              onChanged: (value) {
                setState(() {
                  _workHours = value.toInt();
                });
              },
            ),
          ),
          _buildPreferenceSection(
            'Work Style',
            _workStyle,
            SegmentedButton<String>(
              segments: _workStyles.map((style) {
                return ButtonSegment<String>(
                  value: style,
                  label: Text(style),
                );
              }).toList(),
              selected: {_workStyle},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _workStyle = newSelection.first;
                });
              },
            ),
          ),
          _buildPreferenceSection(
            'Stability vs Passion',
            '${_stabilityVsPassion}/5',
            Slider(
              value: _stabilityVsPassion.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_stabilityVsPassion',
              onChanged: (value) {
                setState(() {
                  _stabilityVsPassion = value.toInt();
                });
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Select Your Interests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C60D5),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: Color(0xFF7B66FF).withOpacity(0.2),
                checkmarkColor: Color(0xFF7B66FF),
                labelStyle: TextStyle(
                  color: isSelected ? Color(0xFF7B66FF) : Colors.black87,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _selectedInterests.isEmpty
                ? null
                : () async {
                    await _saveCurrentPreferences();
                    final results = await _runSimulations();
                    setState(() {
                      _simulationResults = results;
                      _currentStep = 2;
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7B66FF),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Run Simulation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceSection(String title, String value, Widget control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C60D5),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7C60D5),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        control,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _diceAnimationController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_diceAnimationController.value * 2 * pi)
                  ..rotateY(_diceAnimationController.value * 2 * pi),
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7B66FF).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_currentDiceValue',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B66FF),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32),
          Text(
            _loadingMessages[_currentMessageIndex],
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF7C60D5),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: _simulationProgress,
            backgroundColor: Color(0xFF7B66FF).withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B66FF)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 8),
          Text(
            '${(_simulationProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7C60D5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationScreen() {
    if (_simulationResults == null) return SizedBox();

    if (_isSimulating) {
      return _buildLoadingScreen();
    }

    // Group results by job and calculate averages
    Map<String, List<SimulationResult>> groupedResults = {};
    for (var result in _simulationResults!) {
      if (!groupedResults.containsKey(result.job)) {
        groupedResults[result.job] = [];
      }
      groupedResults[result.job]!.add(result);
    }

    // Calculate average scores for each job
    List<Map<String, dynamic>> jobAverages = groupedResults.entries.map((entry) {
      final results = entry.value;
      final avgFitScore = results.map((r) => r.fitScore).reduce((a, b) => a + b) / results.length;
      final avgIncome = results.map((r) => r.incomePotential).reduce((a, b) => a + b) / results.length;
      final avgRisk = results.map((r) => r.riskOfAutomation).reduce((a, b) => a + b) / results.length;
      final avgWorkLife = results.map((r) => r.workLifeBalance).reduce((a, b) => a + b) / results.length;
      final avgJoy = results.map((r) => r.joyScore).reduce((a, b) => a + b) / results.length;

      return {
        'job': entry.key,
        'fitScore': avgFitScore,
        'incomePotential': avgIncome,
        'riskOfAutomation': avgRisk,
        'workLifeBalance': avgWorkLife,
        'joyScore': avgJoy,
      };
    }).toList();

    // Sort by fit score
    jobAverages.sort((a, b) => b['fitScore'].compareTo(a['fitScore']));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulation Results',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C60D5),
            ),
          ),
          SizedBox(height: 24),
          ...jobAverages.map((job) => _buildJobResultCard(job)).toList(),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                      _simulationResults = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF7B66FF),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Color(0xFF7B66FF)),
                    ),
                  ),
                  child: Text('Try Different Preferences'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveCurrentPreferences();
                    await _saveSimulationResult();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B66FF),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('Save & Exit'),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJobResultCard(Map<String, dynamic> job) {
    final fitScore = job['fitScore'] as double;
    final color = fitScore >= 70
        ? Color(0xFF49C67A) // Green for high fit
        : fitScore >= 40
            ? Color(0xFFFFAD41) // Yellow for medium fit
            : Color(0xFFF5716C); // Red for low fit

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['job'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C60D5),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${fitScore.toStringAsFixed(1)}% Fit',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: [
                        RadarEntry(value: job['fitScore'] / 100),
                        RadarEntry(value: job['incomePotential'] / 200000),
                        RadarEntry(value: (1 - (job['riskOfAutomation'] / 100)).toDouble()),
                        RadarEntry(value: job['workLifeBalance'] / 5),
                        RadarEntry(value: job['joyScore'] / 100),
                      ],
                      fillColor: color.withOpacity(0.3),
                      borderColor: color,
                    ),
                  ],
                  titleTextStyle: TextStyle(
                    color: Color(0xFF7C60D5),
                    fontSize: 12,
                  ),
                  tickCount: 5,
                  ticksTextStyle: TextStyle(
                    color: Color(0xFF7C60D5).withOpacity(0.5),
                    fontSize: 10,
                  ),
                  getTitle: (index, angle) {
                    const titles = [
                      'Fit Score',
                      'Income',
                      'Stability',
                      'Work-Life',
                      'Joy',
                    ];
                    return RadarChartTitle(
                      text: titles[index],
                      angle: angle,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildMetricRow('Income Potential', '\$${job['incomePotential'].toStringAsFixed(0)}'),
            _buildMetricRow('Risk of Automation', '${job['riskOfAutomation'].toStringAsFixed(1)}%'),
            _buildMetricRow('Work-Life Balance', '${job['workLifeBalance'].toStringAsFixed(1)}/5'),
            _buildMetricRow('Joy Score', '${job['joyScore'].toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF7C60D5).withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF7C60D5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7C60D5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Uncertainty Explorer',
          style: TextStyle(
            color: Color(0xFF7C60D5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentStep == 0
                ? _buildWelcomeScreen()
                : _currentStep == 1
                    ? _buildPreferencesScreen()
                    : _buildSimulationScreen(),
          ),
        ),
      ),
    );
  }
} 