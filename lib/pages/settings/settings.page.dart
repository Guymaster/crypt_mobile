import 'package:crypt_mobile/common/dimensions.dart';
import 'package:crypt_mobile/common/styles.dart';
import 'package:crypt_mobile/common/values.dart';
import 'package:crypt_mobile/pages/registry/registry.page.dart';
import 'package:crypt_mobile/pages/settings/components/change-secret-key-popup.component.dart';
import 'package:crypt_mobile/pages/settings/components/import-data-popup.component.dart';
import 'package:crypt_mobile/providers/secret_key.provider.dart';
import 'package:crypt_mobile/providers/user_preferences.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/export-data-popup.component.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  int? selectedTimeToLock;

  @override
  void initState() {
    super.initState();
    selectedTimeToLock = Provider.of<UserPreferencesProvider>(context, listen: false).timeToLock;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Focus(
            descendantsAreFocusable: false,
            canRequestFocus: false,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegistryPage()));
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder())
                    ),
                    iconSize: 15,
                    icon: const Icon(Icons.arrow_back_ios_new_sharp)
                ),
                Row(
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
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: (MQ.getWidth(context) < 800? MQ.getWidth(context)*0.9 : 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings", style: SettingsPageTitleTxtStyle.classic(40),),
                    const SizedBox(height: 40,),
                    Text("General", style: FormLabelTxtStyle.classic(18, ColorPalette.getGray(1)),),
                    const SizedBox(height: 20,),
                    DropdownButtonFormField<int>(
                      value: selectedTimeToLock,
                      validator: (n){
                        if(n == null){
                          return "Please choose";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorPalette.getBlack(0.5),
                          hoverColor: ColorPalette.getBlack(0.5),
                          labelText: "Time to lock",
                          labelStyle: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(0.7)),
                          border: InputBorder.none
                      ),
                      dropdownColor: ColorPalette.getBlack(0.9),
                      items: [3, 5, 10, 30].map((n) => DropdownMenuItem<int>(
                          value: n,
                          child: Text("${n.toString()} minutes")),
                      ).toList(),
                      onChanged: (time){
                        setState(() {
                          selectedTimeToLock = time;
                          Provider.of<UserPreferencesProvider>(context, listen: false).timeToLock = time?? 5;
                        });
                      },
                    ),
                    const SizedBox(height: 20,),
                    Text("Security", style: FormLabelTxtStyle.classic(18, ColorPalette.getGray(1)),),
                    const SizedBox(height: 20,),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ))
                      ),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return ChangeSecretKeyPopUp(secretKey: Provider.of<SecretKeyProvider>(context, listen: false).value);
                            }
                        ).whenComplete(() => Provider.of<SecretKeyProvider>(context, listen: false).value = "");
                      },
                      child: Text("Change Secret Key", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),),
                    ),),
                    const SizedBox(height: 20,),
                    Text("Data bank", style: FormLabelTxtStyle.classic(18, ColorPalette.getGray(1)),),
                    const SizedBox(height: 20,),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ))
                      ),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return ImportDataPopUp(secretKey: Provider.of<SecretKeyProvider>(context).value);
                            }
                        );
                      },
                      child: Text("Import", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ))
                      ),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return ExportDataPopUp(secretKey: Provider.of<SecretKeyProvider>(context).value);
                            }
                        );
                      },
                      child: Text("Export", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text("Author", style: FormLabelTxtStyle.classic(18, ColorPalette.getGray(1)),),
                    const SizedBox(height: 20,),
                    TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ))
                      ),
                      onPressed: () async {
                        final _url = Uri.parse(BUY_ME_A_COFFEE_URL);
                        if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
                          print('Could not launch $BUY_ME_A_COFFEE_URL');
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.coffee),
                          const SizedBox(width: 5,),
                          Text("Buy me a Coffee", style: FormLabelTxtStyle.classic(14, ColorPalette.getWhite(1),))
                        ],
                      ),
                    ),
                    const SizedBox(height: 40,)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}