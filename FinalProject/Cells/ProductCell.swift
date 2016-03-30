//
//  ProductCell.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/30/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: Item){
        
        name.text = item.title
        price.text = item.price! + item.currency!

        let url = NSURL(string: item.galleryURL!)
        
        imageProduct.downloadImage(url!)
    }
}
