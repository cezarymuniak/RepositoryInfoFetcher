//
//  ViewController.swift
//  RepositoryInfoFetcher
//
//  Created by CM on 11/11/2022.
//

import UIKit
import MASegmentedControl
import FoldingCell
import Alamofire
import CoreData

enum Repo {
    case github
    case bitbucket
}
enum Const {
    static let closeCellHeight: CGFloat = 179
    static let openCellHeight: CGFloat = 488
    static var rowsCount = 10
}
class MainViewController: UITableViewController {
    var repoType: Repo? = .github
    var githubData = GithubModel()
    var bitbucketData = BitbucketModel( values: [])
    let defaults = UserDefaults.standard
    public static let shared = MainViewController()
    var currentSegment = 0
    var cellHeights: [CGFloat] = []//(0..<CELLCOUNT).map { _ in C.CellHeight.close }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        fetchBitbucketData()
    }
    
    
    // MARK: Helpers
    func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(false, forKey: "valueChanged")
        tableView.register(UINib(nibName: "SegmentControlHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SegmentControlHeaderView")
    }
    
    
    func fetchData() {
        fetchGithubRepositories { [self] data in
            Const.rowsCount = data.count
            self.cellHeights =  (0..<data.count).map { _ in Const.closeCellHeight }
            guard let limitedData = data.split(into: 10).first else { return }
            githubData.append(contentsOf: limitedData)
            self.setup()
        }
    }
    
    func fetchBitbucketData() {
        self.fetchBitbucketRepositories { data in
            Const.rowsCount = data.values.count
            self.cellHeights =  (0..<data.values.count).map { _ in Const.closeCellHeight }
            self.bitbucketData.values.append(contentsOf: data.values)
            self.setup()
        }
        
    }
    
    func reloadView() {
        tableView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        if  defaults.bool(forKey: "valueChanged") == true {
            self.refreshHandler()
        }
        defaults.set(false, forKey: "valueChanged")
    }
    
    
    override func reloadInputViews() {
        githubData.sort {
            $0.name > $1.name
        }
        self.tableView.beginUpdates()
        super.reloadInputViews()
        reloadView()
        setup()
        refreshHandler()
        self.tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "SegmentControlHeaderView") as! SegmentControlHeaderView
        view.tintColor = UIColor.clear
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        view.backgroundView = backgroundView
        currentSegment =   view.imagesSegmentedControl.selectedSegmentIndex
        
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch repoType {
        case  .github:
            return githubData.count//10
        case .bitbucket:
            return bitbucketData.values.count ?? 0//10
        default:
            return githubData.count
        }
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as InfoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        if self.currentSegment == 0  {
            cell.repositoryNameLabel.text = githubData[indexPath.row].name
            cell.userNameLabel.text = githubData[indexPath.row].owner.login
            guard let imageURL = URL(string: githubData[indexPath.row].owner.avatarURL) else { return }
            let data = try? Data(contentsOf: imageURL)
            cell.repositoryImageView.makeRounded()
            cell.userDetailsImageView.makeRounded()
            cell.repositoryImageView.image = UIImage(data: data ?? Data())
            cell.userDetailsImageView.image = UIImage(data: data ?? Data())
            cell.userDetailsNameLabel.text = githubData[indexPath.row].name
            cell.userDetailsIdLabel.text = String(githubData[indexPath.row].id)
            cell.userDetailsTypeLabel.text = githubData[indexPath.row].owner.type.rawValue
            cell.userDetailsRepositoryURL.text = String(githubData[indexPath.row].url)
        } else {
            cell.repositoryNameLabel.text = bitbucketData.values[indexPath.row].name
            cell.userNameLabel.text = bitbucketData.values[indexPath.row].name ?? ""
            guard let imageURL = URL(string: bitbucketData.values[indexPath.row].owner.links.avatar.href ) else { return }
            let data = try? Data(contentsOf: imageURL)
            cell.repositoryImageView.makeRounded()
            cell.userDetailsImageView.makeRounded()
            cell.repositoryImageView.image = UIImage(data: data ?? Data())
            cell.userDetailsImageView.image = UIImage(data: data ?? Data())
            cell.userDetailsNameLabel.text = bitbucketData.values[indexPath.row].name
            cell.userDetailsIdLabel.text = bitbucketData.values[indexPath.row].owner.accountID
            cell.userDetailsTypeLabel.text = bitbucketData.values[indexPath.row].owner.type.rawValue
            cell.userDetailsRepositoryURL.text = bitbucketData.values[indexPath.row].owner.links.html.href
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


class InfoCell: FoldingCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDetailsImageView: UIImageView!
    @IBOutlet weak var userDetailsNameLabel: UILabel!
    @IBOutlet weak var userDetailsIdLabel: UILabel!
    @IBOutlet weak var userDetailsTypeLabel: UILabel!
    @IBOutlet weak var bottomContainerView: RotatedView!
    @IBOutlet weak var userDetailsRepositoryURL: UILabel!
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
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
