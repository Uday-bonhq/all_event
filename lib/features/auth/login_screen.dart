import 'package:all_event/core/common_export.dart';
import 'package:all_event/features/auth/auth_provider.dart';
import 'package:all_event/features/home/view/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    ref.listen(authProvider, (previous, nextUser) {
      if (nextUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, Color(0xFF2575FC), Color(0xFF6A11CB)],
          ),
        ),
        child: Center(
          child: authState == null
              ? _buildSignInUI(context, authNotifier)
              : _buildUserInfoUI(context, authState, authNotifier),
        ),
      ),
    );
  }

  Widget _buildSignInUI(BuildContext context, AuthNotifier authNotifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: AnimatedColumn(
        milliseconds: 500,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetIcon.appLogo, height: 80),
          const SizedBox(height: 40),
          const Text(
            "Live. Don't Just Exist.",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Discover the Most happening events around you",
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signing in...')),
                );
                await authNotifier.signInWithGoogle();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: SvgPicture.asset(AssetIcon.googleIcon, height: 28),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "By Signing In, I agree to AllEvents's ",
              style: const TextStyle(color: Colors.white, fontSize: 15),
              children: [
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookTicketScreen(
                            bookingUrl: 'https://allevents.in/privacy',
                          ),
                        ),
                      );
                    },
                ),
                const TextSpan(text: " and ", style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: "Terms of Service",
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookTicketScreen(
                            bookingUrl: 'https://allevents.in/conditions',
                          ),
                        ),
                      );
                    },
                ),
                const TextSpan(text: ".", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Version : 1.0.22",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoUI(BuildContext context, User user, AuthNotifier authNotifier) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: const [
                BoxShadow(blurRadius: 15, color: Colors.black45, offset: Offset(0, 8)),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
              radius: 60,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Welcome, ${user.displayName ?? 'User'}!",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 8.0, color: Colors.black38, offset: Offset(1.0, 1.0))],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            user.email ?? 'No email provided',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF2575FC)),
              label: const Text(
                "Go to Dashboard",
                style: TextStyle(fontSize: 19, color: Color(0xFF2575FC), fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signing out...')),
                );
                await authNotifier.signOut();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Sign Out",
                style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
