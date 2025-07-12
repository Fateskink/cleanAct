/// Network connectivity information
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For now, we'll assume connection is available
    // In a real app, you might use connectivity_plus package
    return true;
  }
}
