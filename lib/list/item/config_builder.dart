import 'package:flutter/widgets.dart';

class SevnListItemConfigBuilder<M> {

  String Function(M) group;
  final List<Widget> Function(M) leading;
  final List<String> Function(M) subtitle;
  final String Function(M) title;
  Widget Function(M) trailing;
  
  SevnListItemConfigBuilder({
    this.group = _groupDefault,
    @required this.leading,
    @required this.subtitle,
    @required this.title,
    this.trailing = _trailingDefault,
  });

  static String _groupDefault(m) => '';

  static Widget _trailingDefault(m) => SizedBox(height: 8);

}