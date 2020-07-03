import 'package:flutter_autofill/flutter_autofill.dart';
import 'package:flutter/material.dart';

import 'option.dart';

final Map<String, TextInputType> _textInputTypeMap = <String, TextInputType>{
  'datetime': TextInputType.datetime,
  'email': TextInputType.emailAddress,
  'number': TextInputType.number,
  'password': TextInputType.visiblePassword,
  'tel': TextInputType.phone,
  'text': TextInputType.text,
  'textarea': TextInputType.multiline,
  'url': TextInputType.url,
};

class SevnField<T> {
  final bool autocomplete;
  TextEditingController controller;
  bool $dirty = false,
      $invalid = false,
      $pristine = true,
      $touched = false,
      $valid = false;
  final String label, name, placeholder, type;
  FocusNode focusNode;
  final TextInputType inputType;
  final num max, min, step;
  final int maxlength, minlength;
  final List<SevnOption<T>> options;
  final bool require, valueIsString;
  T value;

  SevnField({
    this.autocomplete = false,
    @required this.label,
    this.max,
    this.maxlength,
    this.min,
    this.minlength,
    @required this.name,
    List<SevnOption<T>> options,
    this.placeholder = '',
    this.require = false,
    this.step = 1,
    @required this.type,
  })  : inputType = _textInputTypeMap[type],
        options = options ?? <SevnOption<T>>[],
        valueIsString = [
          'date',
          'datetime',
          'email',
          'password',
          'select',
          'tel',
          'text',
          'textarea',
          'time',
          'url',
        ].contains(type);

  Widget autofillWrap(FormField<T> child) => autocomplete
      ? Autofill(
          autofillHints: <String, List<String>>{
                'email': [FlutterAutofill.AUTOFILL_HINT_USERNAME],
                'password': [FlutterAutofill.AUTOFILL_HINT_PASSWORD],
              }[type] ??
              [],
          autofillType: FlutterAutofill.AUTOFILL_TYPE_TEXT,
          child: child,
          onAutofilled: (dynamic value) {
            controller.value = TextEditingValue(
              text: value.toString(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: value.toString().length),
              ),
            );
          },
          textController: controller,
        )
      : child;

  void destroy() {
    focusNode.dispose();
    controller.removeListener(onChange);
    controller.dispose();
  }

  void handleEditingComplete() {
    focusNode.unfocus();
  }

  void handleSaved(T result) {
    value = result;
  }

  void init() {
    focusNode = FocusNode();
    controller = TextEditingController();
    controller.addListener(onChange);
  }

  void onChange() {
    if ($pristine) {
      $pristine = false;
    }
    if (!$touched) {
      $touched = true;
    }
    $dirty = controller.value.text.isNotEmpty;
  }

  String toString() =>
      '{"label":"$label","max":"$max","maxlength":"$maxlength","min":"$min","minlength":"$minlength","name":"$name","required":"$require","step":"$step","type":"$type","value":"$value"}';

  String validator(T valueX) {
    String val = valueX.toString();
    if (require && $pristine && (val ?? '').isEmpty) {
      return 'This field is required';
    }
    if ($touched) {
      _invalidate();
      if (require && val.isEmpty) {
        return 'This field is required';
      }
      if (type == 'email') {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(val)) return 'Please provide a valid email';
      }
      if (valueIsString) {
        if (maxlength != null && val.length > maxlength) {
          return 'This value must be less than ${maxlength + 1} characters';
        }
        if (minlength != null && val.length < minlength) {
          return 'This value must be more than ${minlength - 1} characters';
        }
      }
      if (type == 'number') {
        num x = num.parse(val);
        if (max != null && x > max) {
          return 'This value must be less than ${maxlength + step}';
        }
        if (min != null && x < min) {
          return 'This value must be less than ${maxlength - step}';
        }
      }
      _validate();
    }
    return null;
  }

  void _invalidate() {
    $invalid = true;
    $valid = false;
  }

  void _validate() {
    $valid = true;
    $invalid = false;
  }

  static SevnField<String> date({
    @required String label,
    @required String name,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: false,
        label: label,
        maxlength: 10,
        minlength: 8,
        name: name,
        require: require,
        placeholder: placeholder,
        type: 'date',
      );

  static SevnField<String> email({
    bool autocomplete = false,
    @required String label,
    @required String name,
    int maxlength,
    int minlength,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: autocomplete,
        label: label,
        maxlength: maxlength,
        minlength: minlength,
        name: name,
        placeholder: placeholder,
        require: require,
        type: 'email',
      );

  static SevnField<num> number({
    @required String label,
    @required String name,
    num max,
    num min,
    String placeholder,
    bool require = false,
    num step,
  }) =>
      SevnField<num>(
        autocomplete: false,
        label: label,
        max: max,
        min: min,
        name: name,
        placeholder: placeholder,
        require: require,
        step: step,
        type: 'number',
      );

  static SevnField<String> password({
    bool autocomplete = false,
    @required String label,
    @required String name,
    int maxlength,
    int minlength,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: autocomplete,
        label: label,
        maxlength: maxlength,
        minlength: minlength,
        name: name,
        placeholder: placeholder,
        require: require,
        type: 'password',
      );

  static SevnField<T> select<M, T>({
    @required String label,
    @required String name,
    @required List<M> options,
    @required SevnOption<T> Function(M) optionBuilder,
    String placeholder,
    bool require = false,
    @required String type,
  }) =>
      SevnField<T>(
        autocomplete: false,
        label: label,
        name: name,
        options: options.map<SevnOption<T>>(optionBuilder).toList(),
        placeholder: placeholder,
        require: require,
        type: type,
      );

  static SevnField<String> tel({
    @required String label,
    @required String name,
    int maxlength,
    int minlength,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: false,
        label: label,
        maxlength: maxlength,
        minlength: minlength,
        name: name,
        require: require,
        placeholder: placeholder,
        type: 'tel',
      );

  static SevnField<String> text({
    @required String label,
    @required String name,
    int maxlength,
    int minlength,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: false,
        label: label,
        maxlength: maxlength,
        minlength: minlength,
        name: name,
        require: require,
        placeholder: placeholder,
        type: 'text',
      );

  static SevnField<String> textArea({
    @required String label,
    @required String name,
    int maxlength,
    int minlength,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: false,
        label: label,
        maxlength: maxlength,
        minlength: minlength,
        name: name,
        require: require,
        placeholder: placeholder,
        type: 'textarea',
      );

  static SevnField<String> time({
    @required String label,
    @required String name,
    String placeholder,
    bool require = false,
  }) =>
      SevnField<String>(
        autocomplete: false,
        label: label,
        maxlength: 8,
        minlength: 7,
        name: name,
        require: require,
        placeholder: placeholder,
        type: 'time',
      );
}
