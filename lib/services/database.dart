import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const DB_FILE_NAME = "crypt_db.db";

abstract class DbService {
  static Database? _db;
  static Future<Database> init() async {
    String dbPath = await getDatabasesPath();
    dbPath = join(dbPath, DB_FILE_NAME);
    final Database db = await openDatabase(
        dbPath,
        version: 1,
        onConfigure: (Database db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute('CREATE TABLE collection('
              ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' name VARCHAR(50) NOT NULL,'
              ' created_at DATETIME DEFAULT (current_timestamp) NOT NULL,'
              ' updated_at DATETIME DEFAULT (current_timestamp) NOT NULL'
              ')');
          await db.execute('CREATE TABLE file('
              ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' title VARCHAR(50) NOT NULL,'
              ' content TEXT NOT NULL,'
              ' collection_id INTEGER REFERENCES collection(id),'
              ' created_at DATETIME DEFAULT (current_timestamp) NOT NULL,'
              ' updated_at DATETIME DEFAULT (current_timestamp) NOT NULL'
              ')');
          await db.execute('CREATE TABLE setting('
              ' key VARCHAR(50) PRIMARY KEY,'
              ' value TEXT NOT NULL,'
              ' created_at DATETIME DEFAULT (current_timestamp) NOT NULL,'
              ' updated_at DATETIME DEFAULT (current_timestamp) NOT NULL'
              ')');
        }
    );
    _db = db;
    return db;
  }

  static Future<Database> getDb() async {
    return _db?? await init();
  }

