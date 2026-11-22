import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/ui/screen_frame.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) => ScreenFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clients', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            const Card(child: ListTile(
              leading: Icon(Icons.people_outline),
              title: Text('Customer management'),
              subtitle: Text('Planned for a later milestone; no customer data is stored here yet.'),
            )),
          ],
        ),
      );
}
