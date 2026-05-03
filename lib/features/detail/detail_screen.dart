import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/movie.dart';
import '../../core/providers/detail_provider.dart';
import '../../core/providers/favorites_provider.dart';
import '../../core/providers/history_provider.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/cast_section.dart';
import 'widgets/detail_backdrop.dart';
import 'widgets/detail_info.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  final String mediaType;

  const DetailScreen({
    super.key,
    required this.movieId,
    required this.mediaType,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailProvider _detailProvider;

  @override
  void initState() {
    super.initState();
    _detailProvider = DetailProvider();
    _detailProvider.load(widget.movieId, widget.mediaType).then((_) {
      final detail = _detailProvider.detail;
      if (detail != null && mounted) {
        context.read<HistoryProvider>().add(
              Movie(
                id: detail.id,
                title: detail.title,
                posterPath: detail.posterPath,
                backdropPath: detail.backdropPath,
                voteAverage: detail.voteAverage,
                mediaType: detail.mediaType,
              ),
            );
      }
    });
  }

  @override
  void dispose() {
    _detailProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _detailProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<DetailProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (provider.error != null || provider.detail == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.textSecondary, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Não foi possível carregar os detalhes.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            final detail = provider.detail!;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: DetailBackdrop(detail: detail),
                ),
                SliverToBoxAdapter(
                  child: DetailInfo(detail: detail),
                ),
                if (detail.cast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: CastSection(cast: detail.cast),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }
}
