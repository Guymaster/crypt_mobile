import 'dart:convert';

import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';

typedef PseudoFile = ({String title, String content});
typedef PseudoCollection = ({String name});

class Backup {
  String version = APP_VERSION;
  Map<String, List<PseudoFile>> collections = {};

  void addCollection(PseudoCollection collection, List<PseudoFile> files){
    List<PseudoFile> formattedFiles = files.map<PseudoFile>((f) => (title: f.title, content: f.content)).toList();
    collections.addEntries([
      MapEntry(collection.name, formattedFiles)
    ]);
  }

  ({int totalCollections, int totalFiles}) getStats(){
    int totalFiles = 0;
    for (var e in collections.values) {
      totalFiles = totalFiles + e.length;
    }
    return (totalCollections: collections.keys.length, totalFiles: 0);
  }

  String toJson(){
    return jsonEncode({
      "version": version,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "collections": collections
    });
  }
  static Backup fromJson(String text){
    try {
      Map decoded = jsonDecode(text);
      Backup backup = Backup();
      Map collections = decoded["collections"] as Map;
      for (var c in collections.keys) {
        List fs = collections[c];
        List<PseudoFile> files = [];
        for (var f in fs) {
          files.add((title: utf8.decode(base64.decode(f["title"])), content: utf8.decode(base64.decode(f["content"]))));
        }
        backup.addCollection((name: utf8.decode(base64.decode(c))), files);
      }
      return backup;
    } on Exception catch (e) {
      return Backup();
    }
    return Backup();
  }
  static Backup fromDb(){
    return Backup();
  }
  Future<void> saveToDb(String secretKey) async {
    List<Collection> allCollections = await DbService.getCollections();
    for (String key in collections.keys) {
      bool doCollectionExists = allCollections.any((element) => EncryptionService.decode(element.name, secretKey) == key);
      if(!doCollectionExists){
        await DbService.addCollection((name: key), secretKey);
      }
      allCollections = await DbService.getCollections();
      Collection collection = allCollections.firstWhere((element) => EncryptionService.decode(element.name, secretKey) == key);
      collections[key]?.forEach((f) async {
        await DbService.addFile((collectionId: collection.id, title: f.title, content: f.content), secretKey);
      });
    }
  }
}