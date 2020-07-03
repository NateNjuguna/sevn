import 'package:flutter/material.dart';

import 'config.dart';

class SevnListItem extends StatelessWidget {
  final SevnListItemConfig config;

  SevnListItem(this.config)
      : assert(config.leading != null),
        assert(config.leading.length == 2),
        assert(config.subtitle != null),
        assert(config.subtitle.length > 0),
        assert(config.title != null);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return ListTile(
      leading: Container(
        child: Column(
          children: config.leading,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: themeData.primaryColor,
        ),
        height: 48.0,
        width: 48.0,
      ),
      subtitle: Row(
        children: List.generate(
                config.subtitle.length,
                (int index) => <Widget>[
                      Text(config.subtitle[index]),
                      SizedBox(width: 8.0),
                    ])
            .expand((List<Widget> pair) => pair)
            .take(config.subtitle.length * 2 - 1)
            .toList(),
      ),
      title: Text(config.title),
      trailing: config.trailing,
    );
  }
}