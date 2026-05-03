import 'package:flutter/material.dart';
import '../../../core/models/genre.dart';
import '../../../shared/widgets/genre_chip.dart';

class GenreFilterRow extends StatelessWidget {
  final List<Genre> genres;
  final int? selectedGenreId;
  final Future<void> Function(int?) onSelected;

  const GenreFilterRow({
    super.key,
    required this.genres,
    required this.selectedGenreId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GenreChip(
            label: 'Todos',
            selected: selectedGenreId == null,
            onTap: () => onSelected(null),
          ),
          ...genres.take(8).map(
                (g) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GenreChip(
                    label: g.name,
                    selected: selectedGenreId == g.id,
                    onTap: () => onSelected(g.id),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
