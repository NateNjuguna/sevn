import 'package:meta/meta.dart';

class  SevnOption<T> {

  final String display;
  final T value;

  SevnOption({
    @required this.display,
    @required this.value,
  });

  String toString() => 'Sevn::Option option="$display" "value":"${value.toString()}"}';

}