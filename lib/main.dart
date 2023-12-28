import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_lyg_test/ly_splash.dart';

void main() async {
  //add red dead screen error handling
  // ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
  //   body: Center(
  //       child: Container(
  //         width: 50,
  //         height: 50,
  //         child: Image.asset("assets/images/loading.gif", width: 10,),
  //       )
  //   ),
  // );
  runApp(
    MyApp(),
  );
}

//add handling if rejected from using HTTPS
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // HttpOverrides.global = MyHttpOverrides();
    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LYG Product Etalase',
      initialRoute: 'splash',
      builder: EasyLoading.init(),
      home: Splash(),
    );
  }
  //force the app for using portrait mode
  /// blocks rotation; sets orientation to: portrait
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
