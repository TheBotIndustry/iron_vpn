import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:iron_vpn/data/vpn_links.dart';
import 'package:iron_vpn/extensions/list_extensions.dart';
import 'package:iron_vpn/main.dart';
import 'package:iron_vpn/services/snack_bar.dart';
import 'package:iron_vpn/services/vpn_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  late FlutterV2ray? flutterV2ray;

  void checkUser(String userID) async {
    isLoading = true;
    setState(() {});
    final users = await supabase.from('users').select().eq('user_id', userID);
    isLoading = false;
    setState(() {});
    if (users.isEmpty) {
      SnackBarService.showSnackBar(
          context, 'Telegram ID не найден или у вас нет подписки', true);
    } else {
      if (users.first['paid'] == true) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pushReplacementNamed(
            '/home',
            arguments: {
              'subTerm': users.first['sub_term'],
            },
          );
        });
      } else {
        SnackBarService.showSnackBar(
            context, 'Telegram ID не найден или у вас нет подписки', true);
      }
    }
  }

  void onStart() async {
    // final users = await supabase.from('users').select().eq('paid', true);
    // print(users);
    String link = vpnList.randomItem();
    flutterV2ray = await VPNService().connectVPN(link);
  }

  @override
  void initState() {
    super.initState();
    onStart();
  }

  final TextEditingController telegramController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      width: double.infinity,
                      height: sHeight * 0.4,
                      color: const Color(0xFF18324c),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: sHeight * 0.05,
                  ),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Servers from',
                          style: TextStyle(
                            color: Color(0xFF43df06),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Russia, Premium',
                          style: TextStyle(
                            color: Color(0xFF43df06),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    (flutterV2ray != null) ? flutterV2ray.toString() : 'ERROr',
                    style: const TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: sHeight * 0.01),
                const Text(
                  'Введите Telegram ID',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: sHeight * 0.2,
                  ),
                  width: sWidth * 0.8,
                  height: sHeight * 0.08,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF43df06),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(builder: (context, constrains) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: constrains.maxWidth * 0.02,
                        right: constrains.maxWidth * 0.02,
                      ),
                      child: Center(
                        child: TextField(
                          controller: telegramController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Color(0xFF43df06),
                          ),
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Telegram ID',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF939393),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () {
                    String tgID = telegramController.text.trim();
                    if (tgID == '') {
                      SnackBarService.showSnackBar(
                          context, 'Вы не ввели Telegram ID', true);
                    } else {
                      if (double.tryParse(tgID) != null) {
                        checkUser(telegramController.text.trim());
                      } else {
                        SnackBarService.showSnackBar(
                            context, 'Ошибка ввода Telegram ID', true);
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: sHeight * 0.03,
                    ),
                    width: sWidth * 0.8,
                    height: sHeight * 0.08,
                    decoration: const BoxDecoration(
                      color: Color(0xFF43df06),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : const Text(
                              'Войти',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint = Offset(size.width / 2, size.height / 2);
    var endPoint = Offset(size.width, size.height - 50);

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
