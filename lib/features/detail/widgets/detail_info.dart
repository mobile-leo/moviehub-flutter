import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/rating_badge.dart';

class DetailInfo extends StatefulWidget {
  final MovieDetail detail;

  const DetailInfo({super.key, required this.detail});

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final overview = detail.overview ?? '';
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(detail.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Badge(label: detail.isAdult ? '18+' : 'PG'),
              const SizedBox(width: 8),
              ...detail.genres.take(2).map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _Badge(label: g.name),
                    ),
                  ),
              RatingBadge(rating: detail.voteAverage, fontSize: 14),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.read<FavoritesProvider>().toggle(
                        Movie(
                          id: detail.id,
                          title: detail.title,
                          posterPath: detail.posterPath,
                          backdropPath: detail.backdropPath,
                          voteAverage: detail.voteAverage,
                          mediaType: detail.mediaType,
                        ),
                      );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isFavorite ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
                    border: Border.all(
                      color: isFavorite ? AppColors.primary : AppColors.textSecondary,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      isFavorite ? Icons.check : Icons.add,
                      key: ValueKey(isFavorite),
                      color: isFavorite ? AppColors.primary : AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: AppColors.textPrimary, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            detail.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (overview.isNotEmpty) ...[
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text: _expanded || overview.length <= 180
                          ? overview
                          : '${overview.substring(0, 180)}... ',
                    ),
                    if (!_expanded && overview.length > 180)
                      const TextSpan(
                        text: 'Mais',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
