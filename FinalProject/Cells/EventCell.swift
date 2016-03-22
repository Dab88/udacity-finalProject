//
//  EventCell.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/22/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(event: Event){
        self.name.text = event.name
        self.date.text = event.date!.stringFromDateInLocalFormat()
    }

}
