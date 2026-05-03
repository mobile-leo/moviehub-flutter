import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/models/movie.dart';
import '../../../core/providers/history_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/movie_backdrop.dart';
import '../../../shared/widgets/pressable_card.dart';

class UpcomingBanner extends StatefulWidget {
  final List<Movie> movies;

  const UpcomingBanner({super.key, required this.movies});

  @override
  State<UpcomingBanner> createState() => _UpcomingBannerState();
}

class _UpcomingBannerState extends State<UpcomingBanner> {
  late final PageController _controller;
  late final List<Movie> _movies;
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _movies = widget.movies.take(5).toList();
    _controller = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _movies.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _controller,
                itemCount: _movies.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return PressableCard(
                    onTap: () {
                      context.read<HistoryProvider>().add(movie);
                      context.push('/detail/${movie.id}/${movie.mediaType}');
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MovieBackdrop(
                          backdropPath: movie.backdropPath,
                          height: 200,
                          width: double.infinity,
                          borderRadius: 0,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.75),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.send_rounded,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        const Center(child: _PlayButton()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_movies.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _movies.length,
                  (i) => GestureDetector(
                    onTap: () => _controller.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _current == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _current == i
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.play_arrow_rounded, color: AppColors.onPrimary, size: 28),
    );
  }
}