  static Future<List<Collection>> getCollections() async {
    Database db = await getDb();
    final List<Map<String, Object?>> collectionMaps = await db.query("collection");
    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'created_at': created_at as int,
      'updated_at': updated_at as int
      } in collectionMaps)
        Collection(
          id: id,
          name: name,
          createdAt: created_at,
          updatedAt: updated_at
        ),
    ];
  }

  static Future<Collection> getCollectionById(int collectionId) async {
    final Database db = await getDb();
    final List<Map<String, Object?>> fileMaps = await db.query("collection",
        where: "id=$collectionId"
    );
    List<Collection> collections = [
      for (final {
      'id': id as int,
      'name': name as String,
      'created_at': created_at as int,
      'updated_at': updated_at as int
      } in fileMaps)
        Collection(
            id: id,
            name: name,
            createdAt: created_at,
            updatedAt: updated_at,
        ),
    ];
    return collections[0];
  }

  static Future<int> addCollection(({
    String name
  }) data, String key) async {
    final Database db = await getDb();
    int id = await db.insert("collection", {
      "name": EncryptionService.encode(data.name, key),
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return id;
  }

  static deleteCollection(int collectionId) async {
    final Database db = await getDb();
    await db.delete("file", where: "collection_id=$collectionId");
    await db.delete("collection", where: "id=$collectionId");
  }

  static updateCollection(int collectionId, ({
    String name
  }) data, String key) async {
    final Database db = await getDb();
    await db.update("collection", {
      "name": EncryptionService.encode(data.name, key),
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, where: "id=$collectionId"
    );
  }

  static Future<List<File>> getFiles(int collectionId) async {
    final Database db = await getDb();
    final List<Map<String, Object?>> fileMaps = await db.query("file",
      where: "collection_id=$collectionId"
    );
    return [
      for (final {
      'id': id as int,
      'title': title as String,
      'content': content as String,
      'created_at': created_at as int,
      'updated_at': updated_at as int
      } in fileMaps)
        File(
            id: id,
            title: title,
            createdAt: created_at,
            updatedAt: updated_at,
            collectionId: collectionId,
            content: content
        ),
    ];
  }

  static Future<File> getFileById(int fileId) async {
    final Database db = await getDb();
    final List<Map<String, Object?>> fileMaps = await db.query("file",
        where: "id=$fileId"
    );
    List<File> files = [
      for (final {
      'id': id as int,
      'title': title as String,
      'content': content as String,
      'collection_id': collection_id as int,
      'created_at': created_at as int,
      'updated_at': updated_at as int
      } in fileMaps)
        File(
            id: id,
            title: title,
            createdAt: created_at,
            updatedAt: updated_at,
            collectionId: collection_id,
            content: content
        ),
    ];
    return files[0];
  }

  static Future<int> addFile(({
    String title,
    String content,
    int collectionId
  }) data, String key) async {
    final Database db = await getDb();
    int id = await db.insert("file", {
      "title": EncryptionService.encode(data.title, key),
      "content": EncryptionService.encode(data.content, key),
      "collection_id": data.collectionId,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return id;
  }

  static updateFile(int fileId, ({
  String title,
  String content,
  int collectionId
  }) data, String key) async {
    final Database db = await getDb();
    await db.update("file", {
      "title": EncryptionService.encode(data.title, key),
      "content": EncryptionService.encode(data.content, key),
      "collection_id": data.collectionId,
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, where: "id=$fileId"
    );
  }

  static deleteFile(int fileId) async {
    final Database db = await getDb();
    await db.delete("file", where: "id=$fileId");
  }

  static Future<String?> getHash() async {
    final Database db = await getDb();
    final List<Map<String, Object?>> settingMaps = await db.query("setting",
        where: "key='hash'"
    );
    List<({String key, String value})> settings = [
      for (final {
      'key': key as String,
      'value': value as String,
      } in settingMaps)
        (key: key, value: value),
    ];
    return settings.isEmpty? null : settings[0].value;
  }

  static Future<int> addHash(String value) async {
    final Database db = await getDb();
    int id = await db.insert("setting", {
      "key": "hash",
      "value": value,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, conflictAlgorithm: ConflictAlgorithm.abort);
    return id;
  }

  static updateHash(String value) async {
    final Database db = await getDb();
    await db.update("setting", {
      "value": value,
      "updated_at": DateTime.now().millisecondsSinceEpoch
    }, where: "key='hash'"
    );
  }

  static Future<bool> changeSecret(String newSecretKey, String key) async {
    final Database db = await getDb();
    final bool success = await db.transaction<bool>((txn) async {
      String? hash = await (() async {
        final List<Map<String, Object?>> settingMaps = await txn.query("setting",
            where: "key='hash'"
        );
        List<({String key, String value})> settings = [
          for (final {
          'key': key as String,
          'value': value as String,
          } in settingMaps)
            (key: key, value: value),
        ];
        return settings.isEmpty? null : settings[0].value;
      })();
      
      bool access = EncryptionService.check(key, hash?? "");
      if(hash == null || !access){
        throw Exception();
      }

      String h = EncryptionService.generateHash(newSecretKey).hash;
      await txn.update("setting", {
        "value": h,
        "updated_at": DateTime.now().millisecondsSinceEpoch
      }, where: "key='hash'"
      );

      //Update files
      final List<Map<String, Object?>> fileMaps = await txn.query("file");
      List<File> oldFiles = [
        for (final {
        'id': id as int,
        'title': title as String,
        'content': content as String,
        'collection_id': collection_id as int,
        'created_at': created_at as int,
        'updated_at': updated_at as int
        } in fileMaps)
          File(
              id: id,
              title: EncryptionService.decode(title, key),
              createdAt: created_at,
              updatedAt: updated_at,
              collectionId: collection_id,
              content: EncryptionService.decode(content, key)
          ),
      ];
      for (File f in oldFiles) {
        await txn.update("file", {
          "title": EncryptionService.encode(f.title, newSecretKey),
          "content": EncryptionService.encode(f.content, newSecretKey),
          "updated_at": DateTime.now().millisecondsSinceEpoch
        }, where: "id=${f.id}"
        );
      }

      //Update collections
      final List<Map<String, Object?>> collectionMaps = await txn.query("collection");
      List<Collection> oldCollections = [
        for (final {
        'id': id as int,
        'name': name as String,
        'created_at': created_at as int,
        'updated_at': updated_at as int
        } in collectionMaps)
          Collection(
            id: id,
            name: EncryptionService.decode(name, key),
            createdAt: created_at,
            updatedAt: updated_at,
          ),
      ];
      for (Collection c in oldCollections) {
        await txn.update("collection", {
          "name": EncryptionService.encode(c.name, newSecretKey),
          "updated_at": DateTime.now().millisecondsSinceEpoch
        }, where: "id=${c.id}"
        );
      }
      return true;
    });
    if(!success){
      throw Exception();
    }
    return true;
  }
}