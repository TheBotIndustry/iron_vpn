import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:seeip_client/seeip_client.dart';

class VPNService {
  Future<FlutterV2ray?> connectVPN(String link) async {
    V2RayURL parser = FlutterV2ray.parseFromURL(link);

    final FlutterV2ray flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        print('STATUS: $status');
      },
    );

    await flutterV2ray.initializeV2Ray();

    if (await flutterV2ray.requestPermission()) {
      flutterV2ray.startV2Ray(
        remark: 'IRON VPN',
        config: parser.getFullConfiguration(),
        blockedApps: null,
        bypassSubnets: null,
        proxyOnly: false,
      );
      return flutterV2ray;
    } else {
      return null;
    }
  }

  void disconnectVPN(FlutterV2ray flutterV2ray) {
    flutterV2ray.stopV2Ray();
  }

  String getIp(String link) {
    V2RayURL parser = FlutterV2ray.parseFromURL(link);
    return parser.address;
  }

  Future<String> getPlaceName(String link) async {
    String ipAddress = getIp(link);
    var seeip = SeeipClient();
    var result = await seeip.getGeoIP(ipAddress);
    return '${result.city}, ${result.country}';
  }
}
