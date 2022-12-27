import 'package:final_noteapp_new/pages/home_page.dart';
import 'package:final_noteapp_new/pages/note_page.dart';
import 'package:final_noteapp_new/pages/search_page.dart';
import 'package:final_noteapp_new/pages/signup_page.dart';
import 'package:final_noteapp_new/providers/auth_provider.dart';
import 'package:final_noteapp_new/providers/note_provider.dart';
import 'package:final_noteapp_new/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:final_noteapp_new/pages/signin_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget isAuthenticated(BuildContext context) {
    if (context.watch<firebaseAuth.User>() != null) {
      return HomePage();
    }
    return SigninPage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<firebaseAuth.User>.value(
          value: firebaseAuth.FirebaseAuth.instance.authStateChanges(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<NoteList>(
          create: (context) => NoteList(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Note',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Builder(
          builder: (context) => isAuthenticated(context),
        ),
        routes: {
          SigninPage.routeName: (context) => SigninPage(),
          SignupPage.routeName: (context) => SignupPage(),
          NotesPage.routeName: (context) => NotesPage(),
        },
      ),
    );
  }
}