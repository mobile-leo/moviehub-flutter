import 'package:flutter/foundation.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';

class DetailProvider extends ChangeNotifier {
  final MovieService _service;

  DetailProvider({MovieService? service}) : _service = service ?? MovieService();

  MovieDetail? _detail;
  MovieDetail? get detail => _detail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _trailerKey;
  String? get trailerKey => _trailerKey;

  Future<void> load(int id, String mediaType) async {
    _isLoading = true;
    _detail = null;
    _error = null;
    _trailerKey = null;
    notifyListeners();

    try {
      _detail = await _service.getMovieDetail(id, mediaType);
      _trailerKey = await _service.getTrailerKey(id, mediaType);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
