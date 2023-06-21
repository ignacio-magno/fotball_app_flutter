// call http endpoint
import 'package:http/http.dart' as http;

class HttpCall {
  Future<http.Response> Call() async {
    var uri = Uri.parse("https://pokeapi.co/api/v2/pokemon/ditto");
    var response = await http.get(uri);

    return response;
  }
}

class Pico {
  String _name;
  int? _age = 0;
  Pico(this._name, this._age);
}
