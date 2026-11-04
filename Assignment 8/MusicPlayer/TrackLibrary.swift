import Foundation

struct Track {
    let title: String
    let artist: String
    let fileName: String
    let coverImageName: String
}

enum TrackLibrary {
    // User-selected tracks. Audio files must be supplied separately with appropriate rights.
    // Cover01...Cover10 are temporary artwork until replaced with licensed covers.
    static let tracks: [Track] = [
        Track(title: "Circles", artist: "Post Malone", fileName: "track01", coverImageName: "Cover01"),
        Track(title: "Feel Good Inc.", artist: "Gorillaz", fileName: "track02", coverImageName: "Cover02"),
        Track(title: "Tranz", artist: "Gorillaz", fileName: "track03", coverImageName: "Cover03"),
        Track(title: "Your Man", artist: "Joji", fileName: "track04", coverImageName: "Cover04"),
        Track(title: "Safe and Sound", artist: "Capital Cities", fileName: "track05", coverImageName: "Cover05"),
        Track(title: "Blessings", artist: "Calvin Harris", fileName: "track06", coverImageName: "Cover06"),
        Track(title: "Without Me", artist: "Eminem", fileName: "track07", coverImageName: "Cover07"),
        Track(title: "Sexy Bitch", artist: "David Guetta", fileName: "track08", coverImageName: "Cover08"),
        Track(title: "Levels", artist: "Avicii", fileName: "track09", coverImageName: "Cover09"),
        Track(title: "One Dance", artist: "Drake, Wizkid, Kyla", fileName: "track10", coverImageName: "Cover10")
    ]
}
