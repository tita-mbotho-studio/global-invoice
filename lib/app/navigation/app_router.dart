import 'package:go_router/go_router.dart';
import '../../features/clients/presentation/clients_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/invoices/presentation/invoices_screen.dart';
import '../../features/invoices/presentation/new_invoice_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_shell.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/invoices', builder: (_, __) => const InvoicesScreen()),
        GoRoute(path: '/clients', builder: (_, __) => const ClientsScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: '/new-invoice', builder: (_, __) => const NewInvoiceScreen()),
  ],
);
