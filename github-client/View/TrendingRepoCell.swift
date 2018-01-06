//
//  TrendingRepoCell.swift
//  github-client
//
//  Created by Michael Alexander on 1/4/18.
//  Copyright © 2018 Michael Alexander. All rights reserved.
//

import UIKit

class TrendingRepoCell: UITableViewCell {

    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var repoDescriptionLbl: UILabel!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var numberOfForksLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var contributorsLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewReadMeBtn: RoundedBorderButton!
    
    private var repoUrl: String?
    
    func configureCell(repo: Repo) {
        repoImageView.image = repo.image
        repoNameLbl.text = repo.name
        repoDescriptionLbl.text = repo.description
        numberOfForksLbl.text = String(repo.numberOfForks)
        languageLbl.text = repo.language
        contributorsLbl.text = String(repo.numberOfContributors)
        repoUrl = repo.repoUrl
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.cornerRadius = 15
        backView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 5.0
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
