//
//  UIViewControllerExt.swift
//  github-client
//
//  Created by Michael Alexander on 1/7/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

    func presentSFSafariVCFor(url: String) {
        guard let readmeUrl = URL(string: url + readmeSegment) else { return }
        let safariVC = SFSafariViewController(url: readmeUrl)
        present(safariVC, animated: true, completion: nil)
    }
    
    
}
