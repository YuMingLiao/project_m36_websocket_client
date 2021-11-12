import 'dart:io';
import 'dart:convert';
import 'package:functional_data/functional_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pretty_json/pretty_json.dart';
part 'relation.g.dart';
part 'relation.freezed.dart';


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

class DisplayError implements Item{
  final String command;
  final String error;

  DisplayError(this.command, this.error);

  DisplayError.fromJson(this.command, Map<String, dynamic> json): error = json['json'];

  Map<String, dynamic> toJson() => {
        'displayerror': {'json': error}
      };

  @override
  Widget buildItem() => Text(error);
}

//for debugging
class DisplayJson implements Item{
  final String command;
  final Map<String,dynamic> json;

  DisplayJson(this.command, this.json);

  DisplayJson.fromJson(this.command, Map<String, dynamic> json): json = json;

  Map<String, dynamic> toJson() => json;

  @override
  Widget buildItem() => SelectableText(prettyJson(json, indent: 2));
}

@FunctionalData()
class DisplayRelation extends $DisplayRelation implements Item{
  final String command;
  final List<Attribute> attributes;
  final List<Tuple> asList;
  DisplayRelation(this.command, this.attributes, this.asList);
  DisplayRelation.fromJson(this.command, Map<String, dynamic> _json):
    attributes = List<Attribute>.from((_json['json'][0]['attributes']).map((e) => Attribute.fromJson(e)).toList()),
    asList = List<Tuple>.from(_json['json'][1]['asList'].map((e) => Tuple.fromJson(e)).toList());

  Map<String, dynamic> toJson() => {
        'displayrelation': {
          'json': [ { 'attributes' : attributes.map((e) => e.toJson) }, 
                    { 'asList' : asList.map((tuple) => [tuple.attributes.map((e)=>e.toJson),tuple.atoms.map((e)=>e.toJson)]) },
                  ]
        }
      };

  @override
  Widget buildItem() => DataTable(
      columns: (attributes.length == 0) 
               ? [DataColumn(label: Text(''))]
               : attributes.map((e)=> DataColumn(label: Text('${e.name}::${e.type.atomType.name}'))).toList(),
      rows: (attributes.length == 0 && asList.length == 1) 
            ? [DataRow(cells:[DataCell(Text(''))])]
            : asList.map((e)=>DataRow(cells: e.atoms.map((e)=>DataCell(Text(e.toString()))).toList())).toList(),
    );
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
  final AtomType atomType;
  AttributeType(this.atomType);
  AttributeType.fromJson(Map<String, dynamic> json)
      : atomType = AtomType.fromJson(json);
  Map<String, dynamic> toJson() => {
        'tag' : atomType.toString(), //fix is needed here
      };
  @override
  String toString() => '${atomType.toString()}';
  String get name => atomType.maybeWhen(
      constructedAtomType: (tConsName, tvMap) => tConsName + ' ' + tvMap.entries.fold("",(i,j)=> i + (j.value.toString())),
      orElse: () => atomType.toString().replaceAll('AtomType.','').replaceAll('AtomType()','').toCapitalized(),
  );
}

@FunctionalData()
class Atom extends $Atom{
  final AttributeType attrType;
  final dynamic val;
  Atom(this.attrType,this.val);
  Atom.fromJson(Map<String, dynamic> json)
      : attrType = AttributeType.fromJson(json['type']),
        val  = (json['type']['tag'] != 'ConstructedAtomType')
             ? json ['val']
             : ConstructedAtom.fromJson(json);
  Map<String, dynamic> toJson() => {
        'type' : attrType.toJson,
        'val'  : val,
      };
  @override
  String toString() =>
    attrType.atomType.when(
      intAtomType: () => '${val.toString()}',
      integerAtomType: () => '${val.toString()}',
      doubleAtomType: () => '${val.toString()}',
      textAtomType: () => '\"${val}\"',
      boolAtomType: () => '${val.toString()}',
      constructedAtomType: (tConsName, tvMap) => '${val.toString()}');
}

