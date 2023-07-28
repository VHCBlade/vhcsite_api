import 'package:dart_frog/dart_frog.dart';
import 'package:event_db/event_db.dart';
import 'package:event_frog/event_frog.dart';
import 'package:vhcsite_api/service/manager.dart';

Future<Response> onRequest(RequestContext context, String path) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return postResponse(context, path);
    case HttpMethod.get:
      return getResponse(context, path);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.put:
    case HttpMethod.patch:
      return notFoundResponse();
  }
}

Future<Response> postResponse(RequestContext context, String path) async {
  // Note: This has a race condition and should probably be updated later on
  final model = await context.blogViewsService.fromPath(context, path);
  model.viewCount++;
  await context.blogViewsService.saveViews(context, model);
  return Response(body: model.id);
}

Future<Response> getResponse(RequestContext context, String path) async {
  final model = await context.blogViewsService.fromPath(context, path);
  return Response(body: model.toJsonString());
}
