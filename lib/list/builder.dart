import 'package:flutter/material.dart';

import 'item.dart';
import 'widget.dart';

class SevnListBuilder<M> {
  final Future<List<M>> Function() listFuture;
  final SevnListItemConfigBuilder<M> listItemConfigBuilder;
  final String onLoadingText;

  SevnListBuilder({
    @required this.listFuture,
    @required this.listItemConfigBuilder,
    this.onLoadingText = 'Loading',
  });

  SevnListItemConfig<M> addDisplay(M model) => buildListItemConfig(model);

  SevnListWidget buildList(List<M> models) => SevnListWidget(
        models.map<SevnListItemConfig<M>>(addDisplay).toList(),
        groupBy: 'createdAt',
      );

  SevnListItemConfig<M> buildListItemConfig(M model) =>
      SevnListItemConfig<M>.from(listItemConfigBuilder, model);

  Widget call(BuildContext context) => FutureBuilder<List<M>>(
        builder: (BuildContext context, AsyncSnapshot<List<M>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else if (snapshot.hasError) {
            ThemeData themeData = Theme.of(context);
            return Column(
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: themeData.errorColor,
                  semanticLabel: 'Error',
                  size: themeData.iconTheme.size,
                ),
                Text(
                  snapshot.error,
                  style: themeData.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            );
          }
          return CircularProgressIndicator(
            semanticsLabel: onLoadingText,
          );
        },
        future: listFuture(),
      );
}
