
import 'dart:convert';
void main(){
  String str = '''["a"]''';
  var json = jsonDecode(str);
  print(json.where((e) => e.runtimeType == String).toList().cast<String>());
}
