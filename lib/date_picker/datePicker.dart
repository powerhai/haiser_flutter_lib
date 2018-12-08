import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class DatePicker extends StatefulWidget {
  DatePicker(
      {Key key,
      DateTime startDate,
      DateTime endDate,
      DateTime date,
      this.onChanged})
      : super(key: key) {
    if (date != null) this.currentDate = date;
    this.startDate = startDate == null ? new DateTime(1960, 1, 1) : startDate;
    this.endDate = endDate == null ? new DateTime.now() : endDate;
  }

  final ValueChanged<DateTime> onChanged;
  DateTime startDate;
  DateTime endDate;
  DateTime currentDate = new DateTime.now();
  @override
  DatePickerState createState() => new DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  List<int> years;
  List<int> months;
  List<int> days;
  // DateTime currentDate;
  FixedExtentScrollController scrollYearController;
  FixedExtentScrollController scrollMonthController;
  FixedExtentScrollController scrollDayController;

  void makeList() {
    makeYears();
    makeMonths();
    makeDays();
  }

  void makeYears() {
    var start = widget.startDate.year;
    var end = widget.endDate.year;
    var list = new List<int>();
    for (var i = start; i <= end; i++) {
      list.add(i);
    }
    years = list;
  }

  void makeMonths() {
    var list = new List<int>();
    for (var i = 1; i <= 12; i++) {
      list.add(i);
    }
    months = list;
  }

  void makeDays() {
    var d1 = new DateTime(widget.currentDate.year, widget.currentDate.month, 1);
    var d2 = widget.currentDate.month == 12
        ? new DateTime(widget.currentDate.year + 1, 1, 1)
        : new DateTime(
            widget.currentDate.year, widget.currentDate.month + 1, 1);
    var def = d2.difference(d1);
    var daycount = def.inDays;
    var list = new List<int>();
    for (var i = 1; i <= daycount; i++) {
      list.add(i);
    }
    this.setState(() {
      days = list;
      print(list.length.toString());
    });
  }

  void resetList() {
    var d1 = new DateTime(this.years[this.scrollYearController.selectedItem],
        this.months[this.scrollMonthController.selectedItem], 1);
    var d2 = d1.month == 12
        ? new DateTime(d1.year + 1, 1, 1)
        : new DateTime(d1.year, d1.month + 1, 1);
    var def = d2.difference(d1);
    var daycount = def.inDays;
    var list = new List<int>();
    for (var i = 1; i <= daycount; i++) {
      list.add(i);
    }
    this.setState(() {
      days = list;
      print(list.length.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    makeList();
    var yearIndex = 0;
    var monthIndex = 0;
    var dayIndex = 0;
    for (var i = 0; i < this.years.length; i++) {
      if (this.years[i] == this.widget.currentDate.year) {
        yearIndex = i;
      }
    }
    for (var i = 0; i < this.months.length; i++) {
      if (this.months[i] == this.widget.currentDate.month) {
        monthIndex = i;
      }
    }
    for (var i = 0; i < this.days.length; i++) {
      if (this.days[i] == this.widget.currentDate.day) {
        dayIndex = i;
      }
    }
    print(
        'yearindex: ${yearIndex} ${monthIndex} ${dayIndex} ${this.widget.currentDate}');
    scrollDayController =
        new FixedExtentScrollController(initialItem: dayIndex);
    scrollMonthController =
        new FixedExtentScrollController(initialItem: monthIndex);
    scrollYearController =
        new FixedExtentScrollController(initialItem: yearIndex);
    
  }

  @override
  Widget build(BuildContext context) {
    return popupWidget();
  }

  Widget popupWidget() {
    var col1 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[wgYears(), wgMonths(), wgDays()],
    );
    var col2 = 
    
    Padding(  
        padding: const EdgeInsets.all(10.0),
        child: Row(  mainAxisSize:  MainAxisSize.min,
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
                  Navigator.pop<DateTime>(context, widget.currentDate);
                })
          ],
        ));

    return new Dialog(
        child: Container( color: Colors.grey, child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[col1, col2])));
  }

  DateTime getSelectDate() {
    var dt = new DateTime(
        this.years[this.scrollYearController.selectedItem],
        this.months[this.scrollMonthController.selectedItem],
        this.days[this.scrollDayController.selectedItem]);
    return dt;
  }

  Widget wgMonths() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: 200.0,
          decoration: BoxDecoration(
              border: Border(top: BorderSide()), color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: this.scrollMonthController,
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              resetList();
              var nd = getSelectDate();
              widget.currentDate = nd;
              this.widget.onChanged(nd);
            },
            children: List<Widget>.generate(this.months.length, (int index) {
              return Text(
                this.months[index].toString(),
                style: TextStyle(color: Color(0xFF000046), fontSize: 20.0),
                textAlign: TextAlign.start,
              );
            }),
          )),
    );
  }

  Widget wgDays() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: 200.0,
          decoration: BoxDecoration(
              border: Border(top: BorderSide()), color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: this.scrollDayController,
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              var nd = getSelectDate();
              widget.currentDate = nd;
              this.widget.onChanged(nd);
            },
            children: List<Widget>.generate(this.days.length, (int index) {
              return Text(
                this.days[index].toString(),
                style: TextStyle(color: Color(0xFF000046), fontSize: 20.0),
                textAlign: TextAlign.start,
              );
            }),
          )),
    );
  }

  Widget wgYears() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: 200.0,
          decoration: BoxDecoration( 
              border: Border(top: BorderSide()), color: Colors.white),
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            scrollController: this.scrollYearController,
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              var nd = getSelectDate();
              widget.currentDate = nd;
              resetList();
              this.widget.onChanged(nd);
            },
            children: List<Widget>.generate(this.years.length, (int index) {
              return Text(
                this.years[index].toString(),
                style: TextStyle(color: Color(0xFF000046), fontSize: 20.0),
                textAlign: TextAlign.start,
              );
            }),
          )),
    );
  }
}
