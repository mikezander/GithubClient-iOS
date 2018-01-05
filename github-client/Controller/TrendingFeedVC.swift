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
    
    var dataSource = PublishSubject<[Repo]>()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        bindDataToTableView()
    }

    private func fetchData() {
        DownloadService.instance.downloadTrendingRepos { (trendingRepoArray) in
            self.dataSource.onNext(trendingRepoArray)
        }
    }
    
    private func bindDataToTableView() {
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "trendingRepoCell")) { (row, repo: Repo, cell: TrendingRepoCell) in
            cell.configureCell(repo: repo)
            }.disposed(by: disposeBag)
    }
}

