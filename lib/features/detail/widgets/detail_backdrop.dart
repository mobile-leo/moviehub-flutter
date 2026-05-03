import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/providers/detail_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'trailer_player_sheet.dart';

class DetailBackdrop extends StatelessWidget {
  final MovieDetail detail;

  const DetailBackdrop({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final backdropUrl = ApiConstants.backdropUrl(detail.backdropPath);
    final screenHeight = MediaQuery.of(context).size.height * 0.55;
    final trailerKey = context.watch<DetailProvider>().trailerKey;

    return Stack(
      children: [
        SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: backdropUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: AppColors.card),
                )
              : Container(color: AppColors.card),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 16,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: _PlayButton(trailerKey: trailerKey, title: detail.title),
          ),
        ),
        if (detail.formattedRuntime.isNotEmpty)
          Positioned(
            bottom: 12,
            right: 16,
            child: Text(
              detail.formattedRuntime,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  final String? trailerKey;
  final String title;

  const _PlayButton({required this.trailerKey, required this.title});

  void _openTrailer(BuildContext context) {
    if (trailerKey == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrailerPlayerSheet(
        trailerKey: trailerKey!,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTrailer = trailerKey != null;

    return GestureDetector(
      onTap: hasTrailer ? () => _openTrailer(context) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: hasTrailer ? AppColors.primary : AppColors.primary.withOpacity(0.4),
          shape: BoxShape.circle,
          boxShadow: hasTrailer
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 16, spreadRadius: 2)]
              : null,
        ),
        child: hasTrailer
            ? const Icon(Icons.play_arrow_rounded, color: AppColors.onPrimary, size: 32)
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              ),
      ),
    );
  }
}
