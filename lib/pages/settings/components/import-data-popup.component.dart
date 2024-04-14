import 'dart:io';

import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/backup.model.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart' as F;
import 'package:provider/provider.dart';

class ImportDataPopUp extends StatefulWidget {
  final String secretKey;

  const ImportDataPopUp({super.key, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return UnlockPopUpState();
  }

}

class UnlockPopUpState extends State<ImportDataPopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Import Data", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
        actions: [
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ))
            ),
            onPressed: () async {
              File sysFile = File(selectedFile?.path??"");
              Backup b = Backup.fromJson(sysFile.readAsStringSync());
              await b.saveToDb(Provider.of<SecretKeyProvider>(context, listen: false).value);
            },
            child: Text("Encrypt & Save", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
          )
        ],
      content: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ))
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );
                if(result == null) return;
                setState(() {
                  selectedFile = result?.files.first;
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.folder),
                  const SizedBox(width: 5,),
                  Text(selectedFile != null? selectedFile?.name??"Choose a file" : "Choose a file", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),),
                  ),
                ],
              ),),
          ],
        ),
      )
    );
  }

}