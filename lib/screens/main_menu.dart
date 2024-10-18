import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memo_pattern/screens/game_screen.dart';
import 'package:memo_pattern/screens/login_screen.dart';
import 'package:memo_pattern/screens/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late SharedPreferences prefs;
  String username = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  void _getUsername() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      if (kDebugMode) {
        print('Username: ${prefs.getString('username')}');
      }
      isLoading = false;
    });
  }

  void _logout() async {
    try {
      prefs.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      if (kDebugMode) {
        print('Berhasil keluar!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Hi, $username'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 20,
                        child: Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(16.0),
                          child: Text(
                            'Memo Pattern',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      Card(
                        elevation: 20,
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(16.0),
                          child: Text(
                            'Instruksi:\nGame ini melatih kemampuan ingatan. Klik blok untuk menampilkan pola yang telah ditunjukkan dengan benar.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GameScreen(),
                            ),
                          ),
                          child: const Text('Mulai Permainan'),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onPressed: _logout,
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
