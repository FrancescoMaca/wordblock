import 'package:just_audio/just_audio.dart';

class AudioService {
  static AudioService? _instance;
  
  static AudioService get instance {
    _instance ??= AudioService._private();
    return _instance!;
  }

  late final AudioPlayer player;
  late final AudioPlayer soundtrackPlayer;

  static void dispose() {
    if (_instance != null) {
      _instance!.player.dispose();
      _instance!.soundtrackPlayer.dispose();
      _instance = null;
    }
  }

  AudioService._private() {
    player = AudioPlayer();
    soundtrackPlayer = AudioPlayer();

    // Set volumes
    soundtrackPlayer.setVolume(0.1);
    player.setVolume(1.0);
  }

  Future<void> startSoundtrack() async {
    await soundtrackPlayer.stop();
    await soundtrackPlayer.seek(Duration.zero);
    await soundtrackPlayer.setLoopMode(LoopMode.one);
    await soundtrackPlayer.setAsset('assets/sounds/soundtrack.mp3');
    await soundtrackPlayer.play();
  }

  Future<void> resumeSoundtrack() async {
    await soundtrackPlayer.play();
  }

  Future<void> pauseSoundtrack() async {
    await soundtrackPlayer.pause();
  }

  Future<void> stopSoundtrack() async {
    await soundtrackPlayer.stop();
  }

  Future<void> play(String path) async {
    await player.stop();
    await player.seek(Duration.zero);

    await player.setAsset('assets/sounds/$path');
    player.play();
  }
}