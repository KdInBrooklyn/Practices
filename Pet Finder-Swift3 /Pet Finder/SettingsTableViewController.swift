

import UIKit

class SettingsTableViewController: UITableViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var themeSelector: UISegmentedControl!
  @IBOutlet weak var applyButton: UIButton!
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissAnimated))
    
    themeSelector.selectedSegmentIndex = Theme.current.rawValue
  }
}

// MARK: - Actions
private extension SettingsTableViewController {
  
  @objc func dismissAnimated() {
    dismiss(animated: true)
  }
  
  @IBAction func applyTheme(_ sender: UIButton) {
    if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
      selectedTheme.apply()
    }
    
    dismissAnimated()
  }
}
