import 'package:flutter/material.dart';
import '../../../core/style/app_colors.dart';

// Helper for row input field
Widget rowInput(BuildContext context, String label, Widget child) {
  final double screenWidth = MediaQuery
      .of(context)
      .size
      .width;

  return Padding(
    padding: const EdgeInsets.only(bottom: 13, left: 15, right: 15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.11,
          child: Text(
            label,
            style: TextStyle(fontSize: 20, color: AppColors.secondaryBg),
          ),
        ),
        SizedBox(width: screenWidth * 0.3, child: child),
      ],
    ),
  );
}

Widget imagePickerButton({
  required String text,
  required VoidCallback onPressed,
  required IconData icon, // parameter icon opsional
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(12),
    splashColor: Colors.white.withOpacity(0.2),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}