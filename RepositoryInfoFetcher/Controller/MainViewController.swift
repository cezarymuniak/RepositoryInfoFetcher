//
//  ViewController.swift
//  RepositoryInfoFetcher
//
//  Created by CM on 12/11/2022.
//

import UIKit
import MASegmentedControl
import Alamofire
import CoreData // TODO - save fetched data


class MainViewController: UITableViewController {
    var githubData = GithubModel()
    var bitbucketData = BitbucketModel(values: [])
    var cellHeights: [CGFloat] = []
    var sortedGithubData: GithubModel = []
    var sortedBitbucketData = BitbucketModel( values: [])
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let connectionAlert = UIAlertController(title: "Connection Error", message: "Please check your internet connectiom", preferredStyle: .actionSheet)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SegmentControlHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SegmentControlHeaderView")
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        connectionAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true)
        }))
        fetchData()
    }
    
    
    @IBOutlet weak var sortButton: UISwitch!
    @IBAction func sortButtonTapped(_ sender: Any) {
        addLoader()
        if sortButton.isOn {
            sortedGithubData = githubData.sorted(by: { $0.name < $1.name })
            sortedBitbucketData.values =    bitbucketData.values.sorted(by: { $0.name < $1.name })
        }
        refreshHandler()
    }
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        sortButton.isOn = false
        if imagesSegmentedControl.selectedSegmentIndex == 0 {
            fetchData()
        } else {
            fetchBitbucketData()
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
            imagesSegmentedControl.thumbViewColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imagesSegmentedControl.bounds.size = CGSize(width: 150.0, height: 50.0)
        }
    }
    
    // MARK: Helpers
    func setup() {
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
        self.tableView.reloadData()
    }
    
    public func fetchGithubRepositories(completion: @escaping ((GithubModel) -> Void)) {
        let url = "https://api.github.com/repositories"
        AF.request(url, method: .get)
            .responseDecodable(of: GithubModel.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data)
                    print(data)
                case .failure(let error):
                    self.presentInternetError()
                    print(error)
                }
            }
    }
    
    public func fetchBitbucketRepositories(completion: @escaping ((BitbucketModel) -> Void)) {
        let url = "https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description"
        AF.request(url, method: .get)
            .responseDecodable(of: BitbucketModel.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data)
                    self.refreshHandler()
                    print(data)
                case .failure(let error):
                    self.presentInternetError()
                    print(error)
                }
            }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
        self.alert.dismiss(animated: true)
    }
    
    func addLoader() {
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func presentInternetError() {
        self.alert.dismiss(animated: true)
        present(connectionAlert, animated: true, completion: nil)
    }
    
    func fetchData() {
        addLoader()
        fetchGithubRepositories { [self] data in
            
            guard let limitedData = data.split(into: 10).first else { return }
            githubData.append(contentsOf: limitedData)
            self.setup()
            alert.dismiss(animated: true)
        }
    }
    
    func fetchBitbucketData() {
        addLoader()
        self.fetchBitbucketRepositories { data in
            self.bitbucketData.values.append(contentsOf: data.values)
            self.refreshHandler()
            self.alert.dismiss(animated: true)
            
        }
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as? MainViewCell else { return UITableViewCell() }
        
        if imagesSegmentedControl.selectedSegmentIndex == 0  {
            var githubCellData: GithubModel = []
            if sortButton.isOn {
                githubCellData = sortedGithubData
            } else {
                githubCellData = githubData
            }
            
            cell.userNameLabel.text = githubCellData[indexPath.row].owner.login
            cell.repositoryNameLabel.text = githubCellData[indexPath.row].name
            
            let imageURL = URL(string: githubCellData[indexPath.row].owner.avatarURL.description) ?? URL(fileURLWithPath: "")
            let data = try? Data(contentsOf: imageURL)
            cell.userAvatarImageView.makeRounded()
            cell.userAvatarImageView.image = UIImage(data: data ?? Data())
            cell.foregroundView.backgroundColor =  UIColor(red: 0.35, green: 0.51, blue: 0.34, alpha: 1.00)
            cell.userAvatarImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            var bitbucketCellData = BitbucketModel( values: [])

            if sortButton.isOn {
                bitbucketCellData = sortedBitbucketData
            } else {
                bitbucketCellData = bitbucketData
            }
            
            cell.userNameLabel.text = bitbucketCellData.values[indexPath.row].name
            cell.repositoryNameLabel.text = bitbucketCellData.values[indexPath.row].name
            
            let imageURL = URL(string: bitbucketCellData.values[indexPath.row].owner.links.avatar.href) ?? URL(fileURLWithPath: "")
            let data = try? Data(contentsOf: imageURL)
            cell.userAvatarImageView.makeRounded()
            cell.userAvatarImageView.image = UIImage(data: data ?? Data())
            cell.foregroundView.backgroundColor = .white
            cell.userAvatarImageView.layer.borderColor = UIColor.black.cgColor
        }
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var githubCellData: GithubModel = []
        var bitbucketCellData = BitbucketModel( values: [])
        
        if sortButton.isOn {
            githubCellData = sortedGithubData
            bitbucketCellData = sortedBitbucketData
        } else {
            githubCellData = githubData
            bitbucketCellData = bitbucketData
        }
        
        let storyboard = UIStoryboard.init(name: "DetailViewController", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if imagesSegmentedControl.selectedSegmentIndex == 0  {
            detailViewController.detailViewColor = .clear
            detailViewController.repositoryNameString  = "Repository name:  \(githubCellData[indexPath.row].name)"
            detailViewController.ownerNameString  = "Owner name:  \(githubCellData[indexPath.row].owner.login)"
            detailViewController.repositoryDetailsString  =  githubCellData[indexPath.row].githubModelDescription ?? "Details data are empty"
            detailViewController.userImageString  = githubCellData[indexPath.row].owner.avatarURL.description
            detailViewController.repositoryURLString = githubCellData[indexPath.row].owner.htmlURL
        } else {
            detailViewController.detailViewColor = .gray
            detailViewController.repositoryNameString  = "Repository name:  \(bitbucketCellData.values[indexPath.row].name)"
            detailViewController.ownerNameString  = "Owner name:  \(bitbucketCellData.values[indexPath.row].owner.displayName)"
            if bitbucketCellData.values[indexPath.row].valueDescription != "" {
                detailViewController.repositoryDetailsString = bitbucketCellData.values[indexPath.row].valueDescription
            }
            detailViewController.userImageString  = bitbucketCellData.values[indexPath.row].owner.links.avatar.href
            detailViewController.repositoryURLString = bitbucketCellData.values[indexPath.row].owner.links.html.href
        }
        present(detailViewController, animated: true, completion: nil)
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch imagesSegmentedControl.selectedSegmentIndex {
        case  0:
            return githubData.count
        case 1:
            return bitbucketData.values.count
        default:
            return githubData.count
        }
    }
}

class MainViewCell: UITableViewCell {
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var foregroundView: UIView!
}

// MARK: Extensions
extension UIImageView {
    
    func makeRounded() {
        layer.borderWidth = 3
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension Array {
    func split(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
