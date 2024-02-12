import 'package:flutter/material.dart';
import 'package:iron_vpn/data/config.dart';
import 'package:iron_vpn/iron_vpn_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseLink,
    anonKey: supabaseAnonKey,
  );

  runApp(const IronVpnApp());
}

final supabase = Supabase.instance.client;
