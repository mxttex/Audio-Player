import 'dart:io';
import 'package:flutter/foundation.dart';
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
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    aggiornaPosizione();
  }

  void aggiornaPosizione(){
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });
  }

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
              IconButton(
                  onPressed: playAudio, icon: const Icon(Icons.play_arrow)),
              IconButton(onPressed: pauseAudio, icon: const Icon(Icons.pause)),
              IconButton(onPressed: stopAudio, icon: const Icon(Icons.stop)),
              TextButton(onPressed: playbackRate, child: Text('x$playRate')),
            ],
          ),
          slider() //--> questa parte dalla documentazione non l'ho capita, sarebbe da spiegare
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
  }

  void playAudio() {
    if (result != null) {
      audioPlayer.play(DeviceFileSource(result!.files.single.path!));
      audioPlayer.onDurationChanged.listen((Duration d) {
        setState(() {
          _duration = d;
        });
      });
    } else {
      showNoFileExpecption();
    }
  }

  void pauseAudio() {
    if (result != null) {
      audioPlayer.pause();
    } else {
      showNoFileExpecption();
    }
  }

  void stopAudio() {
    if (result != null) {
      audioPlayer.stop();
    } else {
      showNoFileExpecption();
    }
  }

  void playbackRate() {
    playRate = playRate == 1 ? 2 : 1;
    audioPlayer.setPlaybackRate(playRate);
    //setState(() {});
  }

  Widget slider() {
    return Slider(
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          //_position = Duration(seconds: value.toInt());
          audioPlayer.seek(_position);
        });
      },
    );
  }

  void showNoFileExpecption() {
    setState(() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Errore',
        text: "Non hai selezionato nessun file!",
      );
    });
  }
}
