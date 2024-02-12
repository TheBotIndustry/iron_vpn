import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:iron_vpn/data/vpn_links.dart';
import 'package:iron_vpn/extensions/list_extensions.dart';
import 'package:iron_vpn/services/vpn_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String placeName = 'Не подключен';
  late FlutterV2ray? flutterV2ray;

  bool isConnected = false;

  void connect() async {
    if (isConnected == true) {
      VPNService().disconnectVPN(flutterV2ray!);
      placeName = 'Не подключен';
      isConnected = false;
    } else {
      String link = vpnList.randomItem();
      flutterV2ray = await VPNService().connectVPN(link);
      if (flutterV2ray != null) {
        isConnected = true;
        setState(() {});
        placeName = await VPNService().getPlaceName(link);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    List<String> dateList = (args['subTerm'] as String).split('-');

    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF18324c),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const RowIcons(),
                  SizedBox(height: sHeight * 0.1),
                  Text(
                    'Подписка активна до\n${dateList[2]}.${dateList[1]}.${dateList[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sHeight * 0.05),
                  Text(
                    (isConnected == false) ? '' : 'Connected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: sHeight * 0.05),
                  GestureDetector(
                    onTap: () => connect(),
                    child: Image.asset(
                      (isConnected == false)
                          ? 'assets/images/circle_off.png'
                          : 'assets/images/circle_on.png',
                      height: sHeight * 0.3,
                      width: sWidth * 0.5,
                    ),
                  ),
                  SizedBox(height: sHeight * 0.12),
                  LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: sWidth * 0.65,
                      height: sHeight * 0.08,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF43df06),
                          width: 5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.rocket_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(width: constraints.maxWidth * 0.01),
                          Text(
                            placeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowIcons extends StatelessWidget {
  const RowIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/planet.png',
            height: 40,
            width: 40,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 60,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white.withOpacity(0.3),
            ),
            height: 40,
            width: 120,
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    color: Color(0xFF43df06),
                  ),
                  Text(
                    'Premium',
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
          Container(
            margin: const EdgeInsets.only(
              left: 40,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white.withOpacity(0.3),
            ),
            height: 40,
            width: 40,
            child: const Center(
              child: Icon(
                Icons.settings,
                color: Color(0xFF43df06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 40;

    Path path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * 0.4, size.height / 4 * 3 - radius / 2)
      ..lineTo(0, size.height)
      ..moveTo(size.width, size.height / 4 * 3.5)
      ..lineTo(0, size.height / 3)
      ..lineTo(size.width / 3 * 2, 0)
      ..lineTo(size.width, size.height / 5.3)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
