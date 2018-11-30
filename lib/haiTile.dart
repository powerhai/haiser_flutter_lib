import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HaiTile extends StatelessWidget {
  Widget title;
  Widget leading;
  Widget subtitle;
  Widget trailing;
  Decoration decoration;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry contentPadding;
  HaiTile(
      {Key key,
      this.title,
      this.leading,
      this.subtitle,
      this.trailing,
      this.margin = const EdgeInsets.all(0.0),
      this.decoration = const BoxDecoration(  border: Border(bottom: BorderSide( color: Colors.grey)) ),
      this.contentPadding = const EdgeInsets.all(30.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var row = Row(
      children: <Widget>[],
    );
    if (leading != null) {
      row.children.add(leading);
      row.children.add(const SizedBox(
        width: 10.0,
      ));
    }
    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[],
    );
    if (title != null) {
      col.children.add(title);
    }
    if (subtitle != null) {
      col.children.add(subtitle);
    }
    row.children.add(IntrinsicWidth(
      child: col,
    ));

    if (trailing != null) {
      row.children.add(const SizedBox(
        width: 10.0,
      ));
      row.children.add(trailing);
    }

    return Container(
      decoration: decoration,
      padding: EdgeInsets.all(10.0),
      margin: margin,
      child: IntrinsicHeight(
        child: row,
      ),
    );
  }
}
