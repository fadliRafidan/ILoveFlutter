import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? _userId;

  Future<void> _onGoogleSignIn() async {
    const webClientId =
        '938462646069-pg436g6633kf074sssanq96ov8q8rs4f.apps.googleusercontent.com';

    /// iOS Client ID yang Anda daftarkan di Google Cloud.
    const iosClientId =
        '938462646069-8o1ucmg6lpmnt1cls6pkbn13ac9129jn.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    // Google sign in
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Sign-In Canceled';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      final response = await supabase.auth.signInWithIdToken(
          idToken: idToken,
          accessToken: accessToken,
          provider: OAuthProvider.google);
      setState(() {
        _userId = response.user?.id;
      });

      // Arahkan pengguna ke halaman BottomNavBar jika login berhasil
      if (_userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => const BottomNavBar(),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
      if (data.session?.user.id != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => const BottomNavBar(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 25),
          const Text(
            'Let\'s plant with us',
            style: TextStyle(
              fontSize: 22.0,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Bring nature home',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 450,
            width: 450,
            child: Image.asset('assets/images/Asset1.png'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                return _onGoogleSignIn();
              }
              await supabase.auth.signInWithOAuth((OAuthProvider.google));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF4285F4), // Warna latar belakang biru Google
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 20.0), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Sudut membulat
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/google_icon.png', // Ganti dengan path ke ikon Google Anda
                  height: 24.0, // Ukuran ikon
                  width: 24.0,
                ),
                const SizedBox(width: 10), // Spasi antara ikon dan teks
                const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Warna teks putih
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
