import 'dart:async';
import 'package:battery/battery.dart';
import 'package:device_info/circularButton.dart';
import 'package:device_info/containers.dart';
import 'package:device_info/stateNotifier.dart';
import 'package:flashlight/flashlight.dart';
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

  // flashlight related variables
  bool _hasFlashLight = false;
  bool _isFlashOn = false;

  void initFlashLight() async{
    bool hasFlash = await Flashlight.hasFlashlight;
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
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(
                            Icons.flash_on_sharp,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _isFlashOn ? await Flashlight.lightOff() : await Flashlight.lightOn();
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