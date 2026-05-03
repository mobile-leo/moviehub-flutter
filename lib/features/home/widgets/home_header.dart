import 'package:flutter/material.dart';
import '../../../core/providers/home_provider.dart';
import '../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final HomeTab selectedTab;
  final void Function(HomeTab) onTabChanged;

  const HomeHeader({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _TabItem(
                label: 'Séries',
                selected: selectedTab == HomeTab.series,
                onTap: () => onTabChanged(HomeTab.series),
              ),
              const SizedBox(width: 20),
              _TabItem(
                label: 'Filmes',
                selected: selectedTab == HomeTab.movies,
                onTap: () => onTabChanged(HomeTab.movies),
              ),
              const SizedBox(width: 20),
              _TabItem(
                label: 'Minha Lista',
                selected: selectedTab == HomeTab.myList,
                onTap: () => onTabChanged(HomeTab.myList),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 15,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
