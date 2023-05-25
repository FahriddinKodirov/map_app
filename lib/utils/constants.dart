import 'package:flutter/material.dart';

const String mapApiKey = 'af92acc5-e07e-4b23-9505-c25539370ea0';

const List<String> kindList = [
  "house",
  "metro",
  "district",
  "street",
];

height(context) => MediaQuery.of(context).size.height;
width(context) => MediaQuery.of(context).size.width;


InputDecoration getInputDecorationTwo({required String label}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        width: 1,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black)),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black)),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black)),
  );
}