import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/search_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/movie_poster.dart';
import '../../shared/widgets/rating_badge.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            style: const TextStyle(color: AppColors.textPrimary),
                            cursorColor: AppColors.primary,
                            decoration: const InputDecoration(
                              hintText: 'Buscar filmes e séries...',
                              hintStyle: TextStyle(color: AppColors.textSecondary),
                              prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            onChanged: (value) {
                              Future.delayed(const Duration(milliseconds: 400), () {
                                if (_controller.text == value) {
                                  provider.search(value);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          provider.clear();
                          context.pop();
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: AppColors.primary, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildResults(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResults(BuildContext context, SearchProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (provider.query.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 56),
            const SizedBox(height: 12),
            Text('Busque por filmes ou séries', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (provider.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied_outlined, color: AppColors.textSecondary, size: 56),
            const SizedBox(height: 12),
            Text(
              'Nenhum resultado para "${provider.query}"',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.results.length,
      itemBuilder: (context, index) {
        final movie = provider.results[index];
        return GestureDetector(
          onTap: () => context.push('/detail/${movie.id}/${movie.mediaType}'),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                MoviePoster(
                  posterPath: movie.posterPath,
                  width: 60,
                  height: 88,
                  borderRadius: 8,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              movie.mediaType == 'tv' ? 'Série' : 'Filme',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RatingBadge(rating: movie.voteAverage),
                        ],
                      ),
                      if (movie.overview?.isNotEmpty == true) ...[
                        const SizedBox(height: 5),
                        Text(
                          movie.overview!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
