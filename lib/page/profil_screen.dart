import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300.0,
              padding: const EdgeInsets.only(top: 50),
              color: lightGreen,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/pro.png'),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Coffeestories',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'mark.brock@icloud.com',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(foregroundColor: green),
                      child: const Text('Edit profile'),
                    ),
                  ],
                ),
              ),
            ),
            _buildListTile(
              icon: Icons.home,
              title: 'My stores',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.help,
              title: 'Support',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.logout,
              title: 'Logout',
              textColor: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
