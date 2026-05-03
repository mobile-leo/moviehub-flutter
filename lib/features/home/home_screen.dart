import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/favorites_provider.dart';
import '../../core/providers/history_provider.dart';
import '../../core/providers/home_provider.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/genre_filter_row.dart';
import 'widgets/home_header.dart';
import 'widgets/my_list_tab.dart';
import 'widgets/section_header.dart';
import 'widgets/trending_row.dart';
import 'widgets/upcoming_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                HomeHeader(
                  selectedTab: provider.tab,
                  onTabChanged: provider.setTab,
                ),
                Expanded(
                  child: _buildBody(provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(HomeProvider provider) {
    if (provider.tab == HomeTab.myList) {
      return Consumer<FavoritesProvider>(
        builder: (_, fav, __) => MyListTab(movies: fav.favorites),
      );
    }

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 12),
            Text(
              'Falha ao carregar. Verifique sua conexão.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: provider.loadContent,
              child: const Text('Tentar novamente', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }

    return Consumer<HistoryProvider>(
      builder: (context, history, _) {
        return CustomScrollView(
          slivers: [
            if (provider.upcoming.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                  child: Text(
                    'Em Breve',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: UpcomingBanner(movies: provider.upcoming),
              ),
            ],
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: GenreFilterRow(
                  genres: provider.genres,
                  selectedGenreId: provider.selectedGenreId,
                  onSelected: provider.selectGenre,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Em Alta Agora',
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              ),
            ),
            SliverToBoxAdapter(
              child: TrendingRow(movies: provider.filteredTrending),
            ),
            if (provider.recommended.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Recomendados para Você',
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                ),
              ),
              SliverToBoxAdapter(
                child: TrendingRow(movies: provider.recommended),
              ),
            ],
            if (history.history.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Vistos Recentemente',
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                ),
              ),
              SliverToBoxAdapter(
                child: TrendingRow(movies: history.history),
              ),
            ],
            if (provider.popular.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Populares',
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                ),
              ),
              SliverToBoxAdapter(
                child: TrendingRow(movies: provider.popular),
              ),
            ],
            if (provider.topRated.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Mais Bem Avaliados',
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                ),
              ),
              SliverToBoxAdapter(
                child: TrendingRow(movies: provider.topRated),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }
}
