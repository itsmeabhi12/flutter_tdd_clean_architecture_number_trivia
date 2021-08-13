import 'dart:math';

import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetRandomNumberTrivia extends Mock implements GetRadnomNumberTrivia {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockInputConveter extends Mock implements InputConveter {}

void main() {
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockInputConveter mockInputConveter;
  NumberTriviaBLoc bloc;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConveter = MockInputConveter();
    bloc = NumberTriviaBLoc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRadnomNumberTrivia: mockGetRandomNumberTrivia,
        inputConveter: mockInputConveter);
  });

  test('inital state of  bloc is Empty', () {
    expect(bloc.initialState, Empty());
  });

  group('getConcreteNumberTrivia', () {
    final tStringNumber = '1';
    final tNumber = 1;
    final tNumbertTrivia = NumberTrivia(text: 'test', number: tNumber);
    test('should call inputconveter when an event is disptched', () async {
      when(mockInputConveter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));

      bloc.add(GetConcreteNumberTriviaEvent(tStringNumber));
      await untilCalled(mockInputConveter.stringToUnsignedInteger(any));
      verify(mockInputConveter.stringToUnsignedInteger(tStringNumber));
    });

    test('Should return [Error] when an invalid input is provided', () {
      when(mockInputConveter.stringToUnsignedInteger(any))
          .thenReturn(Left(InputFailure()));
      bloc.add(GetConcreteNumberTriviaEvent('abc'));

      expectLater(bloc.asBroadcastStream(),
          emitsInOrder([Empty(), Error(INVALID_INPUT_FAILURE_MESSAGE)]));
    });

    test('Should call getConcreteNumberTrivia when an valid input is provided',
        () async {
      when(mockInputConveter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumbertTrivia));
      bloc.add(GetConcreteNumberTriviaEvent(tStringNumber));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumber)));
    });
    test('Should emit [Loading and Loaded] when an valid input is provided',
        () async {
      when(mockInputConveter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumbertTrivia));
      bloc.add(GetConcreteNumberTriviaEvent(tStringNumber));

      expectLater(bloc.asBroadcastStream(),
          emitsInOrder([Empty(), Loading(), Loaded(tNumbertTrivia)]));
    });

    test('Should emit [Loading and Error] when an Error Occour', () async {
      when(mockInputConveter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      bloc.add(GetConcreteNumberTriviaEvent(tStringNumber));

      expectLater(bloc.asBroadcastStream(),
          emitsInOrder([Empty(), Loading(), Error(SERVER_FAILURE_MESSAGE)]));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final tNumbertTrivia = NumberTrivia(text: 'test', number: tNumber);
    test('should not call inputconveter when an event is disptched', () async {
      bloc.add(GetRandomNumberTriviaEvent());
      verifyNever(mockInputConveter.stringToUnsignedInteger(any));
    });

    test('Should call getRandomNumberTrivia when an Random Button  is pressesd',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumbertTrivia));
      bloc.add(GetRandomNumberTriviaEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });
    test('Should emit [Loading and Loaded] when an Random Button  is pressesd',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Right(tNumbertTrivia));
      bloc.add(GetRandomNumberTriviaEvent());

      expectLater(bloc.asBroadcastStream(),
          emitsInOrder([Empty(), Loading(), Loaded(tNumbertTrivia)]));
    });

    test('Should emit [Loading and Error] when an Error Occour', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      bloc.add(GetRandomNumberTriviaEvent());

      expectLater(bloc.asBroadcastStream(),
          emitsInOrder([Empty(), Loading(), Error(SERVER_FAILURE_MESSAGE)]));
    });
  });
}
