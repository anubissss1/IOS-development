import UIKit

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int  // 0...5
    let description: String
}

enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Brassic", subtitle: "Series · British comedy-drama · 2019", imageName: "Poster01", rating: 5, description: "A group of friends navigates outrageous schemes and everyday troubles. Loyalty keeps them together even when their plans go wrong. Its mix of comedy and heartfelt moments makes it unforgettable."),
        FavoriteItem(title: "The Boys", subtitle: "Series · Superhero satire · 2019", imageName: "Poster02", rating: 5, description: "In a world of celebrity superheroes, public image hides dangerous secrets. A determined group tries to expose the powerful. The show blends dark humor with unpredictable conflict."),
        FavoriteItem(title: "How I Met Your Mother", subtitle: "Series · Sitcom · 2005", imageName: "Poster03", rating: 5, description: "A group of friends grows up together in New York City. Their relationships and adventures are told through memories. The comedy balances running jokes with emotional turning points."),
        FavoriteItem(title: "Spider-Man: Into the Spider-Verse", subtitle: "Film · Animation · 2018", imageName: "Poster04", rating: 5, description: "Miles Morales discovers a new responsibility when he becomes Spider-Man. Heroes from different universes help him find his own courage. Its animation style makes every scene distinctive."),
        FavoriteItem(title: "Spider-Man: Across the Spider-Verse", subtitle: "Film · Animation · 2023", imageName: "Poster05", rating: 5, description: "Miles Morales encounters a vast network of Spider-people. Their different ideas of responsibility create difficult choices. The vivid animation makes the multiverse feel alive."),
        FavoriteItem(title: "Black Panther", subtitle: "Film · Marvel adventure · 2018", imageName: "Poster06", rating: 4, description: "Black Panther is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Interstellar", subtitle: "Film · Science fiction · 2014", imageName: "Poster07", rating: 5, description: "Explorers travel beyond Earth in search of a future for humanity. The journey tests the limits of time, science, and family bonds. Its images and music make the story especially moving."),
        FavoriteItem(title: "The Green Mile", subtitle: "Film · Drama · 1999", imageName: "Poster08", rating: 5, description: "The Green Mile is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Breaking Bad", subtitle: "Series · Crime drama · 2008", imageName: "Poster09", rating: 5, description: "Breaking Bad is a memorable series with distinctive characters and a strong atmosphere. Its story develops through engaging episodes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Better Call Saul", subtitle: "Series · Crime drama · 2015", imageName: "Poster10", rating: 5, description: "Better Call Saul is a memorable series with distinctive characters and a strong atmosphere. Its story develops through engaging episodes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "The Dark Knight", subtitle: "Film · Superhero thriller · 2008", imageName: "Poster11", rating: 5, description: "The Dark Knight is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Inception", subtitle: "Film · Sci-fi thriller · 2010", imageName: "Poster12", rating: 5, description: "Inception is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "The Prestige", subtitle: "Film · Mystery · 2006", imageName: "Poster13", rating: 5, description: "The Prestige is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "The Shawshank Redemption", subtitle: "Film · Drama · 1994", imageName: "Poster14", rating: 5, description: "The Shawshank Redemption is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "The Truman Show", subtitle: "Film · Comedy-drama · 1998", imageName: "Poster15", rating: 4, description: "The Truman Show is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "The Office", subtitle: "Series · Workplace comedy · 2005", imageName: "Poster16", rating: 5, description: "The Office is a memorable series with distinctive characters and a strong atmosphere. Its story develops through engaging episodes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Peaky Blinders", subtitle: "Series · Period crime drama · 2013", imageName: "Poster17", rating: 4, description: "Peaky Blinders is a memorable series with distinctive characters and a strong atmosphere. Its story develops through engaging episodes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Stranger Things", subtitle: "Series · Sci-fi mystery · 2016", imageName: "Poster18", rating: 4, description: "Stranger Things is a memorable series with distinctive characters and a strong atmosphere. Its story develops through engaging episodes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Spider-Man: No Way Home", subtitle: "Film · Superhero · 2021", imageName: "Poster19", rating: 5, description: "Spider-Man: No Way Home is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting."),
        FavoriteItem(title: "Guardians of the Galaxy", subtitle: "Film · Space adventure · 2014", imageName: "Poster20", rating: 4, description: "Guardians of the Galaxy is a memorable film with distinctive characters and a strong atmosphere. Its story develops through engaging scenes and meaningful choices. The performances and visual style make it worth revisiting.")
    ]
}

final class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: animated)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavoritesLibrary.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        guard let favoriteCell = cell as? FavoriteCell else { return cell }
        favoriteCell.configure(with: FavoritesLibrary.items[indexPath.row])
        return favoriteCell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
              let detail = segue.destination as? DetailViewController,
              let selected = tableView.indexPathForSelectedRow else { return }
        detail.item = FavoritesLibrary.items[selected.row]
    }
}
