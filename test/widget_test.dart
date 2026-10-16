import 'package:flutter_test/flutter_test.dart';

import 'package:orcullo/models/game_info.dart';
import 'package:orcullo/services/game_repository.dart';

void main() {
  group('GameRepository CRUD', () {
    late GameRepository repository;

    setUp(() {
      repository = GameRepository();
    });

    test('create, read, update and delete a game preset', () {
      final created = repository.createGame(
        GameInfo(
          title: 'Custom Quest',
          description: 'A puzzle challenge',
          category: 'Puzzle',
          emoji: '🧩',
        ),
      );

      expect(created.id, isNotEmpty);
      expect(repository.getAllGames(), hasLength(1));

      final updated = repository.updateGame(
        created.copyWith(description: 'A new puzzle challenge'),
      );

      expect(updated.description, 'A new puzzle challenge');
      expect(
        repository.getGameById(created.id)?.description,
        'A new puzzle challenge',
      );

      repository.deleteGame(created.id);
      expect(repository.getAllGames(), isEmpty);
    });

    test('GameInfo supports JSON conversion and copyWith', () {
      final game = GameInfo(
        id: 'game-1',
        title: 'Arcade Rush',
        description: 'Tap to win',
        category: 'Arcade',
        emoji: '🎮',
        isOnline: true,
      );

      final json = game.toJson();
      final roundTrip = GameInfo.fromJson(json);

      expect(roundTrip.id, 'game-1');
      expect(roundTrip.title, 'Arcade Rush');
      expect(roundTrip.isOnline, isTrue);
      expect(roundTrip.copyWith(title: 'Arcade Blast').title, 'Arcade Blast');
    });
  });
}
