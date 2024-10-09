import 'package:flutter/material.dart';

void main() {
  runApp(const ListenAudio());
}

class ListenAudio extends StatelessWidget {
  const ListenAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange,
        brightness: Brightness.dark
        )
      ),
      home: ListenerHomepage());
  }
}

class ListenerHomepage extends StatefulWidget {
  const ListenerHomepage({super.key});

  @override
  State<ListenerHomepage> createState() => _ListenerHomepageState();
}

class _ListenerHomepageState extends State<ListenerHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Listener'),
      ),
    );
  }
}
