
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService instance = AudioService._private();

  late final AudioPlayer player;
  late final AudioPlayer soundtrackPlayer;

  bool isMuted = false;


  AudioService._private() {
    player = AudioPlayer();
    soundtrackPlayer = AudioPlayer();
  }

  void toggleMute() {
    isMuted = !isMuted;
    soundtrackPlayer.setVolume(isMuted ? 0.0 : 0.4);
    player.setVolume(isMuted ? 0.0 : 1.0);
  }

  Future<void> startSoundtrack() async {
    soundtrackPlayer.seek(Duration.zero);
    soundtrackPlayer.setReleaseMode(ReleaseMode.loop);
    soundtrackPlayer.setVolume(0.4);
    await soundtrackPlayer.play(AssetSource('sounds/soundtrack.mp3'));
  }

  Future<void> resumeSoundtrack() async {
    await soundtrackPlayer.resume();
  }

  Future<void> pauseSoundtrack() async {
    await soundtrackPlayer.pause();
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