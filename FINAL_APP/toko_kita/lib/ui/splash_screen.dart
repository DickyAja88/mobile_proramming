import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const SplashScreen({super.key, required this.onSplashComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 5), () {
      widget.onSplashComplete();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/shop_big.png')),
            const SizedBox(height: 5),
            Text(
              'Toko kita',
              style: GoogleFonts.playfairDisplay(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Welcome',
                style: GoogleFonts.pacifico(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
