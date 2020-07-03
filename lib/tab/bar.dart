import 'package:flutter/material.dart';

import 'config.dart';

class SevnTabBar extends StatelessWidget {
  final List<SevnTabConfig> configs;
  final TabController controller;

  SevnTabBar({@required this.configs, @required this.controller});

  @override
  Widget build(BuildContext context) => TabBar(
        controller: controller,
        indicator: Theme.of(context).tabBarTheme.indicator,
        labelColor: Colors.black87,
        labelPadding: EdgeInsets.only(bottom: 16, top: 16),
        tabs: configs
            .map<Widget>((SevnTabConfig config) => Text(config.label))
            .toList(),
      );
}