import 'package:flutter/material.dart';
import 'package:lesson62_final_project_part1/presentation/theme/colors/app_colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    super.key,
    this.controller,
    required this.onSearch,
    required this.onSwitch,
    required this.initialLabelIndex,
  });

  final TextEditingController? controller;
  final Function() onSearch;
  final Function(int?) onSwitch;
  final int initialLabelIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
        ),
        child: Container(
          width: 370,
          height: 155,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderYellow,
            ),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.blackBg,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 2,
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.borderYellow),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderYellow),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderYellow),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller?.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIcon: IconButton(
                      onPressed: onSearch,
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Where would you go?',
                    hintStyle: const TextStyle(
                      color: Color(0xFFD0D0D0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ToggleSwitch(
                animate: true,
                animationDuration: 400,
                activeBgColor: const [AppColors.primaryYellow],
                inactiveBgColor: AppColors.darkBg,
                inactiveFgColor: const Color(0xFFD0D0D0),
                minHeight: 48,
                minWidth: 160,
                initialLabelIndex: initialLabelIndex,
                totalSwitches: 2,
                labels: const [
                  'Transport',
                  'Delivery',
                ],
                onToggle: onSwitch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
