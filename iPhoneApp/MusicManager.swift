import MediaPlayer

class MusicManager {
    func playMusic(for mood: String) {
        let playlists = [
            "Energetic": "PlaylistID1",
            "Relaxed": "PlaylistID2",
            "Neutral": "PlaylistID3"
        ]
        guard let playlistID = playlists[mood] else { return }

        let player = MPMusicPlayerController.applicationMusicPlayer
        player.setQueue(with: playlistID)
        player.play()
    }
}
