/// Represents HLS track which can be played within player
class BetterPlayerHlsTrack {
  ///Width in px of the track
  final int width;

  ///Height in px of the track
  final int height;

  ///Bitrate in px of the track
  final int bitrate;

  BetterPlayerHlsTrack(this.width, this.height, this.bitrate);
}

class BetterPlayerAudioTrack {
  ///Width in px of the track
  final String audioLangId;

  BetterPlayerAudioTrack(this.audioLangId);
}
