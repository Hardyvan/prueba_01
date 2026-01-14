import 'package:flutter/material.dart';
import 'package:prueba_01/myMenus/menu_item_model.dart';
import 'package:prueba_01/myPages/a_login.dart';
// Importa tus páginas
import 'package:prueba_01/myPages/b_inventory.dart';

class MenuPage extends StatefulWidget {
  // Recibimos el rol: ¿Es admin o no?
  final bool isAdmin;

  const MenuPage({super.key, required this.isAdmin});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Índice para el menú de abajo (Solo usado por el Usuario)
  int _selectedIndex = 0;
  // ===============================================================
  // LÓGICA DE NAVEGACIÓN (COMÚN)
  // ===============================================================
  List<MenuItemModel> _buildMenuItems(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return [
      MenuItemModel(
        title: 'Inventario',
        icon: Icons.inventory_2_rounded,
        color: colors.primary,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const InventoryPage(),
              ),
            ),
      ),
      MenuItemModel(
        title: 'Pedidos',
        icon: Icons.shopping_cart_rounded,
        color: Colors.orange,
        onTap: () {},
      ),
      MenuItemModel(
        title: 'Reportes',
        icon: Icons.bar_chart_rounded,
        color: Colors.purple,
        onTap: () {},
      ),
      MenuItemModel(
        title: 'Configuración',
        icon: Icons.settings_rounded,
        color: colors.secondary,
        onTap: () {},
      ),
    ];
  }

  // ===============================================================
  // BUILD PRINCIPAL: DECIDE QUÉ DISEÑO MOSTRAR
  // ===============================================================
  @override
  Widget build(BuildContext context) {
    // SI ES ADMIN -> Muestra diseño con Drawer (Lateral)
    if (widget.isAdmin) {
      return _buildAdminLayout(context);
    }
    // SI ES USUARIO -> Muestra diseño con NavigationBar (Abajo)
    else {
      return _buildUserLayout(context);
    }
  }

  // ===============================================================
  // DISEÑO 1: ADMINISTRADOR (Drawer + GridView)
  // ===============================================================
  Widget _buildAdminLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final menuItems = _buildMenuItems(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel Administrador',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ), // 1. Negrita para que resalte más
        ),
        centerTitle: true,

        // --- CORRECCIÓN CLAVE AQUÍ ---
        backgroundColor:
            colors
                .primary, // 2. Usamos el color FUERTE, no el "Container" (pastel)
        foregroundColor:
            colors
                .onPrimary, // 3. Esto fuerza a que texto e íconos sean Blancos (o el color que contraste)

        // -----------------------------
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                ),
          ),
        ],
      ),
      // EL DRAWER (SOLO PARA ADMIN)
      drawer: Drawer(
        child: Column(
          children: [
            _drawerHeader(theme, colors, "Administrador"),
            ...menuItems.map(
              (item) => ListTile(
                leading: Icon(item.icon, color: item.color),
                title: Text(item.title),
                onTap: () {
                  Navigator.pop(context);
                  item.onTap();
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Un pequeño ajuste aquí también para usar el color del tema en el saludo
            Text(
              'Bienvenido Jefe 👋',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width < 600 ? 2 : 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                itemCount: menuItems.length,
                itemBuilder:
                    (_, index) =>
                        _dashboardCard(context, menuItems[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // DISEÑO 2: USUARIO (Bottom Navigation Bar)
  // ===============================================================
  // ===============================================================
  // DISEÑO 2: USUARIO (Bottom Navigation Bar)
  // ===============================================================
  Widget _buildUserLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Páginas del usuario (Cambian al tocar abajo)
    final List<Widget> userPages = [
      // Pestaña 0: Inicio
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: colors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 20),
            Text(
              "Toma de Pedidos",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Nuevo Pedido"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),

      // Pestaña 1: Mis Pedidos
      const Center(child: Text("Mis Pedidos en curso")),

      // Pestaña 2: Perfil (Botón de Salir)
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mesero de Turno",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: Colors.white,
              ),
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  ),
              child: const Text("Cerrar Sesión"),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Punto de Venta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // --- CORRECCIÓN CLAVE AQUÍ ---
        backgroundColor: colors.primary, // 1. Color fuerte
        foregroundColor: colors.onPrimary, // 2. Texto blanco

        // -----------------------------
        automaticallyImplyLeading: false, // Sin flecha de atrás
        centerTitle: true,
      ),

      // EL CUERPO CAMBIA SEGÚN EL ÍNDICE
      body: userPages[_selectedIndex],

      // EL MENÚ DE ABAJO (SOLO PARA USUARIO)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // Hacemos que la barra de abajo también respete un poco el color
        indicatorColor: colors.primary.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS AUXILIARES =====================
  Widget _drawerHeader(
    ThemeData theme,
    ColorScheme colors,
    String rol,
  ) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: colors.primary),
      accountName: Text(
        rol,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: const Text("admin@insoft.com.pe"),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person),
      ),
    );
  }

  Widget _dashboardCard(BuildContext context, MenuItemModel item) {
    // (Tu código de tarjeta anterior)
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      elevation: 4,
      child: InkWell(
        onTap: item.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: item.color),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
