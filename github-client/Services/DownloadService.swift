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
    
    func donwloadTrendingReposDictArray(completion: @escaping (_ repoDictArray: [[String: Any]]) -> ()) {
        var trendingReposArray = [[String: Any]]()
        Alamofire.request(trendingRepoUrl).responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else { return }
            guard let repoDictionaryArray = json["items"] as? [[String: Any]] else { return }
            
            for repoDict in repoDictionaryArray {
                if trendingReposArray.count <= 10 {
                    trendingReposArray.append(repoDict)
                } else {
                    break
                }
            }
            completion(trendingReposArray)
        }
  
    }
}
