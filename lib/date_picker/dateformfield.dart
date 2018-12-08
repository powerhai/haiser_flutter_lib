import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haiser_flutter_lib/date_picker/datePicker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:meta/meta.dart';

/// A [FormField<TimeOfDay>] that uses a [TextField] to manage input.
/// If it gains focus while empty, the time picker will be shown to the user.
class DatePickerFormField extends FormField<DateTime> {
  final DateFormat format;
  final IconData resetIcon;
  final FormFieldValidator<DateTime> validator;
  final FormFieldSetter<DateTime> onSaved;
  final ValueChanged<DateTime> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;

  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final DateTime initialValue;
  DateTime startDate;
  DateTime endDate; 
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final ValueChanged<DateTime> onChanged;
  DatePickerFormField(
      {Key key,

      /// For representing the time as a string e.g.
      /// `DateFormat("h:mma")` (9:24pm). You can also use the helper function
      /// [toDateFormat(TimeOfDayFormat)].
      @required this.format,

      /// Called whenever the state's value changes, e.g. after the picker value
      /// has been selected or when the field loses focus. To listen for all text
      /// changes, use the [controller] and [focusNode].
      this.onChanged,

      /// By default the TextField [decoration]'s [suffixIcon] will be
      /// overridden to reset the input using the icon defined here.
      /// Set this to `null` to stop that behavior.
      this.resetIcon: Icons.close,

      /// The initial time prefilled in the picker dialog when it is shown.
      

      /// For validating the [TimeOfDay]. The value passed will be `null` if
      /// [format] fails to parse the text.
      this.validator,

      /// Called when an enclosing form is saved. The value passed will be `null`
      /// if [format] fails to parse the text.
      this.onSaved,

      /// Called when an enclosing form is submitted. The value passed will be
      /// `null` if [format] fails to parse the text.
      this.onFieldSubmitted,
      bool autovalidate: false,

      // TextField properties
      TextEditingController controller,
      FocusNode focusNode,
      this.initialValue,
      this.decoration: const InputDecoration(),
      this.keyboardType: TextInputType.text,
      this.style,
      this.textAlign: TextAlign.start,
      this.autofocus: false,
      this.obscureText: false,
      this.autocorrect: true,
      this.maxLengthEnforced: true,
      this.enabled,
      this.maxLines: 1,
      this.maxLength,
      this.inputFormatters,
      DateTime startDate,
      DateTime endDate})
      : controller = controller ??
            TextEditingController(text: _toString(initialValue, format)),
        focusNode = focusNode ?? FocusNode(),
        super(
            key: key,
            autovalidate: autovalidate,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<DateTime> field) {
              // final _TimePickerTextFormFieldState state = field;
            }) {
    this.startDate = startDate == null ? new DateTime(1960, 1, 1) : startDate;
    this.endDate = endDate == null ? new DateTime.now() : endDate;
  }

  @override
  _TimePickerTextFormFieldState createState() =>
      _TimePickerTextFormFieldState(this);
}

class _TimePickerTextFormFieldState extends FormFieldState<DateTime> {
  final DatePickerFormField parent;
 

  _TimePickerTextFormFieldState(this.parent);

  @override
  void setValue(DateTime value) { 
    super.setValue(value);
    if (parent.onChanged != null) parent.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    parent.controller.removeListener(inputChanged);
    parent.focusNode.removeListener(inputChanged);
    super.dispose();
  }

  void inputChanged() {
    if (parent.focusNode.hasFocus) {
      getTimeInput(context).then((time) {
        parent.focusNode.unfocus();
        if (time == null) return;
        setState(() {
          parent.controller.text = _toString(time, parent.format);
          setValue(time);
        });
      });
    } 
    if (!parent.focusNode.hasFocus) {
      setValue(_toTime(parent.controller.text, parent.format));
    }
  }

  DateTime curDate;

  Future<DateTime> getTimeInput(BuildContext context) async {
    
    var rv = await showDatePicker2( );
    /*await showDatePicker(
      firstDate: new DateTime(1978),
      lastDate: new DateTime(2018),
      context: context,
      initialDate: date,
    );*/
    if (rv != null) this.curDate = rv;
    return rv;
  }

  Future<DateTime> showDatePicker2() async {
    var date = curDate == null?  parent.initialValue : curDate;
    var dialog = new DatePicker( startDate: parent.startDate, endDate: parent.endDate, date: date );
    var rv = await showDialog(context: this.context, builder: (c) => dialog);
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: parent.controller,
      focusNode: parent.focusNode,
      decoration: parent.decoration,
      keyboardType: parent.keyboardType,
      style: parent.style,
      textAlign: parent.textAlign,
      autofocus: parent.autofocus,
      obscureText: parent.obscureText,
      autocorrect: parent.autocorrect,
      maxLengthEnforced: parent.maxLengthEnforced,
      maxLines: parent.maxLines,
      maxLength: parent.maxLength,
      inputFormatters: parent.inputFormatters,
      enabled: true,
      onFieldSubmitted: (value) {
        if (parent.onFieldSubmitted != null) {
          return parent.onFieldSubmitted(_toTime(value, parent.format));
        }
      },
      validator: (value) {
        if (parent.validator != null) {
         return parent.validator(this.value);
        }
      },
      onSaved: (value) {
        if (parent.onSaved != null) { 
            parent.onSaved(this.value); 
        }
      },
    );
  }
}

String _toString(DateTime time, DateFormat formatter) {
  if (time != null) {
    try {
      return formatter.format(time);
    } catch (e) {
      debugPrint('Error formatting time: $e');
    }
  }
  return '';
}

DateTime _toTime(String string, DateFormat formatter) {
  if (string != null && string.isNotEmpty) {
    try {
      var date = formatter.parse(string);
      return date;
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
  }
  return null;
}
