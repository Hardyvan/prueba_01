import 'package:flutter/material.dart';
// Reutilizamos si hace falta

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ScrollController _scrollController = ScrollController();

  // Datos falsos para probar el diseño
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Pollo a la Brasa',
      'price': 65.00,
      'stock': 12,
      'cat': 'Brasa',
    },
    {
      'name': 'Gaseosa Inka Cola 1.5L',
      'price': 12.00,
      'stock': 50,
      'cat': 'Bebidas',
    },
    {
      'name': 'Salchipapa Clásica',
      'price': 15.00,
      'stock': 8,
      'cat': 'Frituras',
    },
    {
      'name': 'Parrilla Mixta',
      'price': 45.00,
      'stock': 5,
      'cat': 'Parrillas',
    },
    {
      'name': 'Chicha Morada Jarra',
      'price': 18.00,
      'stock': 20,
      'cat': 'Bebidas',
    },
    {
      'name': 'Helado de Vainilla',
      'price': 8.00,
      'stock': 0,
      'cat': 'Postres',
    }, // Stock 0
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // FLOATING ACTION BUTTON (Botón flotante para agregar)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aquí iría al formulario de crear producto
        },
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. APPBAR ELÁSTICO (SliverAppBar)
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true, // Se queda pegado arriba al scrollear
            stretch: true,
            backgroundColor: colors.surface,
            surfaceTintColor:
                colors
                    .surface, // Evita cambio de color raro en Material 3
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: colors.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: colors.surface,
              ), // Fondo limpio
              titlePadding: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              title: Text(
                'Inventario',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // BARRA DE BÚSQUEDA INTEGRADA
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                color: colors.surface,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar producto...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colors.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. LISTA DE ELEMENTOS
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = products[index];
                final isOutStock = item['stock'] == 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    // IMAGEN / ICONO (Placeholder)
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.fastfood,
                        color: colors.primary,
                      ),
                    ),

                    // INFORMACIÓN
                    title: Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item['cat'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            // PRECIO
                            Text(
                              'S/ ${item['price'].toStringAsFixed(2)}',
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            // ETIQUETA DE STOCK
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isOutStock
                                        ? colors.error.withValues(
                                          alpha: 0.1,
                                        )
                                        : colors.tertiary.withValues(
                                          alpha: 0.1,
                                        ),
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              child: Text(
                                isOutStock
                                    ? 'Agotado'
                                    : '${item['stock']} unid.',
                                style: TextStyle(
                                  color:
                                      isOutStock
                                          ? colors.error
                                          : colors.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Aquí abrirías el detalle para editar
                    },
                  ),
                );
              }, childCount: products.length),
            ),
          ),

          // ESPACIO AL FINAL PARA QUE EL BOTÓN FLOTANTE NO TAPE EL ÚLTIMO ITEM
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
