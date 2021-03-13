import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/note_for_listing.dart';
import 'package:rest_api/services/note_service.dart';
import 'package:rest_api/views/note_delete.dart';
import 'package:rest_api/views/note_modify.dart';
import 'package:rest_api/models/api_response.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  APIResponse<List<NoteForListing>> _apiResponse;

  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetcheNotes();
    super.initState();
  }

  _fetcheNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNoteList();
    print(_apiResponse.data[0].noteID);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List of Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (builder) => NoteModify()))
                .then((value) {
              _fetcheNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage),
              );
            }
            return ListView.separated(
              separatorBuilder: (_, __) => Divider(
                height: 3,
                color: Colors.green,
              ),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context,
                        builder: (_) => NoteDelete());
                    if (result) {
                      final deleteResult = await service.DeleteNote(
                          _apiResponse.data[index].noteID);
                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = "the note was deleted Succefully";
                      } else {
                        message =
                            deleteResult?.errorMessage ?? 'An error Occured';
                      }
                   showDialog(context: context, builder: (_) =>AlertDialog(
                     title: Text("Done"),
                     content: Text(message),
                     actions: [
                       FlatButton(onPressed: (){
                         Navigator.pop(context);
                       }, child: Text("Ok"))
                     ],
                   ));
                      return deleteResult?.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (builder) => NoteModify(
                                    noteId: _apiResponse.data[index].noteID,
                                  )))
                          .then((value) {
                        _fetcheNotes();
                      });
                    },
                    title: Text(
                      _apiResponse.data[index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        "Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)}"),
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}
