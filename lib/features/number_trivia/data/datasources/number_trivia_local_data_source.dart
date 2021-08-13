import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString('CACHED_NUMBER_TRIVIA',
        json.encode(numberTriviaModel.toJson(numberTriviaModel)));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final cachedData = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if (cachedData == null) {
      throw CacheException();
    }
    final numberTrivia = NumberTriviaModel.fromJson(json.decode(cachedData));
    return Future.value(numberTrivia);
  }
}
