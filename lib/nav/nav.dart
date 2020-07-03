import 'package:flutter/widgets.dart';

abstract class SevnNav {

  bool get hasFab;
  IconData get icon;
  String get label;
  Widget get view;
  String get title;

  void Function() onFabPressed(BuildContext context);

}