import UIKit

final class FavoriteCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(with item: FavoriteItem) {
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.isOpaque = false
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = UIColor(red: 0.09, green: 0.12, blue: 0.17, alpha: 1)
        titleLabel.text = item.title
    }
}
