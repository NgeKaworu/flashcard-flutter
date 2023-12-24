/*
 * @Date: 2023-12-24 16:23:02
 * @LastEditors: NgeKaworu NgeKaworu@163.com
 * @LastEditTime: 2023-12-24 16:23:47
 * @FilePath: \flashcard-flutter\lib\src\widget\loding_elevated_button.dart
 */
import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatefulWidget {
  final Function? onPressed;
  final Widget child;
  final ButtonStyle? style; // Add this lin

  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<LoadingElevatedButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingElevatedButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: _isLoading
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await widget.onPressed?.call();
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 1))
          : widget.child,
    );
  }
}
