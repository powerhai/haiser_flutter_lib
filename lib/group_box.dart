library haiser_flutter_lib;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


enum HeaderPosition { Top, Left, Right }

class GroupBox extends StatelessWidget {
  final Color backgroundColor;
  final Widget header;
  final Widget content;
  final double padding;
  final HeaderPosition headerPosition;

  final double headerPadding;
  GroupBox(
      {this.header,
      this.content,
      this.headerPosition = HeaderPosition.Top,
      this.padding = 5.0,
      this.backgroundColor = Colors.grey,
      this.headerPadding = 5.0});
  @override
  Widget build(BuildContext context) {
    switch (this.headerPosition) {
      case HeaderPosition.Top:
        return buildTop();
        break;
      case HeaderPosition.Left:
        return buildLeft();
      case HeaderPosition.Right:
        return buildRight();
      default:
        return buildTop();
    }
  }

  Widget buildLeft() {
    Widget hd = Container(
        padding: EdgeInsets.all(headerPadding),
        alignment: Alignment.center,
        child: header,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(padding),
                bottomLeft: Radius.circular(padding))));

    Widget bd = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(padding),
            topRight: Radius.circular(padding),
            bottomLeft: Radius.circular(padding),
          )),
      child: content,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hd,
        Expanded(
          child: bd,
        )
      ],
    );
  }

  Widget buildRight() {
    Widget hd = Container(
        padding: EdgeInsets.all(headerPadding),
        alignment: Alignment.center,
        child: header,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(padding),
                bottomRight: Radius.circular(padding))));
    Widget bd = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(padding),
            topLeft: Radius.circular(padding),
            bottomLeft: Radius.circular(padding),
          )),
      child: content,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: bd,
        ),
        hd
      ],
    );
  }

  Widget buildTop() {
    Widget hd = Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              headerPadding, headerPadding, headerPadding, 0.0),
          child: header,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(padding),
                  topRight: Radius.circular(padding))))
    ]);

    Widget bd = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(padding),
            topRight: Radius.circular(padding),
            bottomLeft: Radius.circular(padding),
          )),
      child: content,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[hd, bd],
    );
  }
}
