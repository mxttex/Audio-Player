import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(const ListenAudio());
}

class ListenAudio extends StatelessWidget {
  const ListenAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green, brightness: Brightness.dark)),
        home: const ListenerHomepage());
  }
}

class ListenerHomepage extends StatefulWidget {
  const ListenerHomepage({super.key});

  @override
  State<ListenerHomepage> createState() => _ListenerHomepageState();
}

class _ListenerHomepageState extends State<ListenerHomepage> {
  FilePickerResult? result; 
  AudioPlayer audioPlayer = AudioPlayer();
  double playRate=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Listener', style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
        
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
          child: Column(
        children: [
          Image.network(
              "https://static.vecteezy.com/system/resources/previews/023/986/631/original/whatsapp-logo-whatsapp-logo-transparent-whatsapp-icon-transparent-free-free-png.png",
              height: 300),
          result == null ? const Text("scegli un vocale") : Text(result!.files.single.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: playAudio, icon: const Icon(Icons.play_arrow)),
              TextButton(onPressed: playbackRate, child: Text('x$playRate')),
            ],
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: const Icon(Icons.audio_file),
      ),
    );
  }

  void pickFile() async {
    result = await FilePicker.platform.pickFiles();
    setState(() {
      
    });
  }

  void playAudio() {
    if(result != null){
      audioPlayer.play(DeviceFileSource(result!.files.single.path!));
    }
  }
  void playbackRate() {
    playRate = playRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playRate);
    setState(() {
      
    });
  }
}
