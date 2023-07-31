import 'package:dart_frog/dart_frog.dart';
import 'package:vhcsite_api/service/version.dart';
import 'package:vhcsite_api/service/views.dart';
import 'package:vhcsite_models/vhcsite_models.dart';

/// Holds the static method for generating the internal service middleware
class ServiceManager {
  /// Creates the necessary middleware for the entire server
  static List<Middleware> get middlewares => [
        provider<InternalBlogViewsService>(
          (context) => const InternalBlogViewsService(),
        ),
        provider<InternalVersionService>(
          (context) => const InternalVersionService(),
        ),
      ];
}

/// Adds convenience methods for accessing the internal services
extension RequestContextServices on RequestContext {
  /// For [BlogViews]
  InternalBlogViewsService get blogViewsService => read();

  /// For the version of VHCSite
  InternalVersionService get versionService => read();
}
