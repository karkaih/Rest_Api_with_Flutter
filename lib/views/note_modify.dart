import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/note.dart';
import 'package:rest_api/models/note_insert.dart';
import 'package:rest_api/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final String noteId;

  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;

  NotesService get notesService => GetIt.I<NotesService>();
  TextEditingController textEditingController = new TextEditingController();

  TextEditingController textEditingController1 = new TextEditingController();

  bool isLoading = false;

  String errorMessage;

  Note note;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        isLoading = true;
      });
      notesService.getNote(widget.noteId).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value.error) {
          errorMessage = value.errorMessage ?? 'An error occured';
        }
        note = value.data;
        print("Note title is " + note.noteTitle);
        print(" Note Content is " + note.noteContent);

        textEditingController.text = note.noteTitle;
        textEditingController1.text = note.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Update Note" : "Create Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(height: 8),
            TextField(
              controller: textEditingController1,
              decoration: InputDecoration(hintText: 'Note content'),
            ),
            Container(height: 16),
            SizedBox(
              width: double.infinity,
              height: 35,
              // ignore: deprecated_member_use
              child: RaisedButton(
                child:
                Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme
                    .of(context)
                    .primaryColor,
                onPressed: () async {
                  if (isEditing) {
                    //Update Note in Api
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteInsert(
                        noteTitle: textEditingController.text,
                        noteContent: textEditingController1.text);
                    final result = await notesService.UpdateNote(
                        widget.noteId, note);
                    setState(() {
                      isLoading = false;
                    });
                    final title = "Done";
                    final text = result.error
                        ? (result.errorMessage ?? "An error occured")
                        : "Your Note was Updated";
                    showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                // ignore: deprecated_member_use
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            )).then((value) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    // Create Note in Api
                    setState(() {
                      isLoading = true;
                    });
                    final note = NoteInsert(
                        noteTitle: textEditingController.text,
                        noteContent: textEditingController1.text);
                    final result = await notesService.CreateNote(note);
                    setState(() {
                      isLoading = false;
                    });
                    final title = "Done";
                    final text = result.error
                        ? (result.errorMessage ?? "An error occured")
                        : "Your Note was created";
                    showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: [
                                // ignore: deprecated_member_use
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            )).then((value) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
