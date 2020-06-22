import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'email_verification_api_call.dart';
import 'domain_search_api_call.dart';
import 'email_finder_api_call.dart';
import 'local_db.dart';
import 'secrets.dart'; // doesn't exist in your copygit branc

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<EmailVerification> futureEmailVerification;
  Future<Database> db;

  @override
  void initState() {
    super.initState();
    futureEmailVerification = fetchVerif("marcin.lawnik@polsl.pl",apiKey);
    var dh = DBHelper();
    dh.init();
    

    void dbTesting() async {
      final ea = EmailAddress(value:"one@testing.com");
      final ea2 = EmailAddress(value:"two@testing.com");
      final ea3 = EmailAddress(id: 3, value:"third@testing.com");
      final ea3dup = EmailAddress(id: 3, value:"occupied@id.com");
      dh.addEmailAddress(ea);
      dh.addEmailAddress(ea2);
      dh.addEmailAddress(ea3);
      dh.addEmailAddress(ea3dup);

      final list = await dh.emails();
      list.forEach((element) {print(element);});

      final fetched = await dh.fetchEmailAddress(3);
      print("fetched" + fetched.toString());

      dh.updateEmailAddress(EmailAddress(id:2, value:"two@_UPDATED.com"));
      dh.fetchEmailAddress(2).then((value) => print("updated 2nd: " + value.toString()));

      dh.removeEmailAddress(1);
      print("removed first email address");
      final afterRemoval = await dh.emails();
      afterRemoval.forEach((element) {print(element);});
    }


    dbTesting(); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Fetch',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Fetch'),
        ),
        body: Center(
          child: FutureBuilder<EmailVerification>(
            future: futureEmailVerification,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data.data.email}, ${snapshot.data.data.result}, ${snapshot.data.data.score}');
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
          
        ),
      ),
    );
  }
}
