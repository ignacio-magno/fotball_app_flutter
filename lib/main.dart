import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fotball_app_flutter/provider/cam.dart';
import 'package:fotball_app_flutter/provider/mqtt_provider.dart';
import 'package:mqtt_client/mqtt_client.dart';

class View extends StatelessWidget {
  List<Identifier> elements;

  View({super.key, required this.elements});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (b, i) => Container(
        padding: const EdgeInsets.all(20),
        child: Text(elements[i].name),
      ),
      separatorBuilder: (b, i) => const Divider(),
      itemCount: elements.length,
    );
  }
}

class Elements extends StatelessWidget {
  const Elements({super.key});

  @override
  Widget build(BuildContext context) {
    print("printing");
    return StreamBuilder(
      stream: getElements(),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: View(elements: snapshot.data ?? []),
        );
      },
    );
  }

  Stream<List<Identifier>> getElements() async* {
    print("invoked");
    var k = await Do();

    print("done");

    var l = k.map((event) {
      final recMess = event[0].payload as MqttPublishMessage;
      final p =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      List<dynamic> data = jsonDecode(p);
      var elemtns = data.map((e) => Identifier(name: e["name"]!)).toList();
      print(elemtns);
      return elemtns;
    });

    yield* l;
  }
}

void main() {
  runApp(MaterialApp(
    title: "Sensor Cámara Inteligente",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Cámara Inteligente"),
      ),
      body: const Elements(),
    ),
  ));
}
