import 'package:cloud_firestore/cloud_firestore.dart';

class TestResult {
  final String id;
  final String userId;
  final DateTime testDate;
  final String testType;
  final Map<String, String> userAnswers;
  final Map<String, double> traitScores;
  final bool isProcessed;

  TestResult({
    required this.id,
    required this.userId,
    required this.testDate,
    required this.testType,
    required this.userAnswers,
    required this.traitScores,
    this.isProcessed = false,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      testDate: (json['testDate'] as Timestamp).toDate(),
      testType: json['testType'] as String,
      userAnswers: Map<String, String>.from(json['userAnswers'] as Map),
      traitScores: Map<String, double>.from(
        (json['traitScores'] as Map).map(
            (key, value) => MapEntry(key as String, (value as num).toDouble())),
      ),
      isProcessed: json['isProcessed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'testDate': Timestamp.fromDate(testDate),
      'testType': testType,
      'userAnswers': userAnswers,
      'traitScores': traitScores,
      'isProcessed': isProcessed,
    };
  }

  TestResult copyWith({
    String? id,
    String? userId,
    DateTime? testDate,
    String? testType,
    Map<String, String>? userAnswers,
    Map<String, double>? traitScores,
    bool? isProcessed,
  }) {
    return TestResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      testDate: testDate ?? this.testDate,
      testType: testType ?? this.testType,
      userAnswers: userAnswers ?? this.userAnswers,
      traitScores: traitScores ?? this.traitScores,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }
}
