import 'package:blog_firebase_remoteconfig/user_entity.dart';
import 'package:blog_firebase_remoteconfig/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

const String remote_user_data_key = 'user_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class DataValueNotifier extends ValueNotifier<UserEntity?> {
  DataValueNotifier() : super(null);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Remote Config',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Remote Config'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final RemoteConfig remoteConfig = RemoteConfig.instance;
  final dataNotifier = DataValueNotifier();
  final util = Util();

  @override
  void initState() {
    super.initState();
    () async {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: dataNotifier,
        builder: (context, UserEntity? value, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ${value?.name}'),
                Text('Age: ${value?.age}'),
                Text('Address: ${value?.address}'),
                Text('Email: ${value?.email}'),
                Text('Job: ${value?.job}'),
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _syncData(),
        tooltip: 'Sync',
        child: Icon(Icons.sync),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _syncData() async {
    showLoading(context);
    try {
      await remoteConfig.fetchAndActivate();
      final rs = remoteConfig.getString(remote_user_data_key);
      dataNotifier.value = await util.parseJsonConfig(rs);
      Navigator.pop(context); // hide loading
    } catch (e) {
      print(e);
    }
  }

  void showLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8.0),
              Text('Loading...')
            ],
          ),
        );
      },
    );
  }
}
