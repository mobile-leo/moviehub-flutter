import '../constants/api_constants.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import 'http_client.dart';

class MovieService {
  final ApiClient _client;

  MovieService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<Movie>> getTrending() async {
    final data = await _client.get(ApiConstants.trendingMovies);
    return _parseMovies(data);
  }

  Future<List<Movie>> getTrendingTv() async {
    final data = await _client.get(ApiConstants.trendingTv);
    return _parseMovies(data);
  }

  Future<List<Movie>> getUpcoming() async {
    final data = await _client.get(ApiConstants.upcomingMovies);
    return _parseMovies(data);
  }

  Future<List<Movie>> getPopularMovies() async {
    final data = await _client.get(ApiConstants.popularMovies);
    return _parseMovies(data);
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final data = await _client.get(ApiConstants.topRatedMovies);
    return _parseMovies(data);
  }

  Future<List<Movie>> getPopularTv() async {
    final data = await _client.get(ApiConstants.popularTv);
    return _parseMovies(data);
  }

  Future<MovieDetail> getMovieDetail(int id, String mediaType) async {
    final path = mediaType == 'tv'
        ? '${ApiConstants.tvDetail}$id'
        : '${ApiConstants.movieDetail}$id';
    final data = await _client.get(path, {'append_to_response': 'credits'});
    return MovieDetail.fromJson(data, mediaType);
  }

  Future<List<Movie>> search(String query) async {
    final data = await _client.get(
      ApiConstants.searchMulti,
      {'query': query},
    );
    return _parseMovies(data);
  }

  Future<String?> getTrailerKey(int id, String mediaType) async {
    final path = mediaType == 'tv'
        ? '${ApiConstants.tvVideos}$id/videos'
        : '${ApiConstants.movieVideos}$id/videos';
    final data = await _client.get(path);
    final results = data['results'] as List<dynamic>;
    final trailer = results.cast<Map<String, dynamic>>().firstWhere(
          (v) =>
              v['site'] == 'YouTube' &&
              (v['type'] == 'Trailer' || v['type'] == 'Teaser'),
          orElse: () => {},
        );
    return trailer['key'] as String?;
  }

  Future<List<Movie>> getByGenre(int genreId, String mediaType) async {
    final path = mediaType == 'tv'
        ? ApiConstants.discoverTv
        : ApiConstants.discoverMovies;
    final data = await _client.get(path, {'with_genres': genreId.toString()});
    return _parseMovies(data);
  }

  Future<List<Genre>> getMovieGenres() async {
    final data = await _client.get(ApiConstants.genres);
    return (data['genres'] as List<dynamic>)
        .map((e) => Genre.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Genre>> getTvGenres() async {
    final data = await _client.get(ApiConstants.tvGenres);
    return (data['genres'] as List<dynamic>)
        .map((e) => Genre.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<Movie> _parseMovies(Map<String, dynamic> data) {
    return (data['results'] as List<dynamic>)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .where((m) => m.backdropPath != null || m.posterPath != null)
        .toList();
  }
}
