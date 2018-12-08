import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haiser_flutter_lib/two_level_picker/models.dart';

class TwoLevelFormField extends FormField<LevelB> {
  final FormFieldValidator<LevelB> validator;
  final FormFieldSetter<LevelB> onSaved;
  final ValueChanged<LevelB> onFieldSubmitted;
  final ValueChanged<LevelB> onChanged;
  final TextEditingController controller;
  final List<LevelA> list;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextStyle style;

  TwoLevelFormField(
      {Key key,
      TextEditingController controller,
      this.validator,
      this.onSaved,
      this.onFieldSubmitted,
      FocusNode focusNode,
      this.decoration,
      this.style,
      this.onChanged,
      LevelB initialValue,
      this.list})
      : controller = controller ?? TextEditingController(text: ""),
        focusNode = focusNode ?? FocusNode(),
        super(key: key, builder: (c) {}, initialValue: initialValue);

  @override
  TwoLevelFormFieldState createState() => TwoLevelFormFieldState();
}

class TwoLevelFormFieldState extends FormFieldState<LevelB> {
  LevelB currentLevel;
  @override
  TwoLevelFormField get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    setText();
    return GestureDetector(
        onTap: () {
          inputChanged();
        },
        child: AbsorbPointer(
            child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: widget.decoration,
          style: widget.style,
          enabled: true,
          onFieldSubmitted: (value) {
            if (widget.onFieldSubmitted != null) {
              return widget.onFieldSubmitted(currentLevel);
            }
          },
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator(this.currentLevel);
            }
          },
          onSaved: (value) {
            print(value);
            if (widget.onSaved != null) {
              widget.onSaved(this.currentLevel);
            }
          },
        )));
  }

  @override
  void setValue(LevelB value) {
    super.setValue(value);
    if (widget.onChanged != null) widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    //widget.focusNode.addListener(inputChanged);
    //widget.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    //widget.controller.removeListener(inputChanged);
    //widget.focusNode.removeListener(inputChanged);
    super.dispose();
  }

  void setText() {
    if (currentLevel != null) {
      LevelA levelA;
      for (var i = 0; i < this.widget.list.length; i++) {
        var a = this.widget.list[i];
        for (var j = 0; j < a.list.length; j++) {
          var b = a.list[j];
          if (currentLevel.id == b.id) {
            levelA = a;
            break;
          }
        }
      }
      setState(() {
        widget.controller.text =
            '${levelA.data.toString()} - ${currentLevel.data.toString()}';
      });
    }
  }

  void inputChanged() {
    getTimeInput(context).then((v) {
      widget.focusNode.unfocus();
      if (v == null) return;
      setValue(v);
      setText();
      setState(() {
        currentLevel = v;
      });
    });
    //setValue(currentLevel);
  }

  Future<LevelB> getTimeInput(BuildContext context) async {
    var rv = await showLevelPicker();
    if (rv != null) this.currentLevel = rv;
    return rv;
  }

  Future<LevelB> showLevelPicker() async {
    var level =
        this.currentLevel == null ? widget.initialValue : this.currentLevel;
    var dialog = new TwoLevelPicker(widget.list, level);
    var rv = await showDialog(
        context: this.context,
        builder: (c) {
          return dialog;
        });
    return rv;
  }
}

class TwoLevelPicker extends StatefulWidget {
  List<LevelA> list;
  LevelB initialValue;

  TwoLevelPicker(List<LevelA> this.list, LevelB this.initialValue);

  @override
  State<StatefulWidget> createState() => new TwoLevelPickerState();
}

class TwoLevelPickerState extends State<TwoLevelPicker> {
  FixedExtentScrollController scrollAController;
  FixedExtentScrollController scrollBController;

  LevelA currentALevel;
  LevelB currentBLevel;
  @override
  Widget build(BuildContext context) {
    return wgDialog();
  }

  Widget wgDialog() {
    var row1 = new Row(
      children: <Widget>[wgLevelA(), wgLevelB()],
    );
    var row2 = Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(width: 20.0),
            RaisedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.pop(context, currentBLevel);
                })
          ],
        ));

    return new Dialog(
        child: Container(
            color: Colors.grey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[row1, row2])));
  }

  Widget wgLevelA() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: 200.0,
          decoration: BoxDecoration(
              border: Border(top: BorderSide()), color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: this.scrollAController,
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                currentALevel = this.widget.list[index];
                this.scrollBController.jumpTo(0.0);
                currentBLevel = currentALevel.list[this.scrollBController.selectedItem];
              });
            },
            children:
                List<Widget>.generate(this.widget.list.length, (int index) {
              return Text(
                this.widget.list[index].data.toString(),
                style: TextStyle(color: Color(0xFF000046), fontSize: 20.0),
                textAlign: TextAlign.start,
              );
            }),
          )),
    );
  }

  Widget wgLevelB() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: 200.0,
          decoration: BoxDecoration(
              border: Border(top: BorderSide()), color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: this.scrollBController,
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              this.currentBLevel = this.currentALevel.list[index];
            },
            children: List<Widget>.generate(this.currentALevel.list.length,
                (int index) {
              return Text(
                this.currentALevel.list[index].data.toString(),
                style: TextStyle(color: Color(0xFF000046), fontSize: 20.0),
                textAlign: TextAlign.start,
              );
            }),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    int aindex = 0;
    int bindex = 0;
    currentALevel = widget.list[0];
    if (widget.initialValue != null) {
      for (var i = 0; i < this.widget.list.length; i++) {
        var a = this.widget.list[i];
        for (var j = 0; j < a.list.length; j++) {
          var b = a.list[j];
          if (widget.initialValue.id == b.id) {
            currentALevel = a;
            aindex = i;
            bindex = j;
            break;
          }
        }
      }
    }
    scrollAController = new FixedExtentScrollController(initialItem: aindex);
    scrollBController = new FixedExtentScrollController(initialItem: bindex);
    this.currentBLevel = this.currentALevel.list[bindex];
  }
}
