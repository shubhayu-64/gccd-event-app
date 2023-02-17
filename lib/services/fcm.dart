import 'package:ccdeventapp/blocs/nav_bloc.dart';
import 'package:ccdeventapp/utils/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Fcm {
  final NavigationBloc nb;

  Fcm({required this.nb});

  Future<void> setupInteractedMessage() async {
    /// Get any messages which caused the application to open from
    /// a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    /// Handle any interaction when the app is in the background via a
    /// Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey(Config.fcmArgRedirect)) {
      launchUrlString(
        message.data[Config.fcmArgRedirect],
        mode: LaunchMode.externalApplication,
      );
    } else if (message.data.containsKey(Config.fcmArgScreen)) {
      int navIndex = nb.screenNames.keys.firstWhere(
        (k) => nb.screenNames[k] == message.data[Config.fcmArgScreen],
        orElse: () => -1,
      );

      if (navIndex != -1) {
        nb.changeNavIndex(navIndex);
      }
    }
  }
}
