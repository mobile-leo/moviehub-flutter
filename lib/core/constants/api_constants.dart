class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String backdropSize = '/w1280';
  static const String posterSize = '/w500';
  static const String profileSize = '/w185';

  static const String trendingMovies = '/trending/movie/week';
  static const String trendingTv = '/trending/tv/week';
  static const String upcomingMovies = '/movie/upcoming';
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String popularTv = '/tv/popular';
  static const String topRatedTv = '/tv/top_rated';
  static const String movieDetail = '/movie/';
  static const String tvDetail = '/tv/';
  static const String searchMulti = '/search/multi';
  static const String genres = '/genre/movie/list';
  static const String tvGenres = '/genre/tv/list';
  static const String discoverMovies = '/discover/movie';
  static const String discoverTv = '/discover/tv';
  static const String movieVideos = '/movie/';
  static const String tvVideos = '/tv/';

  static String posterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$posterSize$path';
  }

  static String backdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$backdropSize$path';
  }

  static String profileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$profileSize$path';
  }
}
