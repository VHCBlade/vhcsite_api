import 'package:dart_frog/dart_frog.dart';
import 'package:event_db/event_db.dart';
import 'package:vhcsite_api/repository/hive.dart';
import 'package:vhcsite_models/vhcsite_models.dart';

/// Handles [BlogViews]
class InternalBlogViewsService {
  /// Handles [BlogViews]
  const InternalBlogViewsService();

  /// Finds the [BlogViews] object associated with the given blog path. Will
  /// create the appropriate [BlogViews] object if none is found.
  Future<BlogViews> fromPath(RequestContext context, String path) async {
    final views = await context.vhcsiteDatabase
        .findModel<BlogViews>(BlogViews().prefixTypeForId(path));

    return views ??
        (BlogViews()
          ..path = path
          ..viewCount = 0);
  }

  /// Saves the given [views] to the appropriate database
  Future<void> saveViews(RequestContext context, BlogViews views) async {
    await context.vhcsiteDatabase.saveModel(views);
  }
}
