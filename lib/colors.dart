import 'package:flutter/material.dart';

abstract class MainColors {
  abstract Color backgroundColor;
  abstract Color appBarColor;
  abstract Color textColor;
  abstract Color fabColor;
  abstract Color descColor;
}

class GreenColors extends MainColors {
  Color backgroundColor = Colors.green;
  Color appBarColor = Colors.greenAccent;
  Color textColor = Colors.black;
  Color fabColor = Colors.orange;
  Color descColor = Colors.blueGrey;
}

class BlueColors extends MainColors {
  Color backgroundColor = Colors.blue;
  Color appBarColor = Colors.blueAccent;
  Color textColor = Colors.black.withOpacity(0.50);
  Color fabColor = Colors.red;
  Color descColor = Colors.grey;
}

class RedColors extends MainColors {
  Color backgroundColor = Colors.red;
  Color appBarColor = Colors.redAccent;
  Color textColor = Colors.black;
  Color fabColor = Colors.blue;
  Color descColor = Colors.orange;
}

class YellowColors extends MainColors {
  Color backgroundColor = Colors.yellow;
  Color appBarColor = Colors.yellowAccent;
  Color textColor = Colors.black;
  Color fabColor = Colors.green;
  Color descColor = Colors.orange;
}
