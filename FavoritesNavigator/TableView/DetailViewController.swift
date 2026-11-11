import UIKit

final class DetailViewController: UIViewController {
    var item: FavoriteItem?

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var star1: UIImageView!
    @IBOutlet private weak var star2: UIImageView!
    @IBOutlet private weak var star3: UIImageView!
    @IBOutlet private weak var star4: UIImageView!
    @IBOutlet private weak var star5: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        guard let item else { return }
        title = item.title
        posterImageView.image = UIImage(named: item.imageName)
        // Appearance only; all layout constraints stay in Main.storyboard.
        for label in [titleLabel, subtitleLabel, descriptionLabel] {
            label?.isOpaque = false
            label?.backgroundColor = .clear
            label?.textColor = UIColor(red: 0.09, green: 0.12, blue: 0.17, alpha: 1)
        }
        subtitleLabel.textColor = UIColor(red: 0.36, green: 0.40, blue: 0.46, alpha: 1)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description
        let stars = [star1, star2, star3, star4, star5]
        for (index, star) in stars.enumerated() {
            star?.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
            star?.tintColor = .systemOrange
        }
    }
}
