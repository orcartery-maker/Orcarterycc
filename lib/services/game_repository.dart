import '../models/game_info.dart';

class GameRepository {
  final List<GameInfo> _games = [];

  GameRepository({List<GameInfo>? initialGames}) {
    if (initialGames != null) {
      for (final game in initialGames) {
        _games.add(_normalizeGame(game));
      }
    }
  }

  GameInfo createGame(GameInfo game) {
    final normalized = _normalizeGame(game);
    final existingIndex = _games.indexWhere((item) => item.id == normalized.id);

    if (existingIndex >= 0) {
      return updateGame(normalized);
    }

    _games.add(normalized);
    return normalized;
  }

  List<GameInfo> getAllGames() => List.unmodifiable(_games);

  GameInfo? getGameById(String id) {
    for (final game in _games) {
      if (game.id == id) {
        return game;
      }
    }
    return null;
  }

  GameInfo updateGame(GameInfo game) {
    final normalized = _normalizeGame(game);
    final index = _games.indexWhere((item) => item.id == normalized.id);

    if (index == -1) {
      _games.add(normalized);
      return normalized;
    }

    _games[index] = normalized;
    return normalized;
  }

  void deleteGame(String id) {
    _games.removeWhere((game) => game.id == id);
  }

  String _nextId() =>
      'game-${DateTime.now().microsecondsSinceEpoch}-${_games.length}';

  GameInfo _normalizeGame(GameInfo game) {
    if (game.id.trim().isNotEmpty) {
      return game;
    }

    return game.copyWith(id: _nextId());
  }
}
