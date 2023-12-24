import 'package:flutter/material.dart';

class LoadingTextButton extends StatefulWidget {
  final Function? onPressed;
  final Widget child;
  final ButtonStyle? style; // Add this lin

  const LoadingTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<LoadingTextButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingTextButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
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
