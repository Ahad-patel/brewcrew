import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text('Brew Crew'),
          elevation: 0.0,
          actions: [
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: Text(
                  'Settings',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/coffee_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BrewList(),
        ),
      ),
    );
  }
}
