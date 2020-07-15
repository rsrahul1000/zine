import 'package:flutter/material.dart';
import 'package:zine/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.black,
        dialogBackgroundColor: Colors.black,
        primarySwatch: Colors.grey,
        accentColor: Colors.black,
      ),
      home: HomeWrapper(),
    );
  }
}
//flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
