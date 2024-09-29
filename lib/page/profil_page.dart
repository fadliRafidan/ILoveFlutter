import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/color.dart';
import 'package:flutter_application_1/page/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
                child: FutureBuilder<User?>(
                  future: getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('User not found.');
                    } else {
                      final user = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: user.userMetadata?['picture'] !=
                                    null
                                ? NetworkImage(user.userMetadata?['picture'])
                                : AssetImage('assets/images/pro.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            user.userMetadata?['full_name'] ?? 'No User',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            user.email ?? 'No Email',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                foregroundColor: green),
                            child: const Text('Edit profile'),
                          ),
                        ],
                      );
                    }
                  },
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
              onTap: () async {
                await supabase.auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> getUserInfo() async {
    final response = await supabase.auth.getUser();
    return response.user;
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
