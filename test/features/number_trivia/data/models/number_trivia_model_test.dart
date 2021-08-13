import 'dart:convert';

import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  NumberTriviaModel numberTriviaModel;
  setUp(() {
    numberTriviaModel = NumberTriviaModel(text: 'test', number: 1);
  });

  test('NumbertriviaModel is a subclass of NumberTrivia', () {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('formJson', () {
    test('should  return  NumberTriviaModel from JSON when Number is integer',
        () {
      final result =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

      expect(result, numberTriviaModel);
    });
    test('should  return  NumberTriviaModel from JSON when Number is double',
        () {
      final result =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_double.json')));
      expect(result, numberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should return JSON map when NumberTriviaModel object is provided',
        () {
      final result = numberTriviaModel.toJson(numberTriviaModel);
      final expectedresult = {'text': 'test', 'number': 1};

      expect(result, expectedresult);
    });
  });
}
