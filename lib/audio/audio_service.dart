import 'package:audioplayers/audioplayers.dart';

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

    player.setPlayerMode(PlayerMode.lowLatency);
    soundtrackPlayer.setPlayerMode(PlayerMode.lowLatency);

    player.setAudioContext(AudioContext(iOS: AudioContextIOS(category: AVAudioSessionCategory.soloAmbient)));

    soundtrackPlayer.setVolume(0.1);
    player.setVolume(1);
  }

  Future<void> startSoundtrack() async {
    await soundtrackPlayer.stop();
    soundtrackPlayer.seek(Duration.zero);
    soundtrackPlayer.setReleaseMode(ReleaseMode.loop);
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
    await player.stop();
    player.seek(Duration.zero);
    final asset = AssetSource('sounds/$path');
    await player.play(asset);
  }
}