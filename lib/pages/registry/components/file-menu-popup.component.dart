import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';

class FileMenuPopUp extends StatefulWidget {
  final void Function() onChooseDelete;
  final void Function() onChooseCopy;
  final void Function() onChooseUpdate;
  const FileMenuPopUp({super.key, required this.onChooseDelete, required this.onChooseCopy, required this.onChooseUpdate});

  @override
  State<StatefulWidget> createState() {
    return FileMenuPopUpState();
  }

}

class FileMenuPopUpState extends State<FileMenuPopUp> {

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
      content: SizedBox(
        height: 170,
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ))
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.onChooseCopy();
              },
              child: Text("Copy", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1)),),
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ))
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.onChooseUpdate();
              },
              child: Text("Edit", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1)),),
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ))
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                widget.onChooseDelete();
              },
              child: Text("Delete", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1)),),
            )
          ],
        ),
      )
    );
  }

}