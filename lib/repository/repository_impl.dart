import 'package:app/model/write_record.dart';
import 'package:app/repository/repository.dart';
import 'package:app/utils/platform_utils.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl(this._db);

  final Database _db;

  final SubscriptionManager _subscriptionManager = SubscriptionManager();

  @override
  Stream<Iterable<WriteRecord>> subscribeWriteRecordList() {
    return _subscriptionManager.createStream(() async {
      return _db
          .query('record')
          .then((value) => value.map((e) => WriteRecord.fromJson(e)));
    });
  }

  @override
  Future<WriteRecord> createOrUpdateWriteRecord(WriteRecord record) async {
    // On HarmonyOS, sqflite operations may have limitations
    if (PlatformUtils.isOHOS) {
      print('Create/Update operation not supported on HarmonyOS yet');
      return record;
    }
    if (record.id == null) {
      final id = await _db.insert('record', record.toJson());
      _subscriptionManager.publish();
      return record.copyWith(id: id);
    }
    await _db.update('record', record.toJson(),
        where: 'id = ?', whereArgs: [record.id!]);
    _subscriptionManager.publish();
    return record;
  }

  @override
  Future<void> deleteWriteRecord(WriteRecord record) async {
    // On HarmonyOS, sqflite operations may have limitations
    if (PlatformUtils.isOHOS) {
      print('Delete operation not supported on HarmonyOS yet');
      return;
    }
    await _db.delete('record', where: 'id = ?', whereArgs: [record.id!]);
    _subscriptionManager.publish();
  }
}
