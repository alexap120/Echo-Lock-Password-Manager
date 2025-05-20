import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginDetailsBottomSheet extends StatefulWidget {
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
  _LoginDetailsBottomSheetState createState() => _LoginDetailsBottomSheetState();
}

class _LoginDetailsBottomSheetState extends State<LoginDetailsBottomSheet> {
  bool _isPasswordVisible = false;
  bool _isEditing = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _serviceNameController;

  // Keep additional fields but not editable, no add or delete
  List<Map<String, TextEditingController>> _additionalFields = [];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _serviceNameController = TextEditingController(text: widget.serviceName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _serviceNameController.dispose();
    for (var field in _additionalFields) {
      field['key']!.dispose();
      field['value']!.dispose();
    }
    super.dispose();
  }

  void _save() {
    // Add validation and saving logic here if needed
    setState(() {
      _isEditing = false;
    });
  }

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
                  Expanded(
                    child: _isEditing
                        ? TextFormField(
                      controller: _serviceNameController,
                      decoration: InputDecoration(
                        labelText: "Service Name",
                      ),
                    )
                        : Text(
                      widget.serviceName,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildEditableRow("Login", _emailController),
              const SizedBox(height: 20),
              _buildEditablePasswordRow("Password", _passwordController),
              const SizedBox(height: 30),

              // Show additional fields but no edit/delete/add
              ..._additionalFields.map((field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field['key']!.text,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(field['value']!.text),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              if (widget.sharedWith.isNotEmpty && !_isEditing) ...[
                Text("Shared To",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                  widget.sharedWith.map((name) => Chip(label: Text(name))).toList(),
                ),
                const SizedBox(height: 30),
              ],
              if (widget.isPasswordWeak && !_isEditing)
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
                  backgroundColor: Color(0xFF328E6E),
                ),
                icon: Icon(_isEditing ? Icons.save : Icons.edit,
                    color: Colors.white),
                label: Text(
                  _isEditing ? "Save Vault Item" : "Edit Vault Item",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_isEditing) {
                    _save();
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditableRow(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        _isEditing
            ? TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: controller.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title copied to clipboard')),
                );
              },
            ),
          ),
        )
            : Row(
          children: [
            Expanded(
              child: Text(
                controller.text,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: controller.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditablePasswordRow(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        _isEditing
            ? TextFormField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$title copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ),
        )
            : Row(
          children: [
            Expanded(
              child: Text(
                _isPasswordVisible ? controller.text : "••••••••",
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: controller.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
