import 'package:flutter/material.dart';

import 'item.dart';

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

  List<SevnListItem> _buildListItemsfromList(
          List<SevnListItemConfig> list) =>
      list.map<SevnListItem>(_buildListItem).toList();

  SevnListItem _buildListItem(SevnListItemConfig listItemConfig) =>
      SevnListItem(listItemConfig);
}