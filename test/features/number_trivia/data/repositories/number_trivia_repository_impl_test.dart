import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNewtorkInfo extends Mock implements NetWorkInfo {}

void main() {
  NumberTriviaRepositoryImpl mocknumberTriviaRepositoryImpl;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNewtorkInfo mockNewtorkInfo;

  setUp(() {
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNewtorkInfo = MockNewtorkInfo();
    mocknumberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        numberTriviaLocalDataSource: mockNumberTriviaLocalDataSource,
        numberTriviaRemoteDataSource: mockNumberTriviaRemoteDataSource,
        netWorkInfo: mockNewtorkInfo);
  });

//All Tests For Getting ConcreteNumberTrivia
  group('GetConcretenumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      when(mockNewtorkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      mocknumberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      verify(mockNewtorkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNewtorkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test('should return from RemoteRepo When device is online', () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await mocknumberTriviaRepositoryImpl
            .getConcreteNumberTrivia(tNumber);

        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTrivia));
      });
      test('should cache data when  new data is returd from remote repository',
          () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        await mocknumberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return Server Failure when  server Error Occour & none data should be cached',
          () async {
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        final result = await mocknumberTriviaRepositoryImpl
            .getConcreteNumberTrivia(tNumber);

        expect(result, Left(ServerFailure()));
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNewtorkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test('when device is offline should return from local repository',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await mocknumberTriviaRepositoryImpl
            .getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should return cached exception when device is offline and no chache is present',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await mocknumberTriviaRepositoryImpl
            .getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

//All Tests For Getting RandomNumberTrivia
  group('GetRandomTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () {
      when(mockNewtorkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();
      verify(mockNewtorkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNewtorkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test('should return from RemoteRepo When device is online', () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result =
            await mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should cache data when  new data is returd from remote repository',
          () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        await mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();

        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return Server Failure when  server Error Occour & none data should be cached',
          () async {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result =
            await mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();

        expect(result, Left(ServerFailure()));
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaLocalDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNewtorkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test('when device is offline should return from local repository',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result =
            await mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should return cached exception when device is offline and no chache is present',
          () async {
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result =
            await mocknumberTriviaRepositoryImpl.getRandomNumberTrivia();
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
