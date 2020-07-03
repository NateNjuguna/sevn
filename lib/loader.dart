import 'package:flutter/material.dart';

class SevnLoader extends StatelessWidget {

  final String label;

  SevnLoader([this.label = 'Loading']);

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      semanticsLabel: label,
    ),
  );
}