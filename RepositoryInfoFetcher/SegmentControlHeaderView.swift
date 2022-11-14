//
//  SegmentControlHeaderView.swift
//  RepositoryInfoFetcher
//
//  Created by CM on 12/11/2022.
//

import Foundation
import UIKit
import MASegmentedControl

class SegmentControlHeaderView: UITableViewHeaderFooterView {
    
    let defaults = UserDefaults.standard
    var cellHeights: [CGFloat] = []
    var githubData = GithubModel()
    public static let shared = SegmentControlHeaderView()
    var repoType2: Int?
    var gites = MainViewController.shared
    var githubDataaa: GithubModel = []
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        gites.githubData.sort {
            $0.name > $1.name
        }
        MainViewController.shared.reloadInputViews()
    }
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        defaults.set(true, forKey: "valueChanged")
        
        if imagesSegmentedControl.selectedSegmentIndex == 0 {
            MainViewController.shared.fetchData()
        } else {
            repoType2 = 1
            MainViewController.shared.fetchBitbucketData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            }
        }
    }
    
    @IBOutlet weak var imagesSegmentedControl: MASegmentedControl! {
        didSet {
            
            imagesSegmentedControl.fillEqually = false
            imagesSegmentedControl.buttonsWithDynamicImages = true
            imagesSegmentedControl.roundedControl = true
            
            let images = ContentDataSource.imageItems()
            imagesSegmentedControl.setSegmentedWith(items: images)
            imagesSegmentedControl.padding = 2
            imagesSegmentedControl.thumbViewColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            imagesSegmentedControl.bounds.size = CGSize(width: 150.0, height: 50.0)
        }
    }
}
