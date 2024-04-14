import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';

class DeleteCollectionPopUp extends StatefulWidget {
  final void Function() onDeleteCollection;
  final int collectionId;
  final String secretKey;
  const DeleteCollectionPopUp({super.key, required this.onDeleteCollection, required this.collectionId, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return DeleteCollectionPopUpState();
  }

}

class DeleteCollectionPopUpState extends State<DeleteCollectionPopUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Collection? collection;
  late TextEditingController textEditingController;


  Future<void> fetchFile() async {
    Collection c = await DbService.getCollectionById(widget.collectionId);
    setState(() {
      collection = c;
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    fetchFile();
  }

  @override
  void dispose() {
    textEditingController.dispose();
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
            bool isValid = _formKey.currentState != null? _formKey.currentState!.validate() : false;
            if(isValid){
              Navigator.of(context).pop();
              try{
                await DbService.deleteCollection(widget.collectionId);
                widget.onDeleteCollection();
              }
              catch(e){
                print(e);
              }
            }
          },
          child: Text("Delete it", style: FormLabelTxtStyle.classic(14, Colors.redAccent),),
        ),
      ],
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Delete ${widget.secretKey.isNotEmpty? EncryptionService.decode(collection?.name?? "", widget.secretKey) : collection?.name}", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      content: SizedBox(
        height: 150,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This collection will be lost forever. Are you sure?", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
              const SizedBox(height: 20,),
              TextFormField(
                validator: (v){
                  if(v == null || v.isEmpty || collection == null || v != (widget.secretKey.isNotEmpty? EncryptionService.decode(collection?.name?? "", widget.secretKey) : collection?.name)){
                    return "Please write the collection name correctly";
                  }
                  return null;
                },
                style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorPalette.getBlack(0.5),
                    hoverColor: ColorPalette.getBlack(0.5),
                    labelText: "Type the collection name here",
                    hintText: widget.secretKey.isNotEmpty? EncryptionService.decode(collection?.name?? "", widget.secretKey) : collection?.name,
                    hintStyle: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.3)),
                    labelStyle: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                    border: InputBorder.none
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}