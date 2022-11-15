//
//  DetailViewController.swift
//  RepositoryInfoFetcher
//
//  Created by CM on 14/11/2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var repositoryNameString = ""
    var ownerNameString = ""
    var userImageString = ""
    var repositoryURLString = ""
    var repositoryDetailsString = "Details data are empty"
    var detailViewColor: UIColor = .white

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userimageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryDetailsLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!

    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func openWebsiteTapped(_ sender: Any) {
        if let url = URL(string: repositoryURLString) {
            UIApplication.shared.open(url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = detailViewColor
        repoNameLabel.text = repositoryNameString
        ownerNameLabel.text = ownerNameString
        repositoryDetailsLabel.text = repositoryDetailsString
        websiteButton.layer.cornerRadius = 10
        websiteButton.layer.borderWidth = 2
        websiteButton.layer.borderColor = websiteButton.currentTitleColor.cgColor
        guard let imageURL = URL(string: userImageString) else { return }
        let data = try? Data(contentsOf: imageURL)
        userimageView.image =  UIImage(data: data ?? Data())
    }
}
