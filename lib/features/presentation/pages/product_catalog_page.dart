import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/di/injection_container.dart';
import 'package:e_comm/features/catalog/domain/entities/product_entity.dart';
import '../providers/catalog_provider.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  late final CatalogProvider _catalogProvider;
  late final AppConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = sl<AppConfig>();
    _catalogProvider = sl<CatalogProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _catalogProvider.loadCatalog(_currentConfig.tenantType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CatalogProvider>.value(
      value: _catalogProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentConfig.appTitle),
          centerTitle: _currentConfig.tenantType == BusinessTenantType.marketing,
        ),
        body: Consumer<CatalogProvider>(
          builder: (context, provider, _) {
            switch (provider.status) {
              case CatalogStatus.initial:
              case CatalogStatus.loading:
                return const Center(child: CircularProgressIndicator.adaptive());
              case CatalogStatus.error:
                return _buildGracefulErrorState(provider.errorMessage);
              case CatalogStatus.loaded:
                return _buildAdaptiveLayout(provider.products);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdaptiveLayout(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const Center(child: Text("No items available under this catalog matrix."));
    }

    switch (_currentConfig.tenantType) {
      case BusinessTenantType.sports:
        return GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => _buildSportsCard(products[index]),
        );

      case BusinessTenantType.restaurant:
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: products.length,
          itemBuilder: (context, index) => _buildRestaurantRow(products[index]),
        );

      case BusinessTenantType.marketing:
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          itemCount: products.length,
          itemBuilder: (context, index) => _buildMarketingTile(products[index]),
        );
    }
  }

  Widget _buildSportsCard(ProductEntity product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,
              width: double.infinity,
              child: const Icon(Icons.sports_soccer, size: 48, color: Colors.white24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              "\$${product.calculatedFinalPrice.toStringAsFixed(2)}",
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantRow(ProductEntity product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0), // Fixed: Correct Constructor Used
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(Icons.fastfood, color: Colors.white24),
        ),
        title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(
          "\$${product.calculatedFinalPrice.toStringAsFixed(2)}",
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildMarketingTile(ProductEntity product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0), // Fixed: Correct Constructor Used
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.layers, size: 36, color: Colors.blueGrey),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  const SizedBox(height: 4.0),
                  Text("B2B ID: ${product.id}", style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ],
              ),
            ),
            Text(
              "Bulk Tier Min: \$${product.basePrice.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGracefulErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16.0),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _catalogProvider.loadCatalog(_currentConfig.tenantType),
              child: const Text("Retry Connection"),
            ),
          ],
        ),
      ),
    );
  }
}
