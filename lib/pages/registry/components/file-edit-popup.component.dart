import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/validators.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/secret_key.provider.dart';

class EditFilePopUp extends StatefulWidget {
  final void Function() onEditFile;
  final int fileId;
  final int? defaultCollectionId;
  final String secretKey;
  const EditFilePopUp({super.key, required this.onEditFile, required this.fileId, this.defaultCollectionId, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return EditFilePopUpState();
  }

}

class EditFilePopUpState extends State<EditFilePopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? defaultFileData;
  
  bool shouldCreateNewCollection = false;
  Collection? selectedCollection;
  late TextEditingController fileTitleController;
  late TextEditingController fileContentController;
  late TextEditingController collectionNameController;

  List<Collection> collections = [];

  Future<void> fetchCollections() async {
    List<Collection> cls = await DbService.getCollections();
    setState(() {
      collections = cls;
      selectedCollection = (widget.defaultCollectionId != null)? cls[widget.defaultCollectionId!] : null;
    });
    fetchFile();
  }
  Future<void> fetchFile() async {
    File f = await DbService.getFileById(widget.fileId);
    setState(() {
      defaultFileData = f;
      fileTitleController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(f.title, widget.secretKey) : f.title;
      fileContentController.text = widget.secretKey.isNotEmpty? EncryptionService.decode(f.content, widget.secretKey) : f.content;
      selectedCollection = collections.firstWhere((element) => element.id == f.collectionId);
      shouldCreateNewCollection = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fileTitleController = TextEditingController();
    fileContentController = TextEditingController();
    collectionNameController = TextEditingController();
    fetchCollections();
  }

  @override
  void dispose() {
    fileContentController.dispose();
    fileTitleController.dispose();
    collectionNameController.dispose();
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
          child: Text("Cancel", style: FormLabelTxtStyle.classic(14, Colors.redAccent),),
        ),
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ))
          ),
          onPressed: () async {
            bool? isFormValid = _formKey.currentState?.validate();
            if(isFormValid == null || !isFormValid){
              return;
            }
            Navigator.of(context).pop();
            if(shouldCreateNewCollection){
              try{
                int collectionId = await DbService.addCollection((name: collectionNameController.value.text), widget.secretKey);
                await DbService.updateFile(widget.fileId, (title: fileTitleController.value.text, content: fileContentController.value.text, collectionId: collectionId), widget.secretKey);
              } catch(e){
                  print(e);
                //
              }
              finally {
                widget.onEditFile();
              }
            }
            else {
              try{
                await DbService.updateFile(widget.fileId, (title: fileTitleController.value.text, content: fileContentController.value.text, collectionId: selectedCollection!.id), widget.secretKey);
              } catch(e){
                print(e);
                //
              }
              finally {
                widget.onEditFile();
              }
            }
          },
          child: Text("Encrypt & Save", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        ),
      ],
      backgroundColor: ColorPalette.getDarkGray(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Edit ${widget.secretKey.isNotEmpty? EncryptionService.decode(defaultFileData?.title?? "", widget.secretKey) : defaultFileData?.title}", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: fileTitleController,
                  validator: entityNameValidator,
                  style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorPalette.getBlack(0.5),
                    hoverColor: ColorPalette.getBlack(0.5),
                    labelText: "Title",
                    labelStyle: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                    border: InputBorder.none
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: fileContentController,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorPalette.getBlack(0.5),
                    hoverColor: ColorPalette.getBlack(0.5),
                    labelText: "Content",
                    labelStyle: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Create a new collection?", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
                    Checkbox(
                      splashRadius: 0,
                      value: shouldCreateNewCollection,
                      onChanged: (value){
                        setState(() {
                          shouldCreateNewCollection = (value ?? false);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: collectionNameController,
                  validator: (shouldCreateNewCollection? entityNameValidator : (v)=>null),
                  enabled: shouldCreateNewCollection,
                  style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: shouldCreateNewCollection? ColorPalette.getBlack(0.5) : ColorPalette.getBlack(0.2),
                      hoverColor: shouldCreateNewCollection? ColorPalette.getBlack(0.5) : ColorPalette.getBlack(0.2),
                      labelText: "New collection name",
                      labelStyle: shouldCreateNewCollection? FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)) : FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.2)),
                      border: InputBorder.none
                  ),
                ),
                const SizedBox(height: 10,),
                DropdownButtonFormField<Collection>(
                  validator: (collection){
                    if(shouldCreateNewCollection){
                      return null;
                    }
                    if(collection == null){
                      return "Don't forget to choose a collection";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: !shouldCreateNewCollection? ColorPalette.getBlack(0.5) : ColorPalette.getBlack(0.2),
                    hoverColor: !shouldCreateNewCollection? ColorPalette.getBlack(0.5) : ColorPalette.getBlack(0.2),
                    labelText: "Select a collection",
                    labelStyle: !shouldCreateNewCollection? FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)) : FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.2)),
                    border: InputBorder.none
                  ),
                  dropdownColor: ColorPalette.getBlack(0.9),
                  items: shouldCreateNewCollection? [] : collections.map((collection) => DropdownMenuItem<Collection>(
                    value: collection,
                    child: Text(widget.secretKey.isNotEmpty? EncryptionService.decode(collection.name, widget.secretKey) : collection.name, style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),)),
                  ).toList(),
                  value: selectedCollection,
                  onChanged: (collection){
                    setState(() {
                      selectedCollection = collection;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}