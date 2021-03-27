import 'package:device_info/stateNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myTheme.dart';

void main()
{
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child){
        return MaterialApp(
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: appState.currentTheme(),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            Switch(
              value: Provider.of<AppStateNotifier>(context).isDark,
              onChanged: (darkMode){
                Provider.of<AppStateNotifier>(context, listen: false).updateTheme(darkMode);
                openSnackBar(context, 'Theme changed!');
              },
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 10, right: 10),
            padding: EdgeInsets.all(10),
            height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 3,
                  blurRadius: 2,
                ),
                BoxShadow(
                  offset: Offset(-2, -2),
                  color: Colors.white,
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => openSnackBar(context, 'Card tapped!'),
              child: Card(
                elevation: 0,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  'Hey, this is a card...',
                  style: Theme.of(context).textTheme.headline6,
                ),
          ),
            ),
          ),
        ),
      ),
    );
  }
}

void openSnackBar(context, changeMessage)
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(changeMessage),
      behavior: SnackBarBehavior.floating,
    )
  );
}