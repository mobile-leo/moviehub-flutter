import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/movie.dart';
import '../../../core/providers/history_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/movie_poster.dart';
import '../../../shared/widgets/pressable_card.dart';
import '../../../shared/widgets/rating_badge.dart';

class TrendingRow extends StatelessWidget {
  final List<Movie> movies;

  const TrendingRow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox(height: 180);
    }

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final isCenter = index == 1;

          return PressableCard(
            onTap: () {
              context.read<HistoryProvider>().add(movie);
              context.push('/detail/${movie.id}/${movie.mediaType}');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: isCenter ? 150 : 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MoviePoster(
                      posterPath: movie.posterPath,
                      width: isCenter ? 150 : 110,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isCenter)
                    Row(
                      children: [
                        _Badge(label: movie.isAdult ? '18+' : 'PG'),
                        const SizedBox(width: 6),
                        RatingBadge(rating: movie.voteAverage),
                      ],
                    ),
                  if (isCenter) const SizedBox(height: 4),
                  Text(
                    movie.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isCenter ? 13 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
