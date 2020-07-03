import 'package:flutter/material.dart';

import 'field.dart';
import 'option.dart';

final Map<DayPeriod, String> _dayPeriodMap = <DayPeriod, String>{
  DayPeriod.am: 'AM',
  DayPeriod.pm: 'PM',
};

typedef FormField<String> SevnFormFieldBuilder(bool disabled, bool focus,
    [void Function(SevnField) onComplete, void Function(SevnField) onSubmit]);

void _onChangeDefault(dynamic s) {}
void _onCompleteDefault() {}
void _onSubmitDefault(String s) {}

class SevnFieldBuilder<T> {
  final SevnField<T> field;
  final void Function(T) onChanged;
  final void Function() onComplete;
  final void Function(String) onSubmit;

  SevnFieldBuilder.of(
    this.field, {
    this.onChanged = _onChangeDefault,
    this.onComplete = _onCompleteDefault,
    this.onSubmit = _onSubmitDefault,
  });

  DropdownMenuItem<T> _buildMenuItem(SevnOption<T> option) => DropdownMenuItem(
        child: Text(option.display),
        value: option.value,
      );

  Widget build(BuildContext context, bool disabled, bool focus, bool last) =>
      field.autofillWrap(
        field.options.length > 0
            ? _buildDropdown(disabled)
            : _buildRegular(context, disabled, focus, last),
      );

  DropdownButtonFormField<T> _buildDropdown(bool disabled) =>
      DropdownButtonFormField<T>(
        decoration: InputDecoration(
          enabled: !disabled,
          labelText: field.require ? '${field.label} *' : field.label,
          hintText: field.placeholder,
        ),
        isDense: true,
        items: field.options.map<DropdownMenuItem<T>>(_buildMenuItem).toList(),
        onChanged: onChanged,
        onSaved: field.handleSaved,
        validator: field.validator,
        value: field.value,
      );

  FormField<T> _buildRegular(BuildContext context, bool disabled, bool focus, bool last) =>
      FormField<T>(
        autovalidate: false,
        builder: field.type == 'date'
            ? _dateFieldBuilder(context, disabled, focus, last)
            : field.type == 'time'
                ? _timeFieldBuilder(context, disabled, focus, last)
                : _textFieldBuilder(disabled, focus, last, false),
        enabled: !disabled,
        onSaved: field.handleSaved,
        validator: field.validator,
      );

  FormFieldBuilder<T> _dateFieldBuilder(
          BuildContext context, bool disabled, bool focus, bool last) =>
      (FormFieldState<T> state) => Stack(
            children: <Widget>[
              _textFieldBuilder(disabled, focus, last, true)(state),
              Positioned(
                child: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now().toLocal(),
                      firstDate: DateTime.tryParse('20100101'),
                      lastDate: DateTime.tryParse('20301231'),
                    ).then(_onDateSelected);
                  },
                ),
                right: 8,
                top: 12,
              ),
            ],
          );

  void _onEditingComplete() {
    field.handleEditingComplete();
    onComplete();
  }

  void _onDateSelected(DateTime dT) {
    if (dT != null) {
      String date = dT.toString().split(' ').first;
      onChanged(date as T);
    }
  }

  void _onTimeSelected (TimeOfDay tD) {
    if (tD != null) {
      String time = '${tD.hourOfPeriod}:${tD.minute > 9 ? tD.minute : '0${tD.minute}'} ${_dayPeriodMap[tD.period]}';
      onChanged(time as T);
    }
  }

  FormFieldBuilder<T> _textFieldBuilder(bool disabled, bool focus, bool last, bool readonly) =>
      (FormFieldState<T> state) => TextField(
            autocorrect: false,
            autofocus: focus,
            controller: field.controller,
            decoration: InputDecoration(
              errorText: state.errorText,
              labelText: field.require ? '${field.label} *' : field.label,
              hintText: field.placeholder,
            ),
            enabled: !disabled,
            expands: field.type == 'textarea',
            focusNode: field.focusNode,
            keyboardType: field.inputType,
            maxLines: field.type == 'textarea' ? 3 : 1,
            obscureText: field.type == 'password',
            onChanged: (String value) {
              onChanged(value as T);
              state.didChange(value as T);
            },
            onEditingComplete: _onEditingComplete,
            onSubmitted: onSubmit,
            readOnly: readonly,
            textCapitalization: ['email', 'password'].contains(field.type)
                ? TextCapitalization.none
                : TextCapitalization.words,
            textInputAction: last ? TextInputAction.go : TextInputAction.next,
          );

  FormFieldBuilder<T> _timeFieldBuilder(
          BuildContext context, bool disabled, bool focus, bool last) =>
      (FormFieldState<T> state) => Stack(
            children: <Widget>[
              _textFieldBuilder(disabled, focus, last, true)(state),
              Positioned(
                child: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then(_onTimeSelected);
                  },
                ),
                right: 8,
                top: 12,
              ),
            ],
          );
}