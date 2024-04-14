import 'package:crypt_mobile/common/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppNameTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold
    );
  }
}

abstract class CollectionNameTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.normal,
        textBaseline: TextBaseline.ideographic
    );
  }
}

abstract class FileNameTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500
    );
  }
}

abstract class FileContentTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w400
    );
  }
}

abstract class FormLabelTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bold(double size, Color color){
    return GoogleFonts.poppins(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }
}

abstract class FormTitleTxtStyle {
  static TextStyle classic(double size, Color color){
    return GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold
    );
  }
}

abstract class SettingsPageTitleTxtStyle {
  static TextStyle classic(double size){
    return GoogleFonts.poppins(
        color: ColorPalette.getWhite(1),
        fontSize: size,
        fontWeight: FontWeight.bold
    );
  }
}

abstract class EncryptedTxtStyle {
  static TextStyle classic(double size, Color color){
    return TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      fontFamily: "Dethek"
    );
  }
}