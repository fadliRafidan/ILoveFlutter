import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'page/splash_page.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://uwhujyhibqeresplhgmb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3aHVqeWhpYnFlcmVzcGxoZ21iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1NDAzMzgsImV4cCI6MjA0MzExNjMzOH0.wM4QECt2pHc6UoD2KzlKZtJj0ZcdEwKHNF3C_GF6sMk',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Gilroy',
      ),
      home: const SafeArea(
        child: SplashPage(),
      ),
    );
  }
}
