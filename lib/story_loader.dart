import 'dart:convert';

import 'package:flutter/services.dart';

class Phrase {
  final String text;
  final int start;
  final int stop;

  Phrase(this.text, this.start, this.stop);
  
  factory Phrase.fromJson(Map<String, dynamic> json) => Phrase(json["text"], json["start"], json["end"]);
}


Future<List<Phrase>> getStoryPhrases() async {

  final String response = await rootBundle.loadString('assets/story1.json');
  final List<dynamic> data = await json.decode(response)["phrases"];
  
  return data.map((e) => Phrase.fromJson(e)).toList();
}