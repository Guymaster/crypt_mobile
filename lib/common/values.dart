import 'package:flutter/material.dart';

const APP_VERSION = "1.0.0";

const HIVE_COLL_NAME = "CRYPT_HIVE";
const HIVE_BOX_NAME = "CRYPT_BOX";

const WINDOW_HEADER_HEIGHT = 30;
const WINDOW_SIDEBAR_WIDTH = 200;

const BUY_ME_A_COFFEE_URL = "https://www.buymeacoffee.com/guyrogerthl";

enum ItemMode {
  VIEW,
  EDIT,
  MENU
}

abstract class ColorPalette {
  static getWhite(double o) => Color.fromRGBO(252, 252, 252, o);
  static getBlack(double o) => Color.fromRGBO(32, 32, 32, o);
  static getDarkGray(double o) => Color.fromRGBO(43, 43, 43, o);
  static getGray(double o) => Color.fromRGBO(81, 81, 81, o);
  
}