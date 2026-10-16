import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'https://opentdb.com/api.php?amount=10&type=multiple';

  final List<Map<String, dynamic>> _questions = [];

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Unable to load questions. Please try again.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['response_code'] != 0) {
      throw Exception('No questions available. Please try again.');
    }

    final results = List<Map<String, dynamic>>.from(data['results']);
    _questions
      ..clear()
      ..addAll(results);
    return results;
  }

  List<Map<String, dynamic>> getAllQuestions() {
    return List.unmodifiable(_questions);
  }

  Map<String, dynamic> createQuestion(Map<String, dynamic> question) {
    final normalized = Map<String, dynamic>.from(question);
    normalized['id'] ??= 'question-${DateTime.now().microsecondsSinceEpoch}';
    _questions.add(normalized);
    return normalized;
  }

  Map<String, dynamic>? getQuestionById(String id) {
    for (final question in _questions) {
      if (question['id'] == id) {
        return Map<String, dynamic>.from(question);
      }
    }
    return null;
  }

  Map<String, dynamic> updateQuestion(String id, Map<String, dynamic> values) {
    final index = _questions.indexWhere((question) => question['id'] == id);
    if (index == -1) {
      return createQuestion(values..['id'] = id);
    }

    final updated = Map<String, dynamic>.from(_questions[index])
      ..addAll(values);
    _questions[index] = updated;
    return updated;
  }

  void deleteQuestion(String id) {
    _questions.removeWhere((question) => question['id'] == id);
  }
}
