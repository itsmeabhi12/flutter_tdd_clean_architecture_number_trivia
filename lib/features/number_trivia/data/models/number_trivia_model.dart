import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/cupertino.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required text, @required number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'], number: (json['number'] as num).toInt());
  }
  Map<String, dynamic> toJson(NumberTriviaModel numberTriviaModel) {
    return {'text': numberTriviaModel.text, 'number': numberTriviaModel.number};
  }
}
