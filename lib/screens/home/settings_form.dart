import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form Values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: users.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update Your Brew Settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please Enter a value' : null,
                    onChanged: (val) => setState(() {
                      _currentName = val;
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //dropdown
                  DropdownButtonFormField(
                    value: _currentSugars ?? userData.sugars,
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar, child: Text('$sugar Sugars'));
                    }).toList(),
                    onChanged: (val) => setState(() {
                      _currentSugars = val;
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //slider
                  Slider(
                      min: 100,
                      max: 900,
                      activeColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_currentStrength ?? userData.strength],
                      divisions: 8,
                      value: (_currentStrength ?? userData.strength).toDouble(),
                      onChanged: (val) => setState(() {
                            _currentStrength = val.round();
                          })),

                  //button
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[400]),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: users.uid).updateUserData(
                              _currentSugars ?? userData.sugars,
                              _currentName ?? userData.name,
                              _currentStrength ?? userData.strength);
                        }
                        Navigator.pop(context);

                        // print(_currentName);
                        // print(_currentStrength);
                        // print(_currentSugars);
                      },
                      child: Text("Update",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
