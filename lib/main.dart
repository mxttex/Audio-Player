import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quickalert/quickalert.dart';

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
  double playRate = 1;
  bool playing = false;
  Icon icon = const Icon(Icons.play_arrow);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Listener',
            style: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic,
                color: Colors.white)),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
          child: Column(
        children: [
          Image.network(
              "https://static.vecteezy.com/system/resources/previews/023/986/631/original/whatsapp-logo-whatsapp-logo-transparent-whatsapp-icon-transparent-free-free-png.png",
              height: 300),
          result == null
              ? const Text("Scegli un vocale")
              : Text(result!.files.single.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: playAudio, icon: icon),
              // alert che si attiva tramite bottone
              IconButton(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Errore',
                      text: "Il file selezionato non è un video",
                    );
                  },
                  icon: const Icon(Icons.error)),
              TextButton(onPressed: playbackRate, child: Text('x$playRate')),
            ],
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: const Icon(Icons.audio_file),
      ),
    );
  }

  void pickFile() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        initialDirectory:
            "Memoria/Android/media/com.whatsapp/WhatsApp/Media/Whatsapp Voice Notes");
    if (result != null && result!.files.single.name.endsWith('.opus')) {
      // Mostra l'avviso se il file non è del tipo giusto
      setState(() {});
    } else {
      setState(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Errore',
          text: "Il file selezionato non è un audio di whatsapp",
        );
        result = null;
      });
    }
    setState(() {});
  }

  void playAudio() {
    if (result != null && !playing) {
      audioPlayer.play(DeviceFileSource(result!.files.single.path!));
      setState(() {
        icon = const Icon(Icons.pause);
        playing = true;
      });
    } else {
      audioPlayer.pause();
      setState(() {
        icon = const Icon(Icons.play_arrow);
        playing = false;
      });
    }
  }

  void playbackRate() {
    playRate = playRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playRate);
    setState(() {});
  }
}
