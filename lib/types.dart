import 'dart:convert';
import 'dart:core';

void main() {
  var json = '''{"promptInfo":{"schemaname":"main","headname":"master"}}''';
  Map<String, dynamic> user = jsonDecode(json);
  user.forEach((key, value) => print('${key}: ${value}'));
}
