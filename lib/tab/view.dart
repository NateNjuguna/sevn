import 'package:flutter/material.dart';

import 'config.dart';

class SevnTabBarView extends StatelessWidget {
  final List<SevnTabConfig> configs;
  final TabController controller;

  SevnTabBarView({@required this.configs, @required this.controller});

  @override
  Widget build(BuildContext context) => TabBarView(
        children: configs
            .map<Widget>(
              (SevnTabConfig config) => RefreshIndicator(
                child: ListView(
                  children: <Widget>[
                    config.listBuilder(context),
                  ],
                  padding: EdgeInsets.only(
                    bottom: 80,
                    top: 8,
                  ),
                ),
                onRefresh: () => Future.sync(config.onRefresh),
              ),
            )
            .toList(),
        controller: controller,
      );
}
