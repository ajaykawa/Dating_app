import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tinderapp/Screens/toppicks.dart';
import 'Screens/SplashScreen.dart';
import 'bloc/authbloc/auth_bloc.dart';

List<CameraDescription>? cameras;
late Size mq;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );


  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,]);
  cameras = await availableCameras();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
  ], child: MyApp()));
}



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    void _handleNotification(RemoteMessage message) {
      String title = message.notification?.title ?? '';
      String body = message.notification?.body ?? '';

    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("12");
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,payload: message.data.toString(),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //0channel.description,
                color: Colors.blue,

                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
        flutterLocalNotificationsPlugin.getActiveNotifications();
      }

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("object");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("vvv");

      if (notification != null && android != null) {
        _handleNotification(message);
        // print("object");
        // print("object");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => PushNotificationService(notification.title!,notification.body!),));
        // print("object");

      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}




Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
