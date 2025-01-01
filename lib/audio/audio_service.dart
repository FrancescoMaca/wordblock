
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService instance = AudioService._private();

  late final AudioPlayer player;
  late final AudioPlayer soundtrackPlayer;

  AudioService._private() {
    player = AudioPlayer();
    soundtrackPlayer = AudioPlayer();
  }

  Future<void> startSoundtrack() async {
    soundtrackPlayer.seek(Duration.zero);
    soundtrackPlayer.setReleaseMode(ReleaseMode.loop);
    soundtrackPlayer.setVolume(0.4);
    await soundtrackPlayer.play(AssetSource('sounds/soundtrack.mp3'));
  }

  Future<void> stopSoundtrack() async {
    await soundtrackPlayer.stop();
  }

  Future<void> play(String path) async {
    player.seek(Duration.zero);
    final asset = AssetSource('sounds/$path');
    await player.play(asset);
  }
}