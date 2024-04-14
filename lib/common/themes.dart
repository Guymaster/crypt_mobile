import 'package:flutter/material.dart';

ThemeData AppTheme = ThemeData(
brightness: Brightness.dark,
visualDensity: VisualDensity.standard,
elevatedButtonTheme: ElevatedButtonThemeData(
style: ButtonStyle(
backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
if (states.contains(MaterialState.hovered)) return Color(0xff727272);
return Color(0xff515151);
}),
),
),
textButtonTheme: TextButtonThemeData(
style: ButtonStyle(
backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
if (states.contains(MaterialState.hovered)) return Color(0xff2b2b2b);
return null;
}),
foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
if (states.contains(MaterialState.hovered)) return Color(0xffffffff);
return Color(0xffffffff);
}),
),
),
primaryColor: Color(0xff202020),
primaryColorLight: Color(0xff202020),
primaryColorDark: Color(0xff202020),
hintColor: Color(0xff515151),
canvasColor: Color(0xff202020),
shadowColor: Color(0xff515151),
scaffoldBackgroundColor: Color(0xff202020),
cardColor: Color(0xff2b2b2b),
dividerColor: Color(0xff515151), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xffffffff); }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xffffffff); }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xffffffff); }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Color(0xffffffff); }
 return null;
 }),
 ),
);