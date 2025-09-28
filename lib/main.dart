import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_3/category_model.dart';
import 'package:flutter_3/questions_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          shadowColor: Colors.grey.withValues(alpha: 0.2),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _dio = Dio();
  final _baseUrl = 'https://opentdb.com/';
  final _categoryRoute = 'api_category.php';
  List<CategoryModel> _categoriesList = [];

  @override
  void initState() {
    super.initState();
    _dio.get('$_baseUrl$_categoryRoute').then((value) {
      final data = value.data as Map<String, dynamic>;
      final categories = data['trivia_categories'] as List<dynamic>;
      setState(() {
        _categoriesList = categories
            .map((ele) => CategoryModel.fromJson(ele))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Api Lab')),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _categoriesList[index].name!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuestionsPage(
                      categoryId: _categoriesList[index].id!,
                      categoryName: _categoriesList[index].name!,
                    ),
                  ),
                );
              },
            );
          },
          itemCount: _categoriesList.length,
        ),
      ),
    );
  }
}
