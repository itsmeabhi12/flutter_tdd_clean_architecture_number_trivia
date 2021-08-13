import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded(this.numberTrivia);

  @override
  List<Object> get props => [this.numberTrivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error(this.message);
  @override
  List<Object> get props => [message];
}
