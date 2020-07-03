import 'package:flutter/widgets.dart';

import '../injectable.dart';

abstract class SevnInjectableWidgetState<T extends StatefulWidget>
    extends State<T> with SevnInjectable {}