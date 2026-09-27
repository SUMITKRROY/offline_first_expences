import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(
          (result) {
        return result.any(
              (item) =>
          item == ConnectivityResult.wifi ||
              item == ConnectivityResult.mobile ||
              item == ConnectivityResult.ethernet,
        );
      },
    );
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();

    return result.any(
          (item) =>
      item == ConnectivityResult.wifi ||
          item == ConnectivityResult.mobile ||
          item == ConnectivityResult.ethernet,
    );
  }
}