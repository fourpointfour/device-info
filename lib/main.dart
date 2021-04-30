import 'dart:async';
import 'package:battery/battery.dart';
import 'package:device_info/containers.dart';
import 'package:device_info/stateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:lamp/lamp.dart';
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
  String? _batteryState;
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  static const platform = const MethodChannel('com.device_info.app/vaibhav');
  // flashlight related variables
  bool _hasFlashLight = false;
  bool _isFlashOn = false;

  void getBatteryLevel() async{
    _batteryLevel = await _battery.batteryLevel;
  }

  @override
  void initState(){
    super.initState();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((state) {
      setState((){
        _batteryState = (state == BatteryState.charging) ? 'Charging' : 'Discharging';
        getBatteryLevel();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _batteryStateSubscription.cancel();
  }

  Future<void> _toggleTorch(val) async{
    String resultMessage;
    try {
      resultMessage = await platform.invokeMethod('toggleTorch', {'torchValue': val});
    } on PlatformException catch(e) {
      print('Failed to turn on Flashlight. ERROR: ${e.message}');
    }
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
                dataSubtitle: _batteryState),
              SizedBox(height: 10,),
              Container(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 3,
                        blurRadius: 2,
                      ),
                    ]
                  ),
                  child: ElevatedButton(
                    onPressed: () async{
                      await _toggleTorch(!_isFlashOn);
                      _isFlashOn = !_isFlashOn;
                    },
                    child: Icon(
                      Icons.flash_on_sharp,
                      size: 20,
                    ),
                  ),
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