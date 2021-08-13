import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  ///Get Concrete  Trrivia  Number From api
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getNumberTrivia(() {
      return client.get('http://numbersapi.com/$number',
          headers: {'Content-Type': 'application/json'});
    });
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getNumberTrivia(() {
      return client.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'});
    });
  }

  Future<NumberTriviaModel> _getNumberTrivia(
      Function getConcreteOrRandom) async {
    final response = await getConcreteOrRandom();

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
