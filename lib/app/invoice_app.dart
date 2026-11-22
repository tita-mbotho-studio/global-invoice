import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Global Invoice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        builder: (context, child) => MaterialUiCompatibilityBridge(
          child: child ?? const SizedBox.shrink(),
        ),
      );
}
