import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Error';

const String CACHE_FAILURE_MESSAGE = 'Cache Error';

const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid input';

class NumberTriviaBLoc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRadnomNumberTrivia getRadnomNumberTrivia;
  final InputConveter inputConveter;

  NumberTriviaBLoc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRadnomNumberTrivia,
      @required this.inputConveter});
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetConcreteNumberTriviaEvent) {
      final eitherInput =
          inputConveter.stringToUnsignedInteger(event.numberString);
      yield* eitherInput.fold((l) async* {
        yield Error(INVALID_INPUT_FAILURE_MESSAGE);
      }, (r) async* {
        yield Loading();
        final numberTrivia = await getConcreteNumberTrivia(Params(number: r));
        yield* numberTrivia.fold((l) async* {
          if (l is CacheFailure) {
            yield Error(CACHE_FAILURE_MESSAGE);
          } else {
            yield Error(SERVER_FAILURE_MESSAGE);
          }
        }, (r) async* {
          yield Loaded(r);
        });
      });
    }
    if (event is GetRandomNumberTriviaEvent) {
      yield Loading();
      final numberTrivia = await getRadnomNumberTrivia(NoParams());
      yield* numberTrivia.fold((l) async* {
        if (l is CacheFailure) {
          yield Error(CACHE_FAILURE_MESSAGE);
        } else {
          yield Error(SERVER_FAILURE_MESSAGE);
        }
      }, (r) async* {
        yield Loaded(r);
      });
    }
  }
}
