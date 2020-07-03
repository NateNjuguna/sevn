import 'package:flutter/material.dart';

class SevnErrorWidget extends StatelessWidget {
  final dynamic message;

  SevnErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
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
          message,
          style: themeData.textTheme.caption,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
