import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttp extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
  MockHttp mockHttp;

  setUp(() {
    mockHttp = MockHttp();
    numberTriviaRemoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttp);
  });

  group('getConcreteNUmberTrvia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(''' should call http get method is call with proper header
         when RemoteDatais Requested ''', () {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response(fixture('trivia.json'), 200));

      numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

      verify(mockHttp.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });
    test('should give  numbertriviamodel when  a data form api is requested',
        () async {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response(fixture('trivia.json'), 200));

      final result = await numberTriviaRemoteDataSourceImpl
          .getConcreteNumberTrivia(tNumber);

      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response('SomethingWentWrong', 404));

      final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
      expect(
          () async => {await call(tNumber)}, throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNUmberTrvia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(''' should call http get method is call with proper header
         when RemoteDatais Requested ''', () {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response(fixture('trivia.json'), 200));

      numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();

      verify(mockHttp.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });
    test('should give  numbertriviamodel when  a data form api is requested',
        () async {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response(fixture('trivia.json'), 200));

      final result =
          await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();

      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response('SomethingWentWrong', 404));

      final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia;
      expect(() async => {await call()}, throwsA(isA<ServerException>()));
    });
  });
}
