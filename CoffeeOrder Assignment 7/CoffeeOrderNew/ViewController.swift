import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var sizeSmallButton: UIButton!
    @IBOutlet private weak var sizeMediumButton: UIButton!
    @IBOutlet private weak var sizeLargeButton: UIButton!
    @IBOutlet private weak var orderButton: UIButton!

    private let prices = [1500, 1800, 2100]
    private var selectedSize = 1
    private var quantity = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Only data and appearance updates. All layout constraints are in Main.storyboard.
        titleLabel.text = "Flat White"
        descriptionLabel.text = "Double ristretto with silky steamed milk. Smooth, strong and not too sweet."
        [sizeSmallButton, sizeMediumButton, sizeLargeButton, orderButton].forEach {
            $0?.layer.cornerRadius = 12
            $0?.clipsToBounds = true
        }
        updateDisplay()
    }

    @IBAction private func quantityChanged(_ sender: UIStepper) {
        quantity = Int(sender.value)
        updateDisplay()
    }

    @IBAction private func sizeTapped(_ sender: UIButton) {
        if sender === sizeSmallButton { selectedSize = 0 }
        else if sender === sizeMediumButton { selectedSize = 1 }
        else if sender === sizeLargeButton { selectedSize = 2 }
        updateDisplay()
    }

    @IBAction private func orderTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Added to order", message: "\(quantity) × \(titleLabel.text ?? "Coffee") — \(priceString(prices[selectedSize] * quantity))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func updateDisplay() {
        priceLabel.text = priceString(prices[selectedSize])
        quantityLabel.text = "\(quantity)"
        orderButton.setTitle("Add to order · \(priceString(prices[selectedSize] * quantity))", for: .normal)
        let buttons: [UIButton] = [sizeSmallButton, sizeMediumButton, sizeLargeButton]
        for (index, button) in buttons.enumerated() {
            button.backgroundColor = index == selectedSize
                ? UIColor(red: 0.91, green: 0.84, blue: 0.76, alpha: 1)
                : .white
            button.setTitleColor(UIColor(red: 0.30, green: 0.19, blue: 0.13, alpha: 1), for: .normal)
            button.accessibilityTraits = index == selectedSize ? [.button, .selected] : .button
        }
    }

    private func priceString(_ amount: Int) -> String {
        "₸" + amount.formatted(.number.grouping(.automatic))
    }
}
