import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_service.dart';
import '../auth/login.dart';
import 'editProfile.dart';

class ProfilePopup extends StatelessWidget {
  final String fullName;
  final String username;
  final String email;
  final String memberSince;
  final String profileImageUrl;

  const ProfilePopup({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.memberSince,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF328E6E)),
          ),
          Text(
            '@$username',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: const TextStyle(fontSize: 14, color: Color(0xFF90C67C)),
          ),
          Text(
            'Member since $memberSince',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text("Manage Account"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF328E6E),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Navigate to account settings
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Sign Out", style: TextStyle(color: Colors.red)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red[50],
              ),
              onPressed: () async {
                await AuthService().signOut();  // Your sign out logic
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Reset remember_me on sign out
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
