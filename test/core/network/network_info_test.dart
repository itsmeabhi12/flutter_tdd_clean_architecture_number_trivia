import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  test('should pass call to DataConnectionChecker.hasConnection', () async {
    final tHasConnectionFuture = Future.value(true);

    when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) =>
        tHasConnectionFuture); //remove async and you can return Future.value()
    final result = networkInfoImpl.isConnected;
    verify(mockDataConnectionChecker.hasConnection);

    expect(result, tHasConnectionFuture);
  });
}
