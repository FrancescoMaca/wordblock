
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService instance = AudioService._private();

  late final AudioPlayer player;
  late final AudioPlayer soundtrackPlayer;

  AudioService._private() {
    player = AudioPlayer();
    soundtrackPlayer = AudioPlayer();

    player.setPlayerMode(PlayerMode.lowLatency);
    soundtrackPlayer.setPlayerMode(PlayerMode.mediaPlayer);

    player.setAudioContext(AudioContext(iOS: AudioContextIOS(category: AVAudioSessionCategory.soloAmbient)));

    soundtrackPlayer.setVolume(0.1);
    player.setVolume(1);
  }

  Future<void> startSoundtrack() async {
    soundtrackPlayer.seek(Duration.zero);
    soundtrackPlayer.setReleaseMode(ReleaseMode.loop);
    await soundtrackPlayer.play(AssetSource('sounds/soundtrack2.mp3'));
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