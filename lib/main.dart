import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rich_text_demo/story_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int seconds = 0;
  late Future<List<Phrase>> phrasesFuture = getStoryPhrases();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds = seconds + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: phrasesFuture,
        builder: (context, AsyncSnapshot phrases) {
          if (phrases.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TimeDisplay(seconds: seconds),
                TextDisplay(seconds: seconds, phrases: phrases.data),
              ],
            );
          } else if (phrases.hasError) {
            return Center(child: Text('$phrases.error'));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class TextDisplay extends StatelessWidget {
  const TextDisplay({Key? key, required this.seconds, required this.phrases})
      : super(key: key);

  final int seconds;
  final List<Phrase> phrases;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: _getTextSpans(phrases),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _getTextSpans(List<Phrase> phrases) {
    return phrases.map((e) => TextSpan(
          text: e.text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            backgroundColor: _getBackgroundColor(e.start, e.stop),
          ),
        )).toList();
  }

  Color _getBackgroundColor(int start, int end) {
    if (seconds >= start && seconds < end) {
      return Colors.yellow;
    }
    return Colors.white;
  }
}

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({Key? key, required this.seconds}) : super(key: key);

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final int minutes = seconds ~/ 60;
    final remainder = (seconds % 60).toString().padLeft(2, '0');
    return Text(
      '$minutes:$remainder',
      style: const TextStyle(fontSize: 30),
    );
  }
}
