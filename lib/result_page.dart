import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int correct;
  final int wrong;
  final int total;

  const ResultPage({
    super.key,
    required this.correct,
    required this.wrong,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Questions: $total", style: const TextStyle(fontSize: 18)),
            Text("Correct: $correct", style: const TextStyle(color: Colors.green, fontSize: 18)),
            Text("Wrong: $wrong", style: const TextStyle(color: Colors.red, fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Categories"),
            ),
          ],
        ),
      ),
    );
  }
}
