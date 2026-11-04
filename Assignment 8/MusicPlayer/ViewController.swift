import UIKit
import AVFoundation

final class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!

    private let tracks = TrackLibrary.tracks
    private var currentTrackIndex = 0
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    private var wantsPlayback = false
    private var playbackRequestID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        coverImageView.layer.cornerRadius = 18
        coverImageView.clipsToBounds = true
        [previousButton, playPauseButton, nextButton].forEach {
            $0?.layer.cornerRadius = 16
            $0?.tintColor = UIColor(red: 0.15, green: 0.19, blue: 0.38, alpha: 1)
        }
        playPauseButton.tintColor = .white
        refreshUI()
    }

    private func refreshUI() {
        guard !tracks.isEmpty else { return }
        let track = tracks[currentTrackIndex]
        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverImageName)
            ?? UIImage(systemName: "music.note")
        coverImageView.tintColor = .white
        let icon = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: icon), for: .normal)
        playPauseButton.accessibilityLabel = isPlaying ? "Pause" : "Play"
    }

    // Load a user-provided song; handle missing or damaged files safely.
    private func loadCurrentTrack(andPlay shouldPlay: Bool, showErrors: Bool = true) {
        playbackRequestID += 1 // Invalidate any asynchronous session activation already in progress.
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        wantsPlayback = shouldPlay

        let track = tracks[currentTrackIndex]
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3")
                ?? Bundle.main.url(forResource: track.fileName, withExtension: "m4a")
                ?? Bundle.main.url(forResource: track.fileName, withExtension: "mp3", subdirectory: "Audio")
                ?? Bundle.main.url(forResource: track.fileName, withExtension: "m4a", subdirectory: "Audio") else {
            print("Missing audio for \(track.title): \(track.fileName).mp3 or .m4a — add file to app target")
            wantsPlayback = false
            if showErrors { showAlert("Missing audio", "To play \(track.title), add your own recording as \(track.fileName).mp3 or \(track.fileName).m4a to the MusicPlayer target.") }
            refreshUI()
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            audioPlayer = player
            if shouldPlay {
                startPlaybackAfterSessionActivation(player)
            }
        } catch {
            wantsPlayback = false
            print("Cannot load \(track.fileName): \(error)")
            if showErrors { showAlert("Audio error", "This track could not be played: \(error.localizedDescription)") }
        }
        refreshUI()
    }

    // AVAudioSession.setActive can block: perform it off the main/UI thread.
    // Never update UIKit or start AVAudioPlayer on that background queue.
    private func startPlaybackAfterSessionActivation(_ player: AVAudioPlayer) {
        playbackRequestID += 1
        let requestID = playbackRequestID
        wantsPlayback = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self, weak player] in
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default)
                try session.setActive(true)

                DispatchQueue.main.async { [weak self, weak player] in
                    guard let self, let player,
                          self.playbackRequestID == requestID,
                          self.audioPlayer === player,
                          self.wantsPlayback else { return }
                    self.isPlaying = player.play()
                    self.wantsPlayback = self.isPlaying
                    self.refreshUI()
                    if !self.isPlaying {
                        self.showAlert("Playback error", "The audio track could not start.")
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self, self.playbackRequestID == requestID else { return }
                    self.wantsPlayback = false
                    self.isPlaying = false
                    self.refreshUI()
                    self.showAlert("Audio session error", error.localizedDescription)
                }
            }
        }
    }

    @IBAction private func playPauseTapped(_ sender: UIButton) {
        if wantsPlayback || isPlaying {
            playbackRequestID += 1 // Cancel any pending activation before pausing.
            audioPlayer?.pause()
            wantsPlayback = false
            isPlaying = false
            refreshUI()
        } else if let player = audioPlayer {
            startPlaybackAfterSessionActivation(player)
        } else {
            loadCurrentTrack(andPlay: true)
        }
    }

    @IBAction private func nextTapped(_ sender: UIButton) { changeTrack(by: 1) }
    @IBAction private func previousTapped(_ sender: UIButton) { changeTrack(by: -1) }

    private func changeTrack(by offset: Int) {
        guard !tracks.isEmpty else { return }
        let shouldContinuePlaying = wantsPlayback || isPlaying
        currentTrackIndex = (currentTrackIndex + offset + tracks.count) % tracks.count
        loadCurrentTrack(andPlay: shouldContinuePlaying, showErrors: shouldContinuePlaying)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else {
            wantsPlayback = false
            isPlaying = false
            refreshUI()
            return
        }
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        loadCurrentTrack(andPlay: true)
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
