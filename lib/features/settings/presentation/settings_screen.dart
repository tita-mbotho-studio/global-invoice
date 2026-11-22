import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/ui/screen_frame.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => ScreenFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 22),
            const Card(child: ListTile(
              leading: Icon(Icons.public_outlined),
              title: Text('International settings'),
              subtitle: Text('Localization and taxes are scheduled for later milestones.'),
            )),
            const Card(child: ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text('Privacy first'),
              subtitle: Text('Drafts are stored locally without requiring an account.'),
            )),
          ],
        ),
      );
}
