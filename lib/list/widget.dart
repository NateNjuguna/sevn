import 'package:flutter/material.dart';

import 'item/config.dart';

class SevnList extends StatelessWidget {
  final Map<String, List<SevnListItemConfig>> _groupedLists =
      <String, List<SevnListItemConfig>>{};
  final List<SevnListItemConfig> list;
  final List<SevnListItemConfig> _list;
  final String groupBy;
  final int limit;
  final bool reverse;

  SevnList(this.list, {this.groupBy, this.limit, this.reverse = false})
      : _list = (reverse ? list.reversed : list)
            .take(limit == null || limit > list.length ? list.length : limit)
            .toList() {
    if (groupBy != null) {
      _list.forEach((SevnListItemConfig listItemConfig) {
        String groupKey = listItemConfig.group;
        _groupedLists.update(
            groupKey,
            (List<SevnListItemConfig> current) =>
                current..add(listItemConfig),
            ifAbsent: () => <SevnListItemConfig>[listItemConfig]);
      });
    }
  }

  @override
  Widget build(BuildContext context) => list.length > 0
      ? Column(
          children: groupBy == null
              ? _buildListItemsfromList(_list)
              : _groupedLists
                  .map<String, List<Widget>>(
                      (String key, List<SevnListItemConfig> list) =>
                          MapEntry(
                              key,
                              <Widget>[
                                Text(
                                  key,
                                  style: Theme.of(context).textTheme.subtitle2,
                                )
                              ]..addAll(_buildListItemsfromList(list))))
                  .values
                  .expand((List<Widget> list) => list)
                  .toList(),
        )
      : Center(
          child: Text(
            'No records here yet.',
            style: Theme.of(context).textTheme.overline,
          ),
        );

  List<_SevnListItem> _buildListItemsfromList(
          List<SevnListItemConfig> list) =>
      list.map<_SevnListItem>(_buildListItem).toList();

  _SevnListItem _buildListItem(SevnListItemConfig listItemConfig) =>
      _SevnListItem(listItemConfig);
}

class _SevnListItem extends StatelessWidget {
  final SevnListItemConfig config;

  _SevnListItem(this.config)
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
