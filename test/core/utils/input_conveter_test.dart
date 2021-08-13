import 'package:clean_architecture_tdd_course/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConveter inputConveter;
  setUp(() {
    inputConveter = InputConveter();
  });

  group('stringToUnsignedInteger', () {
    test('should return int  when an unsigned string is provided', () {
      final str = '123';

      final result = inputConveter.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test(
        'should return Failure  when an unappopriate  string number (eg:"abc") is provided',
        () {
      final str = 'abc';

      final result = inputConveter.stringToUnsignedInteger(str);

      expect(result, Left(InputFailure()));
    });
    test('should return Failure  when an negative string number is provided',
        () {
      final str = '-123';

      final result = inputConveter.stringToUnsignedInteger(str);

      expect(result, Left(InputFailure()));
    });
  });
}
