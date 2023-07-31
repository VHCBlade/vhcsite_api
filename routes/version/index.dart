import 'package:dart_frog/dart_frog.dart';
import 'package:vhcsite_api/service/manager.dart';

Future<Response> onRequest(RequestContext context) async {
  final version = await context.versionService.version(context);
  return Response(body: version);
}
