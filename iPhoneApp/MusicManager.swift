import MediaPlayer

class MusicManager {
    private let player = MPMusicPlayerController.applicationMusicPlayer

    func playMusic(for mood: String) {
        let playlists = [
            "Energetic": "PlaylistID1",
            "Relaxed": "PlaylistID2",
            "Neutral": "PlaylistID3"
        ]

        guard let playlistID = playlists[mood] else {
            print("No playlist found for mood: \(mood)")
            return
        }

        setQueueAndPlay(playlistID: playlistID)
    }

    private func setQueueAndPlay(playlistID: String) {
        player.setQueue(with: [playlistID])
        player.play()
        print("Playing music for playlist: \(playlistID)")
    }

    func stopMusic() {
        player.stop()
        print("Music playback stopped.")
    }

    func nowPlaying() -> String? {
        guard let nowPlayingItem = player.nowPlayingItem else { return nil }
        let trackTitle = nowPlayingItem.title ?? "Unknown Title"
        let artist = nowPlayingItem.artist ?? "Unknown Artist"
        return "\(trackTitle) by \(artist)"
    }
}
