//
//  DownloadService.swift
//  github-client
//
//  Created by Michael Alexander on 1/4/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class DownloadService {
    static let instance = DownloadService()
    
    func donwloadTrendingReposDictArray(completion: @escaping (_ repoDictArray: [[String: Any]]) -> Void) {
        var trendingReposArray = [[String: Any]]()
        Alamofire.request(trendingRepoUrl).responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else { return }
            guard let repoDictionaryArray = json["items"] as? [[String: Any]] else { return }
            
            for repoDict in repoDictionaryArray {

                guard let name = repoDict["name"] as? String,
                        let description = repoDict["description"] as? String,
                        let numberOfForks = repoDict["forks_count"] as? Int,
                        let language = repoDict["language"] as? String,
                        let repoUrl = repoDict["html_url"] as? String,
                        let contributorsUrl = repoDict["contributors_url"] as? String,
                        let ownerDict = repoDict["owner"] as? [String: Any],
                        let avatarUrl = ownerDict["avatar_url"] as? String else { break }
                    
                    let repoDictionary: [String: Any] = ["name": name, "description": description, "forks_count": numberOfForks, "language": language, "html_url": repoUrl, "contributors_url": contributorsUrl, "avatar_url": avatarUrl]

                    trendingReposArray.append(repoDictionary)

            }
            completion(trendingReposArray)
        }
    }
    
    func downloadTrendingRepos(completion: @escaping (_ reposArray: [Repo]) -> Void) {
        var reposArray = [Repo]()
        donwloadTrendingReposDictArray { (trendingReposDictArray) in
            for dict in trendingReposDictArray {
                self.downloadTrendingRepo(formDictionary: dict, completion: { (returnedRepo) in
                    if reposArray.count != trendingReposDictArray.count - 1 {
                    //if reposArray.count < 9 {
                        reposArray.append(returnedRepo)
                    } else {
                   // } else {
                        let sortedArray = reposArray.sorted(by: { (repoA, repoB) -> Bool in
                            if repoA.numberOfForks > repoB.numberOfForks {
                                return true
                            } else {
                                return false
                            }
                        })
                        completion(sortedArray)
                    }
                    //}
                })
            }
        }
        
    }
    
    func downloadTrendingRepo(formDictionary dict: [String: Any], completion: @escaping (_ repo: Repo) -> Void){
        let avatarUrl = dict["avatar_url"] as! String
        let contributorsUrl = dict["contributors_url"] as! String
        let name = dict["name"] as! String
        let description = dict["description"] as! String
        let numberOfForks = dict["forks_count"] as! Int
        let language = dict["language"] as! String
        let repoUrl = dict["html_url"] as! String
        
        downloadImageFor(avatarUrl: avatarUrl) { (returnedImage) in
            self.downloadContributorsDataFor(contributorsUrl: contributorsUrl, completion: { (returnedContributers) in
                let repo = Repo(image: returnedImage, name: name, description: description, numberOfForks: numberOfForks, language: language, numberOfContributors: returnedContributers, repoUrl: repoUrl)
                completion(repo)
            })
        }
    }
    
    func downloadImageFor(avatarUrl: String, completion: @escaping (_ image: UIImage) -> Void) {
        Alamofire.request(avatarUrl).responseImage { (imageResponse) in
            guard let image = imageResponse.result.value else { return }
            completion(image)
        }
    }
    
    func downloadContributorsDataFor(contributorsUrl: String, completion: @escaping (_ contributors: Int) -> Void) {
        Alamofire.request(contributorsUrl).responseJSON { (response) in
            guard let json = response.result.value as? [[String: Any]] else { return }
            if !json.isEmpty {
                let contributions = json.count
                completion(contributions)
            }
        }
    }
}
