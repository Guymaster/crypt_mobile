import 'dart:convert';

import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/models/collection.model.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:crypt_mobile/models/file.model.dart';
import 'package:provider/provider.dart';

class ChangeSecretKeyPopUp extends StatefulWidget {
  final String secretKey;
  const ChangeSecretKeyPopUp({super.key, required this.secretKey});

  @override
  State<StatefulWidget> createState() {
    return ChangeSecretKeyPopUpState();
  }

}

class ChangeSecretKeyPopUpState extends State<ChangeSecretKeyPopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController oldSecretEditingController;
  late TextEditingController newSecret1EditingController;
  late TextEditingController newSecret2EditingController;
  late TextEditingController newSecret3EditingController;

  @override
  void initState() {
    super.initState();
    oldSecretEditingController = TextEditingController();
    newSecret1EditingController = TextEditingController();
    newSecret2EditingController = TextEditingController();
    newSecret3EditingController = TextEditingController();
  }

  @override
  void dispose() {
    oldSecretEditingController.dispose();
    newSecret1EditingController.dispose();
    newSecret2EditingController.dispose();
    newSecret3EditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.getBlack(1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      actions: [
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
            if(oldSecretEditingController.text != Provider.of<SecretKeyProvider>(context, listen: false).value){
              return;
            }
            Navigator.of(context).pop();
            try{
              await DbService.changeSecret(newSecret1EditingController.text, widget.secretKey);
              Provider.of<SecretKeyProvider>(context, listen: false).value = "";
            }
            catch(e){
              rethrow;
            }
          },
          child: Text("Decrypt & Reencrypt", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),),
        ),
      ],
      title: Text("You are going to change your Secret Key", style: FormTitleTxtStyle.classic(20, ColorPalette.getWhite(1)),),
      content: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      controller: oldSecretEditingController,
                      obscureText: true,
                      obscuringCharacter: "漢",
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      style: FormLabelTxtStyle.classic(17, ColorPalette.getWhite(0.7)),
                      validator: (value) {
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
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: newSecret1EditingController,
                      obscureText: true,
                      obscuringCharacter: "漢",
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
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
                          labelText: "Type your new secret key",
                          fillColor: ColorPalette.getBlack(0.5),
                          hoverColor: ColorPalette.getBlack(0.5),
                          hintText: "Not the same",
                          border: InputBorder.none
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: newSecret2EditingController,
                      obscureText: true,
                      obscuringCharacter: "漢",
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      style: FormLabelTxtStyle.classic(17, ColorPalette.getWhite(0.7)),
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return "Where is the secret key?";
                        }
                        if(value != newSecret1EditingController.text){
                          return "It doesn't match";
                        }
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorStyle: FormLabelTxtStyle.classic(14, Colors.deepOrange),
                          filled: true,
                          labelText: "Type your old huh... your new secret key again",
                          fillColor: ColorPalette.getBlack(0.5),
                          hoverColor: ColorPalette.getBlack(0.5),
                          hintText: "Hope you won't forget it",
                          border: InputBorder.none
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: newSecret3EditingController,
                      obscureText: true,
                      obscuringCharacter: "漢",
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
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
                          labelText: "Type your new secret key one time more",
                          fillColor: ColorPalette.getBlack(0.5),
                          hoverColor: ColorPalette.getBlack(0.5),
                          hintText: "Please",
                          border: InputBorder.none
                      ),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}