import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: [
        Person('Craiu Andrew', '2', ConfirmStatus.Confirmed),
        Person('Sami Andrusca', '2', ConfirmStatus.Invited)
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<Person> items;

  const MyApp({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Wedding App';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
            // Let the ListView know how many items it needs to build.
            itemCount: items.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                leading: item.chooseIcon(context),
                title: item.buildTitle(context),
                subtitle: item.buildSubtitle(context),
                iconColor: item.chooseIconColor(context),
              );
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum ConfirmStatus { Confirmed, Invited, NotComing }

/// A ListItem that contains data to display a message.
class Person {
  final String name;
  final String numberOfPeople;
  final ConfirmStatus confirmStatus;

  Person(this.name, this.numberOfPeople, this.confirmStatus);

  Widget chooseIcon(BuildContext context) {
    IconData iconData;

    switch (confirmStatus) {
      case ConfirmStatus.Confirmed:
        iconData = Icons.face_retouching_natural;
        break;

      case ConfirmStatus.Invited:
        iconData = Icons.face;
        break;

      case ConfirmStatus.NotComing:
        iconData = Icons.face_retouching_off;
        break;
    }

    return Icon(iconData);
  }

  Color chooseIconColor(BuildContext context) {
    Color color;

    switch (confirmStatus) {
      case ConfirmStatus.Confirmed:
        color = Colors.green;
        break;

      case ConfirmStatus.Invited:
        color = Colors.blueAccent;
        break;

      case ConfirmStatus.NotComing:
        color = Colors.red;
        break;
    }

    return color;
  }

  Widget buildTitle(BuildContext context) => Text(name);

  Widget buildSubtitle(BuildContext context) => Text(numberOfPeople);
}
