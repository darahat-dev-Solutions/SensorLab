// lib/src/features/home/presentation/widgets/category_pills.dart
import 'package:flutter/material.dart';

typedef OnCategorySelected = void Function(int index);

class CategoryPills extends StatelessWidget {
  final bool isDark;
  final List<String> categories;
  final int selectedIndex;
  final OnCategorySelected onSelected;

  const CategoryPills({
    super.key,
    required this.isDark,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? 'All' : categories[index - 1];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                            : [
                                const Color(0xFF667EEA),
                                const Color(0xFF764BA2),
                              ],
                      )
                    : null,
                color: isSelected
                    ? null
                    : isDark
                    ? const Color(0xFF1E2139)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              (isDark
                                      ? const Color(0xFF6366F1)
                                      : const Color(0xFF667EEA))
                                  .withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isAll)
                    Icon(
                      Icons.category,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF1A1F36),
                    ),
                  if (isAll) const SizedBox(width: 8),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF1A1F36),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
