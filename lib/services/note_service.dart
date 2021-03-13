import 'dart:convert';

import 'package:rest_api/models/api_response.dart';
import 'package:rest_api/models/note.dart';
import 'package:rest_api/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/models/note_insert.dart';

class NotesService {
  static const headers = {
    'apiKey': 'a9329920-b582-4cd1-aa90-b2ac1449fd4d',
    'Content-Type': 'application/json'
  };
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';

  // fetch All
  Future<APIResponse<List<NoteForListing>>> getNoteList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured'));
  }

  // fetch One
  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }

  //Post
  Future<APIResponse<bool>> CreateNote(NoteInsert item) {
    return http
        .post(API + '/notes',
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  //Editing

  Future<APIResponse<bool>> UpdateNote(String noteID , NoteInsert item) {
    return http
        .put(API + '/notes/'+noteID,
        headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }


  //Delete

  Future<APIResponse<bool>> DeleteNote(String noteID) {
    return http
        .delete(API + '/notes/'+noteID,
        headers: headers)
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }



}
