import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool isEnglish = true;

  Widget _buildAnswerButton({
    required int index,
    required String answerValue,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        final testProvider = Provider.of<TestProvider>(context, listen: false);
        testProvider.setAnswer(index, answerValue);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          answerValue,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (context, testProvider, child) {
        final questions = testProvider.questions;
        final answers = testProvider.answers;
        final allAnswered = testProvider.areAllQuestionsAnswered;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text('Roommate Test',
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: Container(
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Find Your\nPerfect Match!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 60),

                  ...List.generate(questions.length, (index) {
                    final q = questions[index];
                    final opts = isEnglish ? q['options'] : q['optionsTr'];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Question ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                isEnglish ? q['en'] : q['tr'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var opt in opts)
                                    _buildAnswerButton(
                                      index: index,
                                      answerValue: opt,
                                      isSelected: answers[index] == opt,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),

                  const SizedBox(height: 40),

                  if (testProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        testProvider.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        disabledForegroundColor: AppColors.primary,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: testProvider.isLoading
                          ? null
                          : allAnswered
                              ? () async {
                                  final success = await testProvider.submitTestAnswers();
                                  if (success && context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.bestMatches,
                                      (route) => route.settings.name == AppRoutes.home,
                                    );
                                  }
                                }
                              : null,
                      child: testProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(AppStrings.submit),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
