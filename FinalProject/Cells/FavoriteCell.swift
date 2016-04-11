//
//  FavoriteCell.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 4/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

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
    
    func setup(product: Product){
        
        name.text = product.name
        price.text = product.price! + product.currency!
        
        let url = NSURL(string: product.imageUrl!)
        
        imageProduct.downloadImage(url!)
    }


}
