import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/movie.dart';
import '../../../core/providers/history_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/movie_poster.dart';
import '../../../shared/widgets/pressable_card.dart';

class MyListTab extends StatelessWidget {
  final List<Movie> movies;

  const MyListTab({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary, size: 56),
            const SizedBox(height: 12),
            Text(
              'Sua lista está vazia.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Adicione filmes e séries para assistir depois.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return PressableCard(
          onTap: () {
            context.read<HistoryProvider>().add(movie);
            context.push('/detail/${movie.id}/${movie.mediaType}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MoviePoster(
                  posterPath: movie.posterPath,
                  width: double.infinity,
                  borderRadius: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                movie.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
