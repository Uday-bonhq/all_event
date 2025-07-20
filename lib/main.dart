import 'package:all_event/core/app_colors.dart';
import 'package:all_event/core/debounser.dart';
import 'package:all_event/features/auth/auth_provider.dart';
import 'package:all_event/features/auth/login_screen.dart';
import 'package:all_event/features/home/view/home_page.dart';
import 'package:all_event/services/firebase_options.dart';
import 'package:all_event/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeNotifications();
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  runApp(const ProviderScope(child: MyApp()));
}


final debouncer = Debouncer(milliseconds: 800);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);


    return ToastificationWrapper(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: primaryColor
          ),
          debugShowCheckedModeBanner: false,
          home: user == null ? HomeScreen() : HomeScreen(),
        ),
      ),
    );
  }
}
