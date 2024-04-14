import 'package:dbcrypt/dbcrypt.dart';
import 'package:encrypt_decrypt_plus/cipher/cipher.dart';

abstract class EncryptionService {
  static DBCrypt getHasher() => DBCrypt();

  static ({String hash, String salt}) generateHash(String password){
    final encryptor = getHasher();
    final salt = encryptor.gensalt();
    return (hash: encryptor.hashpw(password, salt), salt: salt);
  }

  static bool check(String password, String hash){
    final encryptor = getHasher();
    bool isValid = encryptor.checkpw(password, hash);
    return isValid;
  }

  static String encode(String text, String key){
    final encrypter = Cipher();
    return encrypter.xorEncode(text, secretKey: key);
  }

  static String decode(String text, String key){
    final encrypter = Cipher();
    return encrypter.xorDecode(text, secretKey: key);
  }
}