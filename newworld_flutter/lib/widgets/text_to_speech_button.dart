import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechButton extends StatefulWidget {
  final String text;

  const TextToSpeechButton({super.key, required this.text});

  @override
  _TextToSpeechButtonState createState() => _TextToSpeechButtonState();
}

class _TextToSpeechButtonState extends State<TextToSpeechButton> {
  late String text;

  final FlutterTts flutterTts = FlutterTts();
  
  @override
  void initState() {
    super.initState();
    text = widget.text;
    initializeTTS();
  }

  void initializeTTS() {
    flutterTts.setStartHandler(() {
      print("The text is now being spoken.");
      setState(() {});
    });
    flutterTts.setCompletionHandler(() {
      print("Text-to-speech process completed.");
      setState(() {});
    });
    flutterTts.setErrorHandler((msg) {
      print("An error occurred in text-to-speech: $msg");
      setState(() {});
    });
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => speak(text),
      child: const Text('Ecouter la description'),
    );
  }
}
