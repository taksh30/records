import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:records/boxes.dart';
import 'package:records/database/records.dart';
import 'package:records/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // register the adapter
  Hive.registerAdapter(RecordsAdapter());

  // open the box
  myBox = await Hive.openBox<Records>('records');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Records',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
