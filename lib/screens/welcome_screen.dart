import 'package:flutter/material.dart';
import 'package:ccd2022app/screens/login_screen.dart';
import 'package:ccd2022app/utils/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = "welcome_screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to CCD 2022',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontFamily: 'Poppins'),
            ),
            const Hero(
              tag: "logo",
              child: Image(
                image: AssetImage('assets/images/Logo.png'),
              ),
            ),
            SizedBox(
              width: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                backgroundColor: kScaffoldLightBg,
                elevation: 0,
                child: const Icon(Icons.arrow_forward),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
