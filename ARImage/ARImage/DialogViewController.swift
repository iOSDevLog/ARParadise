//
//  DialogViewController.swift
//  ARImage
//
//  Created by ios dev on 2019/2/28.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    let screens = ["iPhoneX1", "iPhoneX2", "iPhoneX3"]
    let titles = ["Wallpaper", "Home", "Chapters"]
    let images = ["ARScreen1", "ARScreen2", "ARScreen3"]

    var delegate: DialogViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension DialogViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenCell", for: indexPath) as! DialogCollectionViewCell

        cell.screenImageButton.setImage(UIImage(named: screens[indexPath.row]), for: .normal)
        cell.screenLabel.text = titles[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self

        return cell
    }

}

extension DialogViewController: DialogCollectionViewCellDelegate {

    func screenImageButtonTapped(index: Int) {
        dismiss(animated: true, completion: nil)
        delegate?.screenImageButtonTapped(image: UIImage(named: images[index])!)
    }

}

protocol DialogViewControllerDelegate {
    func screenImageButtonTapped(image: UIImage)
}
