import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/pages/registry/registry.page.dart';
import 'package:crypt_mobile/services/database.dart';
import 'package:crypt_mobile/services/encryption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/styles.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  List<String> secrets = [];

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
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: ColorPalette.getDarkGray(1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Focus(
            descendantsAreFocusable: false,
            canRequestFocus: false,
            child: Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder())
                    ),
                    onPressed: (){
                      //appWindow.minimize();
                    },
                    icon: SvgPicture.asset("assets/icons/hide-window.svg",
                      height: 15,
                      width: 15,
                    )),
                IconButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder())
                    ),
                    onPressed: (){
                      //appWindow.maximizeOrRestore();
                    }, icon: SvgPicture.asset("assets/icons/maximize-window.svg",
                  height: 15,
                  width: 15,
                )),
                IconButton(
                    onPressed: (){
                      //appWindow.close();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder())
                    ),
                    icon: SvgPicture.asset("assets/icons/close-window.svg",
                      height: 15,
                      width: 15,
                    )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(((){
                    if(secrets.isEmpty){
                      return "Choose a secret key";
                    }
                    if(secrets.length == 1){
                      return "Type it again";
                    }
                    if(secrets.length == 2){
                      return "Type it one time more please";
                    }
                    return "Congratulations!";
                  })(), style: FormLabelTxtStyle.bold(20, ColorPalette.getWhite(0.7)),),
                ),
                const SizedBox(height: 10,),
                if(secrets.length < 3) Form(
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
                      setState(() {
                        secrets.add(value);
                      });
                      if(secrets.length >= 3){
                        ({String salt, String hash}) hashResult = EncryptionService.generateHash(value);
                        await DbService.addHash(hashResult.hash);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegistryPage()
                        ));
                      }
                    },
                    style: FormLabelTxtStyle.classic(17, ColorPalette.getWhite(0.7)),
                    enabled: (secrets.length < 3),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Where is the secret key?";
                      }
                      if(value.length < 5){
                        return "Too short. Not sufficient!";
                      }
                      if(value.length < 5){
                        return "Too long. You will forget it!";
                      }
                      if(secrets.isEmpty){
                        return null;
                      }
                      if(secrets.last != value){
                        setState(() {
                          secrets = [];
                        });
                        return "What? The code you just entered is different with the previous one. Retry at beginning";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                        errorStyle: FormLabelTxtStyle.classic(14, Colors.deepOrange),
                        filled: true,
                        fillColor: ColorPalette.getBlack(0.5),
                        hoverColor: ColorPalette.getBlack(0.5),
                        hintText: "Nobody should know it",
                        border: InputBorder.none
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}