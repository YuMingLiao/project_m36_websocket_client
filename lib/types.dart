import 'dart:convert';
import 'dart:core';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.freezed.dart';

void main() {
  var jsonStr = '''{"promptInfo":{"schemaname":"main","headname":"master"}}''';
  Map<String, dynamic> json = jsonDecode(jsonStr);
  json.forEach((key, value) => print('${key}: ${value}'));

  var promptInfo = PromptInfo('main', 'master');
  print(promptInfo.schemaname);
  print(promptInfo.headname); 
}

@freezed
class PromptInfo with _$PromptInfo {
  factory PromptInfo(String schemaname, String headname) = _PromptInfo;
}
