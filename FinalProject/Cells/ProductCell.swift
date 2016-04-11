//
//  ProductCell.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/30/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    

    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var price: UILabel!
   
    class var identifier: String { return String.className(self) }
    var product:Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(item: Item){
        
        product = item
        
        name.text = item.title
        price.text = item.price! + item.currency!

        let url = NSURL(string: item.galleryURL!)
        
        imageProduct.downloadImage(url!)
        
        favoriteBtn.selected = PersistenceManager.instance.productIsFavorite(item.viewItemURL!)
    }
    
    
    @IBAction func saveFavorite(sender: AnyObject) {
        
        if(favoriteBtn.selected){
            PersistenceManager.instance.deleteProduct(product!.viewItemURL!)
        }else{
            PersistenceManager.instance.saveProduct(product!)
        }
        
        favoriteBtn.selected = !favoriteBtn.selected
    }
    
    
}