class ConstructedAtom {
  final String dataConstructorName;
  final List<Atom> atomList;
  final AtomType atomType;
  ConstructedAtom.fromJson(Map<String, dynamic> json)
      : dataConstructorName = json['dataconstructorname'],
        atomList  = json['atomlist'].map((e)=>Atom.fromJson(e)).toList().cast<Atom>(),
        atomType = AtomType.fromJson(json['type']);

  @override
  String toString() => '${dataConstructorName}' + atomList.fold('', (prev, element)=>prev + ' ' + (element.toString().contains(' ') ? '(' + element.toString() + ')' : element.toString()));
}

class Item {
  final String command = "";
  Widget buildItem(){
    return Offstage(offstage: true, child:Text('undefined'),);
  }
}

//MAYBE TODO: replace boilerplate with biMap
@freezed
class AtomType with _$AtomType {
  const AtomType._(); 
  const factory AtomType.intAtomType() = IntAtomType;
  const factory AtomType.integerAtomType() = IntegerAtomType;
  const factory AtomType.doubleAtomType() = DoubleAtomType;
  const factory AtomType.textAtomType() = TextAtomType;
  const factory AtomType.boolAtomType() = BoolAtomType;
  const factory AtomType.constructedAtomType(String typeConstructorName, Map<String,AtomType> typeVarMap) = ConstructedAtomType; //contents is a b c in A, B a, C a b, D a b c
//                DayAtomType |
//                DateTimeAtomType |
//                ByteStringAtomType |
//                RelationAtomType Attributes |
//                ConstructedAtomType TypeConstructorName TypeVarMap |
//                RelationalExprAtomType |
//                TypeVariableType TypeVarName

  static AtomType fromJson(Map<String,dynamic> json){
    if(json['tag']=="IntAtomType"){ return AtomType.intAtomType(); }
    else if(json['tag']=="IntegerAtomType"){ return AtomType.integerAtomType(); }
    else if(json['tag']=="DoubleAtomType"){ return AtomType.doubleAtomType(); }
    else if(json['tag']=="TextAtomType"){ return AtomType.textAtomType(); }
    else if(json['tag']=="BoolAtomType"){ return AtomType.boolAtomType(); }
    else if(json['tag']=="ConstructedAtomType"){
      String tConsName = json['contents'][0]; /* TypeVarMap */
      Map<String,AtomType> tvMap = json['contents'][1].map((k,v)=>MapEntry(k,AtomType.fromJson(v))).cast<String,AtomType>();
      return AtomType.constructedAtomType(tConsName, tvMap); } 
    else { throw UnimplementedError(json.toString()); } 
  }
  String get name => this.maybeWhen(
      constructedAtomType: (tConsName, tvMap) => tConsName + ' ' + tvMap.entries.fold("",(i,j)=> i + (j.value.name)),
      orElse: () => this.toString().replaceAll('AtomType.','').replaceAll('AtomType()','').toCapitalized(),
  );

}  

extension StringCasingExtension on String {
  String toCapitalized() => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
}


// ConstructedAtom DataConstructorName AtomType [Atom]
// ConstructedAtomType TypeConstructorName TypeVarMap
/*
String constructedAtomTypeJson = '''
{
  "displayrelation": {
    "json": [
      {
        "attributes": [
          {
            "name": "field",
            "type": {
              "tag": "ConstructedAtomType",
              "contents": [
                "A",
                {}
              ]
         }
          }
        ]
      },
      {
        "asList": [
          [
            {
              "attributes": [
                {
                  "name": "field",
                  "type": {
                    "tag": "ConstructedAtomType",
                    "contents": [
                      "A",
                      {}
                    ]
                  }
                }
              ]
            },
            [
              {
                "dataconstructorname": "B",
                "atomlist": [],
                "type": {
                  "tag": "ConstructedAtomType",
                  "contents": [
                    "A",
                    {}
                  ]
                }
              }
            ]
           },
            [
              {
                "dataconstructorname": "B",
                "atomlist": [],
                "type": {
                  "tag": "ConstructedAtomType",
                  "contents": [
                    "A",
                    {}
                  ]
                }
              }
            ]
          ]
        ]
      }
    ]
  }
}
'''
*/
