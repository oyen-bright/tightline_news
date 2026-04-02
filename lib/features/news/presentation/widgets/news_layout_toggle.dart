import 'package:flutter/material.dart';
import 'package:tightline_news/core/utils/responsive_size.dart';

class NewsLayoutToggle extends StatelessWidget {
  const NewsLayoutToggle({
    super.key,
    required this.isGrid,
    required this.onListSelected,
    required this.onGridSelected,
  });

  final bool isGrid;
  final VoidCallback onListSelected;
  final VoidCallback onGridSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      padding: EdgeInsets.all(context.r(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.view_list_rounded,
            isSelected: !isGrid,
            onTap: onListSelected,
          ),
          SizedBox(width: context.w(4)),
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            isSelected: isGrid,
            onTap: onGridSelected,
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.r(8)),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.surface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.r(8)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: context.r(4),
                    offset: Offset(0, context.r(1)),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: context.r(20),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade500,
        ),
      ),
    );
  }
}
