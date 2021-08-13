import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl =
        NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTrivia =
        NumberTriviaModel.fromJson(json.decode(fixture('cache_trivia.json')));
    test('should return NumberTrivia when chache is availale ', () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('cache_trivia.json'));

      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, tNumberTrivia);
    });

    test('should throw exception when chache is not available ', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(isA<CacheException>()));
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTrivia = NumberTriviaModel(text: 'test', number: 1);
    test('should cachdata when new data is available', () async {
      await numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTrivia);

      verify(mockSharedPreferences.setString("CACHED_NUMBER_TRIVIA",
          json.encode(tNumberTrivia.toJson(tNumberTrivia))));
    });
  });
}
