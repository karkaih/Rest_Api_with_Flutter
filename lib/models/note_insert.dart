import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_insert.g.dart';
@JsonSerializable()
class NoteInsert {
  String noteTitle;
  String noteContent;

  NoteInsert({@required this.noteTitle, @required this.noteContent});

  Map<String, dynamic> toJson() => _$NoteInsertToJson(this);
  // {
  //   return {"noteTitle": this.noteTitle, "noteContent": this.noteContent};
  // }
}
