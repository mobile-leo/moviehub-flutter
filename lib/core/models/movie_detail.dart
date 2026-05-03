import 'genre.dart';
import 'cast_member.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final int? runtime;
  final List<Genre> genres;
  final List<CastMember> cast;
  final bool isAdult;
  final String mediaType;

  const MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.cast = const [],
    this.isAdult = false,
    this.mediaType = 'movie',
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json, String mediaType) {
    final creditsJson = json['credits'] as Map<String, dynamic>?;
    final castList = (creditsJson?['cast'] as List<dynamic>?)
            ?.take(10)
            .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return MovieDetail(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      runtime: json['runtime'] as int? ??
          ((json['episode_run_time'] as List?)?.isNotEmpty == true
              ? (json['episode_run_time'] as List).first as int
              : null),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cast: castList,
      isAdult: json['adult'] as bool? ?? false,
      mediaType: mediaType,
    );
  }

  String get formattedRuntime {
    if (runtime == null) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}
