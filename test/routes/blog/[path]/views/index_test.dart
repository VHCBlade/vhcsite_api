import 'package:dart_frog/dart_frog.dart';
import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:event_db/event_db.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:vhcsite_api/vhcsite_api.dart';

import '../../../../../routes/blog/[path]/views/index.dart' as blogViews;

void main() {
  group('Blog Path Views', () {
    SerializableListTester<List<dynamic>>(
      testGroupName: 'Authenticated Owner Valuation Draft',
      mainTestName: 'POST',
      mode: ListTesterMode.auto,
      testFunction: (value, tester) async {
        final database =
            FakeDatabaseRepository(constructors: modelConstructors);
        for (var i = 0; i < 5; i++) {
          tester
            ..addTestValue(i)
            ..addTestValue(
              await (await blogViews.onRequest(
                _MockRequestContext(
                  Request.get(Uri.parse('https://example.com/')),
                  database,
                ),
                'cool-amazing-blog',
              ))
                  .body(),
            )
            ..addTestValue(
              await (await blogViews.onRequest(
                _MockRequestContext(
                  Request.get(Uri.parse('https://example.com/')),
                  database,
                ),
                'cool-great-blog',
              ))
                  .body(),
            )
            ..addTestValue(
              await (await blogViews.onRequest(
                _MockRequestContext(
                  Request.get(Uri.parse('https://example.com/')),
                  database,
                ),
                'cool-incredible-blog',
              ))
                  .body(),
            );
          await blogViews.onRequest(
            _MockRequestContext(
              Request.post(Uri.parse('https://example.com/')),
              database,
            ),
            'cool-great-blog',
          );
          await blogViews.onRequest(
            _MockRequestContext(
              Request.post(Uri.parse('https://example.com/')),
              database,
            ),
            'cool-great-blog',
          );
          await blogViews.onRequest(
            _MockRequestContext(
              Request.post(Uri.parse('https://example.com/')),
              database,
            ),
            'cool-amazing-blog',
          );
        }
      },
      testMap: {'POST': () => []},
    ).runTests();
  });
}

class _MockRequestContext extends Mock implements RequestContext {
  _MockRequestContext(this.request, this.database);

  Map<Type, Object> get _read => {
        DatabaseRepository: database,
        InternalBlogViewsService: const InternalBlogViewsService(),
      };

  final DatabaseRepository database;

  @override
  final Request request;
  @override
  T read<T>() => _read[T] as T;
}
