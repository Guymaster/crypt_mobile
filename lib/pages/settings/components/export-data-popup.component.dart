import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:provider/provider.dart';

class ExportDataPopUp extends StatefulWidget {
  final String secretKey;
  const ExportDataPopUp({super.key, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return UnlockPopUpState();
  }

}

class UnlockPopUpState extends State<ExportDataPopUp> {
  String? selectedPath;

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
      title: Text("Export data", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      actions: [
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ))
          ),
          onPressed: () async {

          },
          child: Text("Decrypt & Save", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        )
      ],
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ))
              ),
              onPressed: () async {
                String? result = await FilePicker.platform.getDirectoryPath();
                if(result == null) return;
                setState(() {
                  selectedPath = result;
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.folder),
                  const SizedBox(width: 5,),
                  Text(selectedPath??"Output path", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),),
                  ),
                ],
              ),),
          ],
        ),
      )
    );
  }

}