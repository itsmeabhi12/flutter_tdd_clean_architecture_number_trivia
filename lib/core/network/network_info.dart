import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetWorkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetWorkInfo {
  final DataConnectionChecker dataConnectionChecker;
  NetworkInfoImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
