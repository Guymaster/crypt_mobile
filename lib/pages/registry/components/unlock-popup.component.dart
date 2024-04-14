import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:provider/provider.dart';

class UnlockPopUp extends StatefulWidget {
  const UnlockPopUp({super.key});

  @override
  State<StatefulWidget> createState() {
    return UnlockPopUpState();
  }

}

class UnlockPopUpState extends State<UnlockPopUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      title: Text("Unlock your crypt", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: textEditingController,
                obscureText: true,
                obscuringCharacter: "漢",
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) async {
                  bool isValid = _formKey.currentState != null? _formKey.currentState!.validate() : false;
                  textEditingController.text = "";
                  if(!isValid) return;
                  String hash = await DbService.getHash()?? "";
                  bool isPasswordCorrect = EncryptionService.check(value, hash);
                  if(isPasswordCorrect){
                    Provider.of<SecretKeyProvider>(context, listen: false).value = value;
                  }
                  Navigator.of(context).pop();
                },
                style: FormLabelTxtStyle.classic(17, ColorPalette.getWhite(0.7)),
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return "Where is the secret key?";
                  }
                },
                autofocus: true,
                decoration: InputDecoration(
                    errorMaxLines: 2,
                    errorStyle: FormLabelTxtStyle.classic(14, Colors.deepOrange),
                    filled: true,
                    labelText: "Type your secret key",
                    fillColor: ColorPalette.getBlack(0.5),
                    hoverColor: ColorPalette.getBlack(0.5),
                    hintText: "Remember it. Remember...",
                    border: InputBorder.none
                ),
              ),
            )
          ],
        ),
      )
    );
  }

}