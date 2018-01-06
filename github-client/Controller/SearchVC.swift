//
//  SearchVC.swift
//  github-client
//
//  Created by Michael Alexander on 1/3/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: RoundedBorderTextField!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindElements()
    }
    
    private func bindElements() {
        let searchResultsObservable = searchField.rx.text
            .orEmpty.debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            }
            .flatMap { (query) -> Observable<[Repo]> in
                if query == "" {
                    return Observable<[Repo]>.just([])
                } else {
                    let url = URL(string: searchUrl + query + starsDesceningSegment)
                    var searchRepos = [Repo]()
                    
                    return URLSession.shared.rx.json(url: url!).map {
                        let results = $0 as AnyObject
                        let items = results.object(forKey: "items") as? [[String: Any]] ?? []
                        
                        for item in items {
                            guard let name = item["name"] as? String,
                            let description = item["description"] as? String,
                            let language = item["language"] as? String,
                            let forksCount = item["forks_count"] as? Int,
                            let repoUrl = item["html_url"] as? String else { break }
                            
                            let repo = Repo(image: UIImage(named: "searchIconLarge")!, name: name, description: description, numberOfForks: forksCount, language: language, numberOfContributors: 0, repoUrl: repoUrl)
                            
                            searchRepos.append(repo)
                        }
    
                        return searchRepos
                    }
                }
            }
            .observeOn(MainScheduler.instance)
        
        searchResultsObservable.bind(to: tableView.rx.items(cellIdentifier: "searchCell")) { (row, repo: Repo, cell: SearchCell) in
            cell.configureCell(repo: repo)
        }
        .disposed(by: disposeBag)
    }
}
