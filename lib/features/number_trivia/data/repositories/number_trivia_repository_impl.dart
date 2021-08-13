import 'package:clean_architecture_tdd_course/core/error/exception.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

typedef _GetConcreteOrRandomNumberTrivia = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NetWorkInfo netWorkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.numberTriviaLocalDataSource,
      @required this.numberTriviaRemoteDataSource,
      @required this.netWorkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await getNumberTrivia(() {
      return numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await getNumberTrivia(() {
      return numberTriviaRemoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> getNumberTrivia(
      _GetConcreteOrRandomNumberTrivia getConcreteOrRandomNumberTrivia) async {
    final isConnected = await netWorkInfo.isConnected;
    if (isConnected) {
      try {
        final numberTriviaModel = await getConcreteOrRandomNumberTrivia();
        numberTriviaLocalDataSource.cacheNumberTrivia(numberTriviaModel);
        return Right(numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await numberTriviaLocalDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}


//unrefactoered  code---------------------------------->
// @override
//   Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
//       int number) async {
//     final isConnected = await netWorkInfo.isConnected;
//     if (isConnected) {
//       try {
//         final numberTriviaModel =
//             await numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
//         numberTriviaLocalDataSource.cacheNumberTrivia(numberTriviaModel);
//         return Right(numberTriviaModel);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         return Right(await numberTriviaLocalDataSource.getLastNumberTrivia());
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
//     final isConnected = await netWorkInfo.isConnected;
//     if (isConnected) {
//       try {
//         final numberTriviaModel =
//             await numberTriviaRemoteDataSource.getRandomNumberTrivia();
//         numberTriviaLocalDataSource.cacheNumberTrivia(numberTriviaModel);
//         return Right(numberTriviaModel);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         return Right(await numberTriviaLocalDataSource.getLastNumberTrivia());
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }