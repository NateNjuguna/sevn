import 'package:flutter/material.dart';

import '../list/builder.dart';

class SevnTabConfig<L extends SevnListBuilder> {
  bool active;
  final bool hasFab;
  final String label;
  final L listBuilder;
  final Function() Function(BuildContext) onFabPressed;
  final Function() onRefresh;

  SevnTabConfig({
    this.active = false,
    @required this.label,
    @required this.listBuilder,
    this.onFabPressed,
    this.onRefresh,
  }) : this.hasFab = onFabPressed != null;
}
