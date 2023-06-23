import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fotball_app_flutter/provider/cam.dart';

main() {
  test("test", () async {
    var f = F();
    await Future.delayed(const Duration(seconds: 5));

    assert(f.Name == "Name");
  });

  test("description", () {
    var j = """
      [{"name":"gato"}, {"name":"perro"}]
      """;

    List<dynamic> data = jsonDecode(j);
    var elemtns = data.map((e) => Identifier(name: e["name"]!)).toList();

    assert(elemtns[0].name == "gato");
  });
}

class F {
  String? Name;

  F() {
    GetName().then((value) => {Name = value});
  }

  Future<String> GetName() async {
    // sleep 4 seconds
    await Future.delayed(const Duration(seconds: 4));

    return "Name";
  }
}
