// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morphosis_flutter_demo/non_ui/modal/task.dart';
import 'package:morphosis_flutter_demo/ui/screens/home.dart';
import 'package:morphosis_flutter_demo/ui/screens/task.dart';

void main() {
  testWidgets('TaskPage has a title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TaskPage()));
    await tester.pump(Duration.zero);

    final titleFinder = find.byKey(Key('TitleKey'));
    expect(titleFinder, findsOneWidget);
  });
}
