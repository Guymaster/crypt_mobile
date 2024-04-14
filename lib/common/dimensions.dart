import 'package:flutter/material.dart';

abstract class MQ {
  static double getHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
}