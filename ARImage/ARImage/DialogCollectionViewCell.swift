//
//  DialogCollectionViewCell.swift
//  ARImage
//
//  Created by ios dev on 2019/2/28.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import UIKit

class DialogCollectionViewCell: UICollectionViewCell {

    var delegate: DialogCollectionViewCellDelegate?
    var index = 0

    @IBOutlet weak var screenImageButton: UIButton!
    @IBOutlet weak var screenLabel: UILabel!
    @IBAction func screenImageButtonTapped(_ sender: Any) {
        delegate?.screenImageButtonTapped(index: index)
    }

}

protocol DialogCollectionViewCellDelegate {
    func screenImageButtonTapped(index: Int)
}
