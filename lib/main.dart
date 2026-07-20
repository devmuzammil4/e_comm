import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added: State management support
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/theme/dynamic_theme_factory.dart';
import 'features/presentation/di/catalog_dependencies.dart';
import 'features/presentation/pages/product_catalog_page.dart';
import 'features/cart/presentation/di/cart_dependencies.dart';

// Auth Integration Imports (Paths ko apne folder structure ke mutabiq check kar lein)
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  // Enforces engine execution bindings are properly linked prior to initial boot procedures
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // 1. Set Your Running Tenant Target Profile Here (Compile-Time Flag Configuration)
  // ---------------------------------------------------------------------------
  const BusinessTenantType activeTenantTarget = BusinessTenantType.sports;

  // ---------------------------------------------------------------------------
  // 2. Multi-Tenant Service Isolation Bootstrapping
  // ---------------------------------------------------------------------------
  // Initializing base core shared dependencies infrastructure
  await initializeDependencies(activeTenantTarget);

  // Initializing segregated auth module dependencies onto the service map
  initAuthDependencies(sl);

  // Initializing segregated catalog feature module dependencies onto the service map
  initCatalogDependencies(sl);

  // Initializing our polymorphic cart engine into memory registers completely
  initCartDependencies(sl);

  // Initializing app shell execution run loop
  runApp(const MultiTenantAppCoreShell());
}

/// Core Material Wrapper Shell isolating adaptive themes and layout trees cleanly.
class MultiTenantAppCoreShell extends StatelessWidget {
  const MultiTenantAppCoreShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolving dynamic configuration models out of isolated service pointer references
    final AppConfig config = sl<AppConfig>();

    return MultiProvider(
      providers: [
        // Injecting AuthProvider and instantly triggering session restoration on bootup
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => sl<AuthProvider>()..checkExistingSession(),
        ),
        // Aap yahan apna CartProvider ya baqi tenant providers bhi register kar sakte hain:
        // ChangeNotifierProvider<CartProvider>(create: (_) => sl<CartProvider>()),
      ],
      child: MaterialApp(
        title: config.appTitle,
        debugShowCheckedModeBanner: false,

        // Factory theme compilation rules matching your structural target models directly
        theme: DynamicThemeFactory.createTheme(config.tenantType),

        // Root gateway controller management layer
        home: const AuthGate(),
      ),
    );
  }
}

/// Clean Architecture Auth Gate that monitors runtime session updates
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case AuthStateStatus.loading:
          case AuthStateStatus.initial:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Tenant theme native loader
              ),
            );
          case AuthStateStatus.authenticated:
          // Session validated successfully -> Open tenant catalogs directly
            return const ProductCatalogPage();
          case AuthStateStatus.unauthenticated:
          case AuthStateStatus.error:
          default:
          // Session failure or missing -> Enforce login screen route boundary
            return const LoginScreen(); // Replace with your actual LoginScreen widget
        }
      },
    );
  }
}

// Temporary Placeholder for compilation safety (Inko real UI views se replace karein)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AuthProvider>().login('customer@tenant.com', 'securePass'),
          child: const Text('Simulate Login to Catalog'),
        ),
      ),
    );
  }
}
