import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/validators.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFilePopUp extends StatefulWidget {
  final void Function() onCreateFile;
  final String secretKey;
  const CreateFilePopUp({super.key, required this.onCreateFile, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return CreateFilePopUpState();
  }

}

class CreateFilePopUpState extends State<CreateFilePopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                await DbService.addFile((title: fileTitleController.value.text, content: fileContentController.value.text, collectionId: collectionId), Provider.of<SecretKeyProvider>(context, listen: false).value);
              } catch(e){
                  print(e);
                //
              }
              finally {
                widget.onCreateFile();
              }
            }
            else {
              try{
                await DbService.addFile((title: fileTitleController.value.text, content: fileContentController.value.text, collectionId: selectedCollection!.id), widget.secretKey);
              } catch(e){
                print(e);
                //
              }
              finally {
                widget.onCreateFile();
              }
            }
          },
          child: Text("Encrypt & Save", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        ),
      ],
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Add new data", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
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