import 'package:dart_frog/dart_frog.dart';
import 'package:event_authentication/event_authentication.dart';
import 'package:event_db/event_db.dart';
import 'package:event_frog_logger/event_frog_logger.dart';
import 'package:event_hive/base_event_hive.dart';
import 'package:hive/hive.dart';
import 'package:vhcsite_models/vhcsite_models.dart';

/// An implementation of [BaseHiveRepository] that saves data to a specific
/// location in the file system
class HiveRepository extends BaseHiveRepository {
  /// [modelTypeAdapters] are the same as the ones in [BaseHiveRepository]
  HiveRepository({required super.typeAdapters});

  @override
  void initializeEngine() {
    Hive.init('../vhcsite_api_hive/');
  }

  @override
  // ignore: strict_raw_type
  Future<LazyBox> openBox(String database) async {
    return Hive.openLazyBox(database);
  }
}

/// Adds [SpecificDatabase] methods that help determine the databases for use.
extension DatabaseRequestContext on RequestContext {
  /// The main database used for storing VHCSite Models
  SpecificDatabase get vhcsiteDatabase =>
      SpecificDatabase(read<DatabaseRepository>(), 'vhcsite');
}

/// The type adapters that are required for the [HiveRepository]
final modelTypeAdapters = [
  GenericTypeAdapter<LogModel>(LogModel.new, (p0) => 1),
  GenericTypeAdapter<UserModel>(UserModel.new, (p0) => 2),
  GenericTypeAdapter<UserAuthentication>(UserAuthentication.new, (p0) => 3),
  GenericTypeAdapter<BlogViews>(BlogViews.new, (p0) => 4),
];

/// Constructors needed for the [DatabaseRepository]
Map<Type, GenericModel Function()> get modelConstructors =>
    {for (var v in modelTypeAdapters) v.generator().runtimeType: v.generator};
