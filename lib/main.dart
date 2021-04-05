import 'dart:async';
import 'package:battery/battery.dart';
import 'package:device_info/containers.dart';
import 'package:device_info/stateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:lamp/lamp.dart';
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

  // flashlight related variables
  bool _hasFlashLight = false;
  bool _isFlashOn = false;

  void initFlashLight() async{
    bool hasFlash = await Lamp.hasLamp;
    if(!hasFlash){
      openSnackBar(context, "Device doesn't have Flashlight");
    }
    setState(() {
      _hasFlashLight = hasFlash;
    });
  }

  @override
  void initState(){
    super.initState();
    initFlashLight();
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
          child: Column(
            children: [
              BatteryCard(dataForCard: _batteryLevel.toString(),
                dataSubtitle: _batteryState.toString()),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    TextButton(
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
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
                            ]
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.flash_on_sharp,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _isFlashOn ? await Lamp.turnOn() : await Lamp.turnOff();
                        setState(() {
                          _isFlashOn = !_isFlashOn;
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
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