import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:schoolconnect/constants/Mycolor.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final String? svgAsset;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double height;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.svgAsset,
    this.onPressed,
    this.backgroundColor,
    this.height = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? MyColor.color021034,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(svgAsset.toString()),
            if (svgAsset != null) ...[
              SvgPicture.asset(
                svgAsset!,
                width: 16,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
