import 'package:cloud_firestore/cloud_firestore.dart';

class BestMatch {
  final String id;
  final String userId;
  final String matchedUserId;
  final double matchScore;
  final DateTime matchDate;
  final String matchType;
  final Map<String, double> traitComparisons;
  final Map<String, String> commonAnswers;
  final List<String> commonTraits;
  final String testResultId;
  final String previousResultId;

  BestMatch({
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.matchScore,
    required this.matchDate,
    required this.matchType,
    required this.traitComparisons,
    required this.commonAnswers,
    required this.commonTraits,
    required this.testResultId,
    required this.previousResultId,
  });

  factory BestMatch.fromJson(Map<String, dynamic> json) {
    return BestMatch(
      id: json['id'] as String,
      userId: json['userId'] as String,
      matchedUserId: json['matchedUserId'] as String,
      matchScore: (json['matchScore'] as num).toDouble(),
      matchDate: (json['matchDate'] as Timestamp).toDate(),
      matchType: json['matchType'] as String,
      traitComparisons: Map<String, double>.from(
        (json['traitComparisons'] as Map).map(
            (key, value) => MapEntry(key as String, (value as num).toDouble())),
      ),
      commonAnswers: Map<String, String>.from(json['commonAnswers'] as Map),
      commonTraits: List<String>.from(json['commonTraits'] as List),
      testResultId: json['testResultId'] as String,
      previousResultId: json['previousResultId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'matchedUserId': matchedUserId,
      'matchScore': matchScore,
      'matchDate': Timestamp.fromDate(matchDate),
      'matchType': matchType,
      'traitComparisons': traitComparisons,
      'commonAnswers': commonAnswers,
      'commonTraits': commonTraits,
      'testResultId': testResultId,
      'previousResultId': previousResultId,
    };
  }

  BestMatch copyWith({
    String? id,
    String? userId,
    String? matchedUserId,
    double? matchScore,
    DateTime? matchDate,
    String? matchType,
    Map<String, double>? traitComparisons,
    Map<String, String>? commonAnswers,
    List<String>? commonTraits,
    String? testResultId,
    String? previousResultId,
  }) {
    return BestMatch(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchedUserId: matchedUserId ?? this.matchedUserId,
      matchScore: matchScore ?? this.matchScore,
      matchDate: matchDate ?? this.matchDate,
      matchType: matchType ?? this.matchType,
      traitComparisons: traitComparisons ?? this.traitComparisons,
      commonAnswers: commonAnswers ?? this.commonAnswers,
      commonTraits: commonTraits ?? this.commonTraits,
      testResultId: testResultId ?? this.testResultId,
      previousResultId: previousResultId ?? this.previousResultId,
    );
  }
}
