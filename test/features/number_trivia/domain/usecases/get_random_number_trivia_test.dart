import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRadnomNumberTrivia usecase;
  MockTriviaRepository mockTriviaRepository;

  setUp(() async {
    mockTriviaRepository = MockTriviaRepository();
    usecase =
        GetRadnomNumberTrivia(numberTriviaRepository: mockTriviaRepository);
  });

  var tNumberTrivia = NumberTrivia(text: 'test', number: 4);

  test('Get Random Number trivia', () async {
    when(mockTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, Right(tNumberTrivia));

    verify(mockTriviaRepository.getRandomNumberTrivia());

    verifyNoMoreInteractions(mockTriviaRepository);
  });
}
