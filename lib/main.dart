import 'package:crypt_mobile/common/themes.dart';
import 'package:crypt_mobile/pages/registry/registry.page.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/providers/user_preferences.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  runApp(const MyApp());
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SecretKeyProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => UserPreferencesProvider()
        ),
      ],
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme,
        home: const RegistryPage(),
      ),
    );
  }
}