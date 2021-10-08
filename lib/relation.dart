import 'dart:io';
import 'dart:convert';
import 'package:functional_data/functional_data.dart';
part 'relation.g.dart';


class PromptInfo {
  final String schemaName;
  final String headName;

  PromptInfo(this.schemaName, this.headName);

  PromptInfo.fromJson(Map<String, dynamic> json)
      : schemaName = json['schemaname'],
        headName = json['headname'];

  Map<String, dynamic> toJson() => {
        'promptInfo': {
          'schemaname': schemaName,
          'headname': headName,
        }
      };
}

class DisplayError {
  final String error;

  DisplayError(this.error);

  DisplayError.fromJson(Map<String, dynamic> json) : error = json['json'];

  Map<String, dynamic> toJson() => {
        'displayerror': {'json': error}
      };
}

@FunctionalData()
class DisplayRelation extends $DisplayRelation{
  final List<Attribute> attributes;
  final List<Tuple> asList;
  DisplayRelation(this.attributes, this.asList);

  DisplayRelation.fromJson(Map<String, dynamic> _json)
      : attributes = List<Attribute>.from((_json['json'][0]['attributes']).map((e) => Attribute.fromJson(e)).toList()),
        asList = List<Tuple>.from(_json['json'][1]['asList'].map((e) => Tuple.fromJson(e)).toList());

  Map<String, dynamic> toJson() => {
        'displayrelation': {
          'json': [ { 'attributes' : attributes.map((e) => e.toJson) }, 
                    { 'asList' : asList.map((tuple) => [tuple.attributes.map((e)=>e.toJson),tuple.atoms.map((e)=>e.toJson)]) },
                  ]
        }
      };

}
@FunctionalData()
class Tuple extends $Tuple{
  final List<Attribute> attributes;
  final List<Atom> atoms;
  Tuple(this.attributes, this.atoms);
  Tuple.fromJson(List<dynamic> json)
      : attributes = List<Attribute>.from(json[0]['attributes'].map((e)=>Attribute.fromJson(e)).toList()),
        atoms = List<Atom>.from(json[1].map((e)=>Atom.fromJson(e)).toList());
}

@FunctionalData()
class Attribute extends $Attribute{
  final String name;
  final AttributeType type;
  Attribute(this.name, this.type);
  Attribute.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = AttributeType.fromJson(json['type']);
  Map<String, dynamic> toJson() => {
        'name' : name,
        'type' : type.toJson(), 
      };
}
@FunctionalData()
class AttributeType extends $AttributeType {
  final String tag;
  AttributeType(this.tag);
  AttributeType.fromJson(Map<String, dynamic> json)
      : tag = json['tag'];
  Map<String, dynamic> toJson() => {
        'tag' : tag,
      };
}

@FunctionalData()
class Atom extends $Atom{
  final AttributeType type;
  final String val;
  Atom(this.type,this.val);
  Atom.fromJson(Map<String, dynamic> json)
      : type = AttributeType.fromJson(json['type']),
        val  = json ['val'];
  Map<String, dynamic> toJson() => {
        'type' : type.toJson,
        'val'  : val,
      };
}
