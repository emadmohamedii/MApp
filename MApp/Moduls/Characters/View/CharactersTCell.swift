//
//  CharactersTCell.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import UIKit
import Kingfisher

enum CharactersTableCells :String{
    case CharactersTCell
}

class CharactersTCell: UITableViewCell {
    @IBOutlet weak var charImgV:UIImageView!
    @IBOutlet weak var charNameLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(char:CharactersResultModel) {
        self.charNameLbl.text = char.name
        self.charImgV.downloadImageWithCaching(with: char.thumbnail?.fullImage ?? "",placeholderImage: UIImage(named: "test"))
    }
}
