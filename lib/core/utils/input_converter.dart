import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConveter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final rslt = int.parse(str);
      if (rslt < 0) throw FormatException();
      return Right(rslt);
    } on FormatException {
      return Left(InputFailure());
    }
  }
}

class InputFailure extends Failure {}
