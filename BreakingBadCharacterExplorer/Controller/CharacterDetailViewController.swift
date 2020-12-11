//
//  DetailViewController.swift
//  BreakingBadCharacterExplorer
//
//  Created by Sharaf Nazaar on 12/10/20.
//

import Foundation
import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {
 
    @IBOutlet weak var charImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var selectedCharacter : Character!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedCharacter != nil) {
            nameLabel.text = selectedCharacter.name
            nicknameLabel.text = selectedCharacter.nickname
            statusLabel.text = selectedCharacter.status
            occupationLabel.text = selectedCharacter.occupation.joined(separator: ", ")
            
            if ((selectedCharacter.appearance) != nil) {
                let appearanceInfo = selectedCharacter.appearance!.map { String($0) }
                seasonLabel.text = appearanceInfo.joined(separator: ", ")
            }
            
            let sizeTransformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 400),scaleMode: .aspectFill)
            let roundCornerTransformer = SDImageRoundCornerTransformer(radius: 40, corners: .allCorners, borderWidth: 2.0, borderColor: UIColor.clear)
            let pipeLineTransformer = SDImagePipelineTransformer(transformers: [sizeTransformer, roundCornerTransformer])
            charImageView.sd_setImage(with: URL(string: selectedCharacter.img), placeholderImage: UIImage(named: "placeholder"), context: [.imageTransformer : pipeLineTransformer])
        }
    }
}
