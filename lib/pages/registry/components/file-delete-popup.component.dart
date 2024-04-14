import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';

class DeleteFilePopUp extends StatefulWidget {
  final void Function() onDeleteFile;
  final String secretKey;
  final int fileId;
  const DeleteFilePopUp({super.key, required this.onDeleteFile, required this.fileId, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return DeleteFilePopUpState();
  }

}

class DeleteFilePopUpState extends State<DeleteFilePopUp> {
  File? file;

  Future<void> fetchFile() async {
    File f = await DbService.getFileById(widget.fileId);
    setState(() {
      file = f;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ))
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text("Cancel", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        ),
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ))
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await DbService.deleteFile(widget.fileId);
            widget.onDeleteFile();
          },
          child: Text("Delete it", style: FormLabelTxtStyle.classic(14, Colors.redAccent),),
        ),
      ],
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Delete ${widget.secretKey.isNotEmpty? EncryptionService.decode(file?.title?? "", widget.secretKey) : file?.title}", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      content: SizedBox(
        height: 60,
        child: Center(
          child: Text("It will be lost forever. Are you sure?", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        ),
      )
    );
  }

}