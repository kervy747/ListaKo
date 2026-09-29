import 'package:flutter/material.dart';
import 'package:listako/controllers/currency_controller.dart';
import 'package:listako/controllers/home_controller.dart';
import 'package:listako/models/grocery_list.dart';
import 'package:listako/views/auth/login_screen.dart';
import 'package:listako/views/home/add_list_sheet.dart';
import 'package:listako/views/home/grocery_list_card.dart';
import 'package:listako/views/home/home_header.dart';
import 'package:listako/views/listing/list_detail_screen.dart';
import 'package:listako/views/profile/profile_screen.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/views/widgets/currency_picker_sheet.dart';
import 'package:listako/views/widgets/empty_state.dart';
import 'package:listako/views/widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.username});

  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController();

  // card colors
  static const List<Color> _cardHeaderColors = [
    Color(0xFFDCEDC8),
    Color(0xFFFFF3B0),
    Color(0xFFFFD0CE),
    Color(0xFFE7ECEF),
  ];

  static const List<Color> _cardBadgeColors = [
    AppColors.green,
    Color(0xFFC9A227),
    AppColors.red,
    Color(0xFF7A8B99),
  ];

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // open new list
  Future<void> _openAddListSheet() async {
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const AddListSheet(),
    );
    if (name != null) await _controller.createList(name);
  }

  // open currency picker
  Future<void> _openCurrencyPicker() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const CurrencyPickerSheet(),
    );
  }

  // open list
  Future<void> _openList(GroceryList list) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListDetailScreen(list: list)),
    );
    await _controller.saveList(list);
  }

  // open profile
  Future<void> _openProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
    _controller.refreshUser();
  }

  // delete dialog
  void _confirmDeleteList(GroceryList list) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('This will remove "${list.name}" and all its items.'),
        actions: [
          // cancel button
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          // delete button
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _controller.deleteList(list.id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  // logout dialog
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          // cancel button
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          // logout button
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _controller.logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()));
            },
            child:
                const Text('Log Out', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_controller, CurrencyController.instance]),
      builder: (context, _) {
        final currency = CurrencyController.instance.currency;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  decoration: const BoxDecoration(color: AppColors.green),
                  child: HomeHeader(
                    username: widget.username,
                    photoUrl: _controller.photoUrl,
                    currency: currency,
                    onCurrencyTap: _openCurrencyPicker,
                    onLogoutTap: _confirmLogout,
                    onProfileTap: _openProfile,
                  ),
                ),

                // body
                Expanded(
                  child: _controller.isLoading
                      // loading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomScrollView(
                          slivers: [
                            // stats + title
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // stat card
                                    StatCard(
                                      totalSpent: _controller.totalSpent,
                                      totalItems: _controller.totalItems,
                                      listCount: _controller.lists.length,
                                      currencySymbol: currency.symbol,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // your lists title
                                        const Text(
                                          'Your lists',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textDark),
                                        ),
                                        // list count badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            '${_controller.lists.length} list${_controller.lists.length == 1 ? '' : 's'}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),

                            // list grid or empty state
                            _controller.lists.isEmpty
                                ? SliverFillRemaining(
                                    child: _buildEmptyState(),
                                  )
                                : SliverPadding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 90),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 14,
                                        crossAxisSpacing: 14,
                                        childAspectRatio: 0.8,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          final list = _controller.lists[index];
                                          // list card
                                          return GroceryListCard(
                                            list: list,
                                            index: index,
                                            headerColor: _cardHeaderColors[
                                                index % _cardHeaderColors.length],
                                            badgeColor: _cardBadgeColors[
                                                index % _cardBadgeColors.length],
                                            currencySymbol: currency.symbol,
                                            onTap: () => _openList(list),
                                            onDelete: () =>
                                                _confirmDeleteList(list),
                                          );
                                        },
                                        childCount: _controller.lists.length,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          // new list button
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAddListSheet,
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            icon: const Icon(Icons.add),
            label: const Text('New List'),
          ),
        );
      },
    );
  }

  // empty state
  Widget _buildEmptyState() {
    return const EmptyState(
      icon: Icons.list_alt,
      title: 'No lists yet',
      message:
          'Tap "New List" to create your first grocery list — like "Mall" or "Palengke".',
    );
  }
}
