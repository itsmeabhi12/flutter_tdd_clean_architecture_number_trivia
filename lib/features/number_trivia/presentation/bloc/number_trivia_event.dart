import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent(this.numberString);

  @override
  List<Object> get props => [this.numberString];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {
  @override
  List<Object> get props => [];
}
