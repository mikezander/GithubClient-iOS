//
//  TrendingFeedVC.swift
//  github-client
//
//  Created by Michael Alexander on 1/3/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import UIKit

class TrendingFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        DownloadService.instance.downloadTrendingRepos { (reposArray) in
            for repo in reposArray {
                print(repo.name)
                print("\(repo.description)\n")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trendingRepoCell", for: indexPath) as? TrendingRepoCell  else { return UITableViewCell() }
        
        let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: "Swift", description: "Apple's programming language", numberOfForks: 355, language: "C++", numberOfContributors: 562, repoUrl: "www.google.com")
        
        cell.configureCell(repo: repo)
        return cell
    }
}

