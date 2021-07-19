import 'package:flutter/material.dart';

class GraphCoordinate {
  GraphCoordinate({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close
  });
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;


  factory GraphCoordinate.fromJson(List<dynamic> json) {
    return GraphCoordinate(

        time: (DateTime.fromMillisecondsSinceEpoch(json[0])),
        open:json[1],
        high: json[2],
        low: json[3],
        close: json[4],

    );
  }
}

List<GraphCoordinate> coordinates = [];