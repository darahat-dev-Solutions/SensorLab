import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/onboarding/presentation/widgets/animated_dummy_card_designs.dart';

// Assuming you have a Lab class - replace with your actual Lab import
// class Lab {
//   final String name;
//   final String description;
//   final List<String> sensors;
//   final DateTime? lastUpdated;
//   final int dataPoints;

//   const Lab({
//     required this.name,
//     required this.description,
//     required this.sensors,
//     this.lastUpdated,
//     this.dataPoints = 0,
//   });
// }

Widget customLabCard(
  List<Lab> customs,
  bool isDark,
  ThemeData theme,
  BuildContext context,
) {
  final hasLabs = customs.isNotEmpty;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section Header with Context
      const SizedBox(height: 8),

      // Main Content
      Builder(
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;
          final sectionHeight = hasLabs
              ? screenHeight * 0.3
              : screenHeight * 0.6;
          return SizedBox(
            height: sectionHeight,
            child: hasLabs
                ? _buildLabsList(customs, isDark, theme, context)
                : _buildEmptyState(theme, context),
          );
        },
      ),
    ],
  );
}

Widget _buildLabsList(
  List<Lab> customs,
  bool isDark,
  ThemeData theme,
  BuildContext context,
) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    physics: const BouncingScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
    ),
    itemCount: customs.length,
    itemBuilder: (context, index) {
      final lab = customs[index];
      return _buildLabCard(lab, isDark, theme, context, index, customs);
    },
  );
}

Widget _buildLabCard(
  Lab lab,
  bool isDark,
  ThemeData theme,
  BuildContext context,
  int index,
  List<Lab> customs,
) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 250 + (index * 80)),
    curve: Curves.easeOutCubic,
    margin: EdgeInsets.only(
      left: index == 0 ? 0 : 12,
      right: index == customs.length - 1 ? 20 : 12,
    ),
    child: Material(
      elevation: 6,
      shadowColor: theme.colorScheme.primary.withOpacity(0.4),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          context.pushNamed('lab-details', pathParameters: {'labId': lab.id});
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.95),
                theme.colorScheme.primary.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (no lab icon, no three-dot)

              // Lab Name
              Text(
                lab.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Description (secondary text, smaller font)
              Text(
                lab.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.75),
                  fontSize: 12,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Footer Section (sensor count only, no icon, no arrow)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _getSensorCountText(lab),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildEmptyState(ThemeData theme, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[50],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]!
            : Colors.grey[200]!,
      ),
    ),
    child: Column(
      children: [
        EmptyCustomLabCardIcon(theme: theme),
        const SizedBox(height: 16),
        Text(
          'No Custom Sensor Lab Yet',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your first lab to start experimenting with sensors',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.grey[500]
                : Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ========== HELPER FUNCTIONS ==========

String _getSensorCountText(Lab lab) {
  // Use actual sensor count from your Lab class
  final sensorCount = lab.sensors.length;
  return '$sensorCount ${sensorCount == 1 ? 'sensor' : 'sensors'}';
}

void _showLabOptions(BuildContext context, Lab lab) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      margin: const EdgeInsets.all(20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.open_in_new_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Open Lab'),
                onTap: () {
                  Navigator.pop(context);
                  context.pushNamed('lab-details', extra: lab);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Edit Lab'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit screen
                  // context.pushNamed('edit-lab', extra: lab);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Share Lab'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete Lab',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, lab);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showDeleteConfirmation(BuildContext context, Lab lab) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Lab?'),
      content: Text(
        'Are you sure you want to delete "${lab.name}"? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Implement delete functionality
            // _deleteLab(lab);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
