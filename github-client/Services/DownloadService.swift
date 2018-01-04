//
//  DownloadService.swift
//  github-client
//
//  Created by Michael Alexander on 1/4/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import Foundation
import Alamofire

class DownloadService {
    static let instance = DownloadService()
    
    func donwloadTrendingReposDictArray(completion: @escaping (_ repoDictArray: [[String: Any]]) -> Void) {
        var trendingReposArray = [[String: Any]]()
        Alamofire.request(trendingRepoUrl).responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else { return }
            guard let repoDictionaryArray = json["items"] as? [[String: Any]] else { return }
            
            for repoDict in repoDictionaryArray {
                if trendingReposArray.count <= 9 {
                    trendingReposArray.append(repoDict)
                } else {
                    break
                }
            }
            completion(trendingReposArray)
        }
    }
    
    func downloadTrendingRepos(completion: @escaping (_ reposArray: [Repo]) -> Void) {
        var reposArray = [Repo]()
        donwloadTrendingReposDictArray { (trendingReposDictArray) in
            for dict in trendingReposDictArray {
                let repo = self.downloadTrendingRepo(formDictionary: dict)
                reposArray.append(repo)
            }
            completion(reposArray)
        }
    }
    
    func downloadTrendingRepo(formDictionary dict: [String: Any]) -> Repo {
        //let avatarUrl = dict["avatar_url"] as! String
        let name = dict["name"] as! String
        let description = dict["description"] as! String
        let numberOfForks = dict["forks_count"] as! Int
        let language = dict["language"] as! String
        let repoUrl = dict["html_url"] as! String
        
        let repo = Repo(image: UIImage(named: "searchIconLarge")! , name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: 123, repoUrl: repoUrl)
        
        return repo
    }
}
