//
//  TrendingFeedVC.swift
//  github-client
//
//  Created by Michael Alexander on 1/3/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrendingFeedVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var dataSource = PublishSubject<[Repo]>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureRefreshControl()
        tableView.refreshControl = refreshControl
        fetchData()
        bindDataToTableView()
    }

    @objc private func fetchData() {
        DownloadService.instance.downloadTrendingRepos { (trendingRepoArray) in
            self.dataSource.onNext(trendingRepoArray)
            self.refreshControl.endRefreshing()
        }
    }
    
    private func bindDataToTableView() {
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "trendingRepoCell")) { (row, repo: Repo, cell: TrendingRepoCell) in
            cell.configureCell(repo: repo)
            }.disposed(by: disposeBag)
    }
    
    private func configureRefreshControl(){
        refreshControl.tintColor = #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching trending Github Repos 🔥", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1), NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 16.0)!])
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
}

