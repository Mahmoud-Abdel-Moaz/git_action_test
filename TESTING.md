
1. Unit Testing:
 Flutter supports unit testing using the built-in test package. Unit tests are used to test individual functions, methods, or classes in isolation.

* Example:
Let's say you have a simple utility function that adds two numbers:

int addNumbers(int a, int b) {
return a + b;
}

* You can create a corresponding unit test for this function:

import 'package:test/test.dart';
import 'package:your_project_name/your_utils.dart'; // Replace with your actual import path

void main() {
test('adds two numbers', () {
expect(addNumbers(2, 3), 5);
expect(addNumbers(-1, 1), 0);
// Add more test cases as needed
});
}

* To run the tests, use the following command in the terminal:
  flutter test


2. Widget Testing:
   Widget testing in Flutter allows you to test the UI components of your application. You can interact with widgets and verify that they behave as expected.

* Example:
  Suppose you have a simple counter app with a button to increment the counter:

import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
@override
_CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
int counter = 0;

void incrementCounter() {
setState(() {
counter++;
});
}

@override
Widget build(BuildContext context) {
return MaterialApp(
home: Scaffold(
appBar: AppBar(
title: Text('Counter App'),
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
Text('Counter: $counter'),
ElevatedButton(
onPressed: incrementCounter,
child: Text('Increment'),
),
],
),
),
),
);
}
}

* You can create a widget test for this app:

import 'package:flutter_test/flutter_test.dart';
import 'package:your_project_name/main.dart'; // Replace with your actual import path

void main() {
testWidgets('counter increments', (WidgetTester tester) async {
// Build our app and trigger a frame.
await tester.pumpWidget(CounterApp());

    // Verify that the counter starts at 0.
    expect(find.text('Counter: 0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the counter increments by 1.
    expect(find.text('Counter: 1'), findsOneWidget);
});
}

* Run the widget tests using:

flutter test


3. Integration Testing:
   Integration tests in Flutter allow you to test the entire application or specific parts of it. You can interact with the app as a user would and validate its behavior.





