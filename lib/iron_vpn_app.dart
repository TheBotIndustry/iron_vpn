import 'package:flutter/material.dart';
import 'package:iron_vpn/routes/routes.dart';
import 'package:iron_vpn/theme/theme.dart';

class IronVpnApp extends StatelessWidget {
  const IronVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iron VPN',
      routes: routes,
      initialRoute: '/login',
      theme: mainTheme,
    );
  }
}
