import 'package:dart_frog/dart_frog.dart';
import 'package:event_api/event_api.dart';

/// Handles the current version of VHCSite
class InternalVersionService {
  /// Handles the current version of VHCSite
  const InternalVersionService();

  /// Returns the current version of VHCSite
  Future<String> version(RequestContext context) async {
    final response = await context
        .read<APIRepository>()
        .request('GET', 'assets/assets/VERSION', (request) => null);

    assert(response.statusCode == 200, 'Failed to load version');

    return response.body;
  }
}
