import 'package:flutter/material.dart';

class MeditPage extends StatelessWidget {
  final Widget body;
  final Widget fab;
  final String title;

  MeditPage({@required this.body, this.fab, @required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: body,
        floatingActionButton: fab,
      );
}