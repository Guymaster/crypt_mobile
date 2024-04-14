import 'package:contextual_menu/contextual_menu.dart';
import 'package:crypt_mobile/common/dimensions.dart';
import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'file-item-menu.component.dart';

class FileItem extends StatefulWidget {
  File file;
  Future<void> Function(File file) handleEdit;
  Future<void> Function(File file) handleDelete;
  FileItem({super.key, required this.handleEdit, required this.handleDelete, required this.file});

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {

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
    return Consumer<SecretKeyProvider>(
      builder: (BuildContext context, SecretKeyProvider secretKeyProvider, Widget? child) {
        return GestureDetector(
          onSecondaryTapUp: (details){
            if(secretKeyProvider.value.isEmpty) return;
            popUpContextualMenu(
              FileItemMenu((){
                Clipboard.setData(ClipboardData(text: widget.file.content));
              }, (){
                if(secretKeyProvider.value.isEmpty) return;
                widget.handleEdit(widget.file);
              }, (){
                if(secretKeyProvider.value.isEmpty) return;
                widget.handleDelete(widget.file);
              }),
              placement: Placement.bottomLeft,
            );
          },
          child: Card(
            elevation: 0,
            color: ColorPalette.getDarkGray(0.5),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: (MQ.getWidth(context) > 800)? 90 : 10),
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                  hasIcon: false
              ),
              header: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(secretKeyProvider.value.isNotEmpty? EncryptionService.decode(widget.file.title, secretKeyProvider.value) : widget.file.title, style: secretKeyProvider.value.isEmpty? EncryptedTxtStyle.classic(15, ColorPalette.getWhite(1)) : FileNameTxtStyle.classic(15, ColorPalette.getWhite(1)),),
              ),
              collapsed: const SizedBox(),
              expanded: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(secretKeyProvider.value.isNotEmpty? EncryptionService.decode(widget.file.content, secretKeyProvider.value) : widget.file.content, style: secretKeyProvider.value.isEmpty? EncryptedTxtStyle.classic(14, ColorPalette.getWhite(0.7)) : FileContentTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}