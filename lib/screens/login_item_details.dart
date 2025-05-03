import 'package:flutter/material.dart';

class LoginDetailsBottomSheet extends StatelessWidget {
  final String serviceName;
  final String email;
  final String password;
  final List<String> sharedWith;
  final bool isPasswordWeak;

  const LoginDetailsBottomSheet({
    Key? key,
    required this.serviceName,
    required this.email,
    required this.password,
    this.sharedWith = const [],
    this.isPasswordWeak = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.lock_outline, color: Colors.green[800]),
                  ),
                  SizedBox(width: 10),
                  Text(
                    serviceName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildInfoRow("Login", email),
              const SizedBox(height: 20),
              _buildInfoRow("Password", "••••••••"),
              const SizedBox(height: 30),
              if (sharedWith.isNotEmpty) ...[
                Text("Shared To", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: sharedWith
                      .map((name) => Chip(label: Text(name)))
                      .toList(),
                ),
                const SizedBox(height: 30),
              ],
              if (isPasswordWeak)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Vulnerability Alert\nThis password is weak",
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.edit),
                label: Text("Edit Vault Item"),
                onPressed: () {
                  // Handle edit
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.copy, size: 18),
          ],
        ),
      ],
    );
  }
}
