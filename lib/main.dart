import 'dart:async';

import 'package:battery/battery.dart';
import 'package:device_info/containers.dart';
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
  final Battery _battery = Battery();
  var _batteryLevel;
  BatteryState ? _batteryState;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState(){
    super.initState();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((state) {
      setState(() async{
        _batteryState = state;
        _batteryLevel = await _battery.batteryLevel;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _batteryStateSubscription.cancel();
  }

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
          child: CardForData(dataForCard: 'Battery: ${_batteryLevel}%',),
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