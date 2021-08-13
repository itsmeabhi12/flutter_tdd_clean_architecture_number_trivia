import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecases.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GetRadnomNumberTrivia extends Usecases<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  GetRadnomNumberTrivia({@required this.numberTriviaRepository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
