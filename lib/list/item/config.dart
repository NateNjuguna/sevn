import 'package:flutter/widgets.dart';

import 'config_builder.dart';

class SevnListItemConfig<I> {
  final String group;
  final List<Widget> leading;
  final List<String> subtitle;
  final String title;
  final Widget trailing;

  SevnListItemConfig({
    this.group = '',
    @required this.leading,
    @required this.subtitle,
    @required this.title,
    this.trailing,
  });

  SevnListItemConfig.from(
      SevnListItemConfigBuilder<I> builder, I item)
      : this(
          group: builder.group(item),
          leading: builder.leading(item),
          subtitle: builder.subtitle(item),
          title: builder.title(item),
          trailing: builder.trailing(item),
        );
}