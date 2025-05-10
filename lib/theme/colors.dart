import 'package:flutter/material.dart';

class LightColors {
  LightColors._();

  static const _primary = 0xFFFDFFFC;
  static const int _primary_r = 253;
  static const int _primary_g = 255;
  static const int _primary_b = 252;
  static MaterialColor primary = getPallet(_primary, _primary_r, _primary_g, _primary_b);

  static const _secondary = 0xFFC33C54;
  static const int _secondary_r = 195;
  static const int _secondary_g = 60;
  static const int _secondary_b = 84;
  static MaterialColor secondary = getPallet(_secondary, _secondary_r, _secondary_g, _secondary_b);

  static const _background = 0xFFF7F7F7;
  static const int _background_r = 247;
  static const int _background_g = 247;
  static const int _background_b = 247;
  static MaterialColor background = getPallet(_background, _background_r, _background_g, _background_b);

  static const _text = 0xFF31393C;
  static const int _text_r = 49;
  static const int _text_g = 57;
  static const int _text_b = 60;
  static MaterialColor text = getPallet(_text, _text_r, _text_g, _text_b);

  static const _diff1 = 0xFFEB5A50;
  static const int _diff1_r = 235;
  static const int _diff1_g = 90;
  static const int _diff1_b = 80;
  static MaterialColor diff1 = getPallet(_diff1, _diff1_r, _diff1_g, _diff1_b);

  static const _diff2 = 0xFF0AE1BA;
  static const int _diff2_r = 10;
  static const int _diff2_g = 225;
  static const int _diff2_b = 186;
  static MaterialColor diff2 = getPallet(_diff2, _diff2_r, _diff2_g, _diff2_b);

  static const _diff3 = 0xFF586DCC;
  static const int _diff3_r = 88;
  static const int _diff3_g = 109;
  static const int _diff3_b = 204;
  static MaterialColor diff3 = getPallet(_diff3, _diff3_r, _diff3_g, _diff3_b);

  static const _icon = 0xFF263D42;
  static const int _icon_r = 38;
  static const int _icon_g = 61;
  static const int _icon_b = 66;
  static MaterialColor icon = getPallet(_icon, _icon_r, _icon_g, _icon_b);

  static const _shadow = 0xFF646464;
  static const int _shadow_r = 100;
  static const int _shadow_g = 100;
  static const int _shadow_b = 100;
  static MaterialColor shadow = getPallet(_shadow, _shadow_r, _shadow_g, _shadow_b);

  static MaterialColor getPallet(int _color_main, int _color_r,int _color_g,int _color_b) => MaterialColor(
    _color_main,
    <int, Color>{
      50:  Color.fromRGBO(_color_r, _color_g, _color_b, .1),
      100: Color.fromRGBO(_color_r, _color_g, _color_b, .2),
      200: Color.fromRGBO(_color_r, _color_g, _color_b, .3),
      300: Color.fromRGBO(_color_r, _color_g, _color_b, .4),
      400: Color.fromRGBO(_color_r, _color_g, _color_b, .5),
      500: Color.fromRGBO(_color_r, _color_g, _color_b, .6),
      600: Color.fromRGBO(_color_r, _color_g, _color_b, .7),
      700: Color.fromRGBO(_color_r, _color_g, _color_b, .8),
      800: Color.fromRGBO(_color_r, _color_g, _color_b, .9),
      900: Color.fromRGBO(_color_r, _color_g, _color_b, 1),
    },
  );
}

class DarkColors {
  DarkColors._();

  static const _primary = 0xFF1D263B;
  static const int _primary_r = 29;
  static const int _primary_g = 38;
  static const int _primary_b = 59;
  static MaterialColor primary = getPallet(_primary, _primary_r, _primary_g, _primary_b);

  static const _secondary = 0xFFCB586D;
  static const int _secondary_r = 203;
  static const int _secondary_g = 88;
  static const int _secondary_b = 109;
  static MaterialColor secondary = getPallet(_secondary, _secondary_r, _secondary_g, _secondary_b);

  static const _text = 0xFFEDEDED;
  static const int _text_r = 237;
  static const int _text_g = 237;
  static const int _text_b = 237;
  static MaterialColor text = getPallet(_text, _text_r, _text_g, _text_b);

  static const _diff1 = 0xFF4C9EA9;
  static const int _diff1_r = 76;
  static const int _diff1_g = 158;
  static const int _diff1_b = 169;
  static MaterialColor diff1 = getPallet(_diff1, _diff1_r, _diff1_g, _diff1_b);

  static const _diff2 = 0xFFF1A208;
  static const int _diff2_r = 241;
  static const int _diff2_g = 162;
  static const int _diff2_b = 8;
  static MaterialColor diff2 = getPallet(_diff2, _diff2_r, _diff2_g, _diff2_b);

  static const _diff3 = 0xFF8C4843;
  static const int _diff3_r = 140;
  static const int _diff3_g = 72;
  static const int _diff3_b = 67;
  static MaterialColor diff3 = getPallet(_diff3, _diff3_r, _diff3_g, _diff3_b);

  static const _icon = 0xFFFCBF49;
  static const int _icon_r = 252;
  static const int _icon_g = 191;
  static const int _icon_b = 73;
  static MaterialColor icon = getPallet(_icon, _icon_r, _icon_g, _icon_b);

  static const _shadow = 0xFFCECECE;
  static const int _shadow_r = 206;
  static const int _shadow_g = 206;
  static const int _shadow_b = 206;
  static MaterialColor shadow = getPallet(_shadow, _shadow_r, _shadow_g, _shadow_b);

  static MaterialColor getPallet(int _color_main, int _color_r,int _color_g,int _color_b) => MaterialColor(
    _color_main,
    <int, Color>{
      50:  Color.fromRGBO(_color_r, _color_g, _color_b, .1),
      100: Color.fromRGBO(_color_r, _color_g, _color_b, .2),
      200: Color.fromRGBO(_color_r, _color_g, _color_b, .3),
      300: Color.fromRGBO(_color_r, _color_g, _color_b, .4),
      400: Color.fromRGBO(_color_r, _color_g, _color_b, .5),
      500: Color.fromRGBO(_color_r, _color_g, _color_b, .6),
      600: Color.fromRGBO(_color_r, _color_g, _color_b, .7),
      700: Color.fromRGBO(_color_r, _color_g, _color_b, .8),
      800: Color.fromRGBO(_color_r, _color_g, _color_b, .9),
      900: Color.fromRGBO(_color_r, _color_g, _color_b, 1),
    },
  );
}