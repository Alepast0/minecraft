import 'package:flutter/material.dart';

List<Shader> listShader = [
  const LinearGradient(
    colors: [Colors.deepOrangeAccent, Colors.amberAccent],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 200.0)),
  const LinearGradient(
    colors: [Colors.green, Colors.lightGreenAccent],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 200.0)),
  const LinearGradient(
    colors: [Colors.pink, Colors.pinkAccent],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 200.0)),
  const LinearGradient(colors: [Colors.indigo, Colors.blue])
      .createShader(const Rect.fromLTWH(100, 0.0, 200.0, 200)),
  const LinearGradient(colors: [Colors.red, Colors.deepOrangeAccent])
      .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 50.0)),
  const LinearGradient(colors: [Colors.deepPurpleAccent, Colors.purple])
      .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 50.0))
];
