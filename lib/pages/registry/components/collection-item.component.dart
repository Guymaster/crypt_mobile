import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:provider/provider.dart';

import 'collection-delete-popup.component.dart';

class CollectionItem extends StatefulWidget {
  Collection collection;
  Future<void> Function(Collection file) handleEdit;
  Future<void> Function(Collection file) handleDelete;
  void Function(String name) onPressed;
  final String secretKey;
  bool? selected = false;
  CollectionItem({super.key, required this.onPressed, required this.collection, this.selected, required this.handleDelete, required this.handleEdit, required this.secretKey});

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  ItemMode mode = ItemMode.VIEW;
  FocusNode focusNode = FocusNode();
  FocusNode editFieldFocusNode = FocusNode();
  late TextEditingController textEditingController;

  @override
  void didUpdateWidget(covariant CollectionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    textEditingController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(widget.collection.name, widget.secretKey) : widget.collection.name;
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(widget.collection.name, widget.secretKey) : widget.collection.name;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    editFieldFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          focusNode.requestFocus();
          mode = ItemMode.VIEW;
        });
      },
      onLongPress: (){
        if(widget.secretKey.isEmpty){
          return;
        }
        setState(() {
          focusNode.requestFocus();
          mode = ItemMode.MENU;
        });
      },
      onFocusChange: (isFocused){
        if(!isFocused){
          setState(() {
            focusNode.unfocus();
            mode = ItemMode.VIEW;
          });
        }
      },
      focusNode: focusNode,
      child: Container(
        color: widget.selected!? ColorPalette.getGray(.4) : null,
        height: 35,
        child: Stack(
          children: [
            if ([ItemMode.VIEW, ItemMode.MENU].contains(mode)) TextButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(CollectionNameTxtStyle.classic(14, ColorPalette.getWhite(1))),
                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ))
                ),
                onPressed: (){
                  widget.onPressed(widget.collection.name);
                  setState(() {
                    focusNode.requestFocus();
                    mode = ItemMode.VIEW;
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child:  widget.secretKey.isEmpty? Text(widget.collection.name, style: EncryptedTxtStyle.classic(12, ColorPalette.getWhite(1)),) : Text(EncryptionService.decode(widget.collection.name, widget.secretKey)),
                )
            ) else const SizedBox(),
            if (mode == ItemMode.MENU) GestureDetector(
              onLongPress: (){
                setState(() {
                  mode = ItemMode.VIEW;
                });
              },
              child: Container(
                color: ColorPalette.getBlack(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: IconButton(
                        onPressed: (){
                          if(widget.secretKey.isEmpty) return;
                          setState(() {
                            mode = ItemMode.EDIT;
                            editFieldFocusNode.requestFocus();
                          });
                        },
                        iconSize: 15,
                        icon: const Icon(Icons.edit),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ))
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: IconButton(
                          onPressed: (){
                            if(widget.secretKey.isEmpty) return;
                            showDialog(
                                context: context,
                                builder: (context){
                                  return DeleteCollectionPopUp(
                                    secretKey: widget.secretKey,
                                    collectionId: widget.collection.id,
                                    onDeleteCollection: (){
                                      widget.handleDelete(widget.collection);
                                    },
                                  );
                                }
                            );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ))
                          ),
                          iconSize: 15,
                          icon: const Icon(Icons.delete)
                      ),
                    ),
                  ],
                ),
              ),
            ) else const SizedBox(),
            if (mode == ItemMode.EDIT) Container(
              height: 35,
              color: ColorPalette.getBlack(1),
              child: TextField(
                focusNode: editFieldFocusNode,
                controller: textEditingController,
                textInputAction: TextInputAction.done,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 50,
                onSubmitted: (value) async {
                  if(value.isNotEmpty && value.length > 3 && value.length <= 50){
                    try{
                      await DbService.updateCollection(widget.collection.id, (name: value), widget.secretKey);
                    }
                    catch(e){
                      textEditingController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(widget.collection.name, widget.secretKey) : widget.collection.name;
                      print(e);
                    }
                    finally{
                      widget.handleEdit(widget.collection);
                    }
                  }
                  else{
                    textEditingController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(widget.collection.name, widget.secretKey) : widget.collection.name;
                  }
                },
                style: CollectionNameTxtStyle.classic(14, ColorPalette.getWhite(1)),
                decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7)

                ),
              ),
            ) else const SizedBox(),
          ],
        ),
      ),
    );
  }
}