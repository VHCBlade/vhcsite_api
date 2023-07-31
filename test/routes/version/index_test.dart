import 'package:dart_frog/dart_frog.dart';
import 'package:event_api/event_api.dart';
import 'package:event_db/event_db.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:vhcsite_api/vhcsite_api.dart';

import '../../../routes/version/index.dart' as version;

void main() {
  group('Version', () {
    test('GET', () async {
      var currentVersion =
          await (await version.onRequest(_MockRequestContext())).body();
      for (var i = 0; i < 5; i++) {
        final newVersion =
            await (await version.onRequest(_MockRequestContext())).body();
        expect(newVersion, currentVersion);
        currentVersion = newVersion;
      }
    });
  });
}

class _MockRequestContext extends Mock implements RequestContext {
  Map<Type, Object> get _read => {
        DatabaseRepository: database,
        APIRepository: api,
        InternalVersionService: const InternalVersionService(),
      };

  final database = FakeDatabaseRepository(constructors: modelConstructors);
  late final api = APIRepository(
    database: SpecificDatabase(database, 'cool'),
    requester: ServerAPIRequester(
      apiServer: 'https://vhcblade.com/',
      website: 'https://vhcblade.com',
    ),
  );

  @override
  T read<T>() => _read[T] as T;
}
