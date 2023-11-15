import 'package:flutter/material.dart';
import 'package:lesson62_final_project_part1/presentation/theme/colors/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryYellow,
      ),
      child: const Text('Create order'),
    );
  }
}
