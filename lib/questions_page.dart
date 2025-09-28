import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_3/questions_model.dart';
import 'package:flutter_3/result_page.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });
  final int categoryId;
  final String categoryName;

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final dio = Dio();
  final _baseUrl = 'https://opentdb.com/api.php';
  List<QuestionModel> _questions = [];
  bool _isLoading = true;

  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  Future<void> getQuestions() async {
    final response = await dio.get(
      '$_baseUrl?amount=10&category=${widget.categoryId}&type=multiple',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final questions = data['results'] as List<dynamic>;
      setState(() {
        _questions =
            questions.map((q) => QuestionModel.fromJson(q)).toList();
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      throw Exception('Failed to load questions');
    }
  }

  void _answerQuestion(String answer) {
    final correct = _questions[_currentIndex].correctAnswer;

    if (answer == correct) {
      _correctAnswers++;
    } else {
      _wrongAnswers++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            correct: _correctAnswers,
            wrong: _wrongAnswers,
            total: _questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final allAnswers = [
      question.correctAnswer!,
      ...?question.incorrectAnswers
    ]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q ${_currentIndex + 1}/${_questions.length} - ${widget.categoryName}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.question ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...allAnswers.map((answer) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(answer),
                  child: Text(answer),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
// 