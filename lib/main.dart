import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppConstants.accentPurple,
        scaffoldBackgroundColor: AppConstants.darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.darkCardBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppConstants.darkText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppConstants.darkAccent,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppConstants.darkBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppConstants.darkBorder),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppConstants.darkText),
          bodyMedium: TextStyle(color: AppConstants.darkText),
          titleLarge: TextStyle(color: AppConstants.darkText),
          titleMedium: TextStyle(color: AppConstants.darkText),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
