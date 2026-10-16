import 'package:flutter/material.dart';

import '../models/game_info.dart';
import '../services/game_repository.dart';
import '../widgets/game_card.dart';

class DeveloperLabPage extends StatefulWidget {
  final List<GameInfo> offlineGames;
  final List<GameInfo> onlineGames;
  final ValueChanged<GameInfo> onLaunchGame;

  const DeveloperLabPage({
    super.key,
    required this.offlineGames,
    required this.onlineGames,
    required this.onLaunchGame,
  });

  @override
  State<DeveloperLabPage> createState() => _DeveloperLabPageState();
}

class _DeveloperLabPageState extends State<DeveloperLabPage> {
  final GameRepository _repository = GameRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController();

  bool developerMode = false;
  bool aiOpponent = false;
  String difficulty = 'Normal';
  int maxPlayers = 2;
  GameInfo? _editingPreset;

  List<GameInfo> get savedPresets => _repository.getAllGames();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _deletePreset(GameInfo preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete preset?'),
        content: Text('Delete "${preset.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _repository.deleteGame(preset.id);
      if (_editingPreset?.id == preset.id) {
        _clearForm();
      }
      setState(() {});
    }
  }

  void _clearForm() {
    _editingPreset = null;
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _emojiController.clear();
  }

  void _editPreset(GameInfo preset) {
    setState(() {
      _editingPreset = preset;
      _titleController.text = preset.title;
      _descriptionController.text = preset.description;
      _categoryController.text = preset.category;
      _emojiController.text = preset.emoji;
    });
  }

  void _savePreset() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final category = _categoryController.text.trim();
    final emoji = _emojiController.text.trim().isEmpty
        ? '🎮'
        : _emojiController.text.trim();

    if (title.isEmpty || description.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title, description and category are required.'),
        ),
      );
      return;
    }

    final preset = GameInfo(
      id: _editingPreset?.id ?? '',
      title: title,
      description: description,
      category: category,
      emoji: emoji,
    );

    if (_editingPreset == null) {
      _repository.createGame(preset);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preset created successfully.')),
      );
    } else {
      _repository.updateGame(preset);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preset updated successfully.')),
      );
    }

    setState(() {
      _clearForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Developer Mode'),
          subtitle: const Text('Show developer options'),
          value: developerMode,
          onChanged: (value) => setState(() => developerMode = value),
        ),
        SwitchListTile(
          title: const Text('AI Opponent'),
          subtitle: const Text('Preference setting; not connected to game AI'),
          value: aiOpponent,
          onChanged: (value) => setState(() => aiOpponent = value),
        ),
        const Divider(),
        const Text(
          'Game Difficulty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: difficulty,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'Easy', child: Text('Easy')),
            DropdownMenuItem(value: 'Normal', child: Text('Normal')),
            DropdownMenuItem(value: 'Hard', child: Text('Hard')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => difficulty = value);
          },
        ),
        const SizedBox(height: 16),
        Text('Maximum Players: $maxPlayers'),
        Slider(
          value: maxPlayers.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: '$maxPlayers',
          onChanged: (value) => setState(() => maxPlayers = value.round()),
        ),
        const Divider(),
        Text(
          _editingPreset == null
              ? 'Create Custom Preset'
              : 'Edit Custom Preset',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _categoryController,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emojiController,
          maxLength: 2,
          decoration: const InputDecoration(
            labelText: 'Emoji',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _savePreset,
                icon: const Icon(Icons.save),
                label: Text(
                  _editingPreset == null ? 'Create Preset' : 'Update Preset',
                ),
              ),
            ),
            if (_editingPreset != null) ...[
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _clearForm,
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
              ),
            ],
          ],
        ),
        if (savedPresets.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Saved Presets',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...savedPresets.map(
            (preset) => Card(
              child: ListTile(
                leading: Text(
                  preset.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(preset.title),
                subtitle: Text('${preset.category} • ${preset.description}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit preset',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _editPreset(preset),
                    ),
                    IconButton(
                      tooltip: 'Delete preset',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deletePreset(preset),
                    ),
                  ],
                ),
                onTap: () => widget.onLaunchGame(preset),
              ),
            ),
          ),
        ],
        const Divider(),
        const Text(
          'Quick Game Launch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...widget.offlineGames.map(
          (game) =>
              GameCard(game: game, onTap: () => widget.onLaunchGame(game)),
        ),
      ],
    );
  }
}
