import 'package:flutter/material.dart';
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//       theme: ThemeData(primarySwatch: Colors.orange),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // reference the hive box
//   final _myBox = Hive.box('todo_db');
//   ToDoDataBase db = ToDoDataBase();

//   @override
//   void initState() {
//     // if this is the 1st time ever openin the app, then create default data
//     if (_myBox.get("tasklist") == null) {
//       db.createInitialData();
//     } else {
//       // there already exists data
//       db.loadData();
//     }

//     super.initState();
//   }

//   // text controller
//   final _controller = TextEditingController();

//   // checkbox was tapped
//   void checkBoxChanged(bool? value, int index) {
//     setState(() {
//       db.tasklist[index][1] = !db.tasklist[index][1];
//     });
//     db.updateDataBase();
//   }

//   // save new task
//   void saveNewTask() {
//     setState(() {
//       db.tasklist.add([_controller.text, false]);
//       _controller.clear();
//     });
//     Navigator.of(context).pop();
//     db.updateDataBase();
//   }

//   void saveTask(int index) {
//     setState(() {
//       db.tasklist[index][0] = _controller.text;
//       _controller.clear();
//     });
//     Navigator.of(context).pop();
//     db.updateDataBase();
//   }

//   // delete task
//   void deleteTask(int index) {
//     setState(() {
//       db.tasklist.removeAt(index);
//     });
//     db.updateDataBase();
//   }

//   // create a new task
//   void createNewTask() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return DialogBox(
//           controller: _controller,
//           onSave: saveNewTask,
//           onCancel: () => Navigator.of(context).pop(),
//         );
//       },
//     );
//   }

//   void changeTask(int index) {
//     _controller.text = db.tasklist[index][0];
//     // Navigator.of(context).pop();
//     showDialog(
//       context: context,
//       builder: (context) {
//         return DialogBox(
//           controller: _controller,
//           onSave: () => saveTask(index),
//           onCancel: () {
//             Navigator.of(context).pop();
//             _controller.clear();
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (db.tasklist.length > 0) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: Text('TO DO'),
//           // elevation: 0,
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: createNewTask,
//           child: Icon(Icons.add),
//         ),
//         body: Container(
//           child: Column(children: <Widget>[
//             MaterialButton(
//               color: Colors.orange,
//               child: Text("Sort"),
//               onPressed: () {
//                 setState(() {
//                   db.tasklist.sort(
//                       (a, b) => a[1].toString().compareTo(b[1].toString()));
//                 });
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: db.tasklist.length,
//                 itemBuilder: (context, index) {
//                   return MaterialButton(
//                     onPressed: () => changeTask(index),
//                     child: ToDoTile(
//                       taskName: db.tasklist[index][0],
//                       taskCompleted: db.tasklist[index][1],
//                       onChanged: (value) => checkBoxChanged(value, index),
//                       index: index,
//                       deleteFunction: (context) => deleteTask(index),
//                       changetask: (index) => changeTask(index),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ]),
//         ),
//       );
//     } else {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: Text('TO DO'),
//           // elevation: 0,
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: createNewTask,
//           child: Icon(Icons.add),
//         ),
//         body: Center(
//           child: Text(
//             "no task",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       );
//     }
//   }
// }

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

extension DateTimeExt on DateTime {
  DateTime get sftm => DateTime(year, month);
  DateTime get startfromthisday => DateTime(year, month, day);

  DateTime changemonth(int count) {
    return DateTime(year, month + count, day);
  }

  DateTime gotostartmonth(int sftm, int sy) {
    return DateTime(sy, sftm, day);
  }

  bool checkdate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return checkdate(DateTime.now());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime monthselected;

  DateTime? dselected;

  @override
  void initState() {
    monthselected = DateTime.now().sftm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(
                monthselected: monthselected,
                dselected: dselected,
                onChange: (value) => setState(() => monthselected = value),
              ),
              Expanded(
                child: _Body(
                  dselected: dselected,
                  monthselected: monthselected,
                  datechoise: (DateTime value) => setState(() {
                    dselected = value;
                  }),
                ),
              ),
              _Bottom(
                monthselected: monthselected,
                onChange: (value) => setState(() => monthselected = value),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.monthselected,
    required this.dselected,
    required this.datechoise,
  });

  final DateTime monthselected;
  final DateTime? dselected;

  final ValueChanged<DateTime> datechoise;

  @override
  Widget build(BuildContext context) {
    var data = Calendar(
      year: monthselected.year,
      month: monthselected.month,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: Colors.green,
            ),
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      hrb: false,
                      date: d.date,
                      mact: d.mact,
                      onTap: () => datechoise(d.date),
                      isel: dselected != null && dselected!.checkdate(d.date),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.onTap,
    required this.hrb,
    required this.mact,
    required this.isel,
    required this.date,
  });

  final bool hrb;
  final bool mact;
  final VoidCallback onTap;
  final bool isel;

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final int number = date.day;
    final isToday = date.isToday;
    final bool isPassed = date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: isel
            ? const BoxDecoration(color: Colors.pink, shape: BoxShape.circle)
            : isToday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(
                      color: Colors.pink,
                    ),
                  )
                : null,
        child: Text(
          number.toString(),
          style: TextStyle(
              fontSize: 14,
              color: isPassed
                  ? mact
                      ? Colors.grey
                      : Colors.transparent
                  : mact
                      ? Colors.black
                      : Colors.grey[300]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onChange,
    required this.monthselected,
    required this.dselected,
  });

  final DateTime monthselected;
  final DateTime? dselected;

  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Column(
        children: [
          Text(
            'Select date: ${dselected == null ? 'non' : "${dselected!.day}.${dselected!.month}.${dselected!.year}"}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Month: ${monthselected.month}/ Year: ${monthselected.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  onChange(monthselected.changemonth(-1));
                },
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              IconButton(
                onPressed: () {
                  onChange(monthselected.changemonth(1));
                },
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({
    required this.monthselected,
    required this.onChange,
  });

  final DateTime monthselected;
  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            onChange(monthselected.gotostartmonth(
                DateTime.now().month, DateTime.now().year));
          },
          child: const Text('to start month'),
        ),
      ],
    );
  }
}

class Calendar {
  final int year;
  final int month;

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);
  int get firstDayOfWeekIndex => 0;

  int get weeksCount => ((daysInMonth + firstDayOffset) / 7).ceil();

  const Calendar({
    required this.year,
    required this.month,
  });

  int get firstDayOffset {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    return (weekdayFromMonday - ((firstDayOfWeekIndex - 1) % 7)) % 7 - 1;
  }

  List<List<CalDay>> get weeks {
    final res = <List<CalDay>>[];
    var firstDayMonth = DateTime(year, month, 1);
    var firstDayOfWeek = firstDayMonth.subtract(Duration(days: firstDayOffset));

    for (var w = 0; w < weeksCount; w++) {
      final week = List<CalDay>.generate(
        7,
        (index) {
          final date = firstDayOfWeek.add(Duration(days: index));

          final mact = date.year == year && date.month == month;

          return CalDay(
            date: date,
            mact: mact,
            isActiveDate: date.isToday,
          );
        },
      );
      res.add(week);
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    }
    return res;
  }
}

class CalDay {
  final bool isActiveDate;
  final bool mact;

  final DateTime date;

  const CalDay({
    required this.date,
    required this.mact,
    required this.isActiveDate,
  });
}
