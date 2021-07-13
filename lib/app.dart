import 'package:flutter/material.dart';

import 'screens/details_screen.dart';
import 'screens/list_screen.dart';
import 'screens/new_entry_screen.dart';

class App extends StatelessWidget {

  static final routes = {
    ListScreen.routeName: (context) => ListScreen(),
    DetailsScreen.routeName: (context) => DetailsScreen(),
    NewEntryScreen.routeName: (context) => NewEntryScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      routes: routes,
    );
  }
}
