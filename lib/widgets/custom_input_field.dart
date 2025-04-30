import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? optionalIcon;
  final VoidCallback? onOptionalIconTap;
  final TextInputType keyboardType;
  final Color focusColor;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.optionalIcon,
    this.onOptionalIconTap,
    this.keyboardType = TextInputType.text,
    this.focusColor = const Color(0xFF328E6E),
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _isFocused ? 4.0 : 0.0,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.grey.withOpacity(0.5),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          suffixIcon: _isFocused && widget.optionalIcon != null
              ? InkWell(
            onTap: widget.onOptionalIconTap,
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              widget.optionalIcon,
              color: Colors.grey[600],
            ),
          )
              : null,
          enabledBorder: _buildBorder(Colors.grey),
          focusedBorder: _buildBorder(widget.focusColor, width: 1.5),
          border: _buildBorder(Colors.grey),
          floatingLabelStyle: TextStyle(color: widget.focusColor),
        ),
      ),
    );
  }
}