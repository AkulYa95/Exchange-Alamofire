//
//  TableViewCell.swift
//  Exchange Alamofire
//
//  Created by Ярослав Акулов on 12.11.2021.
//

import UIKit
import Darwin

class TableViewCell: UITableViewCell {

    @IBOutlet weak var charCodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var progressionImage: UIImageView!
    
    func cellConfigure(with valute: [String: ValuteDescription],_ keys: [String],_ index: Int){
        let key = keys[index]
        charCodeLabel.text = valute[key]?.charCode
        nameLabel.text = valute[key]?.name
        guard let nominal = valute[key]?.nominal else { return }
        guard let value = valute[key]?.value else { return }
        guard let previousValue = valute[key]?.previousValue else { return }
        var absValue = value / Double(nominal)
        absValue = round(absValue * 1000) / 1000
        valueLabel.text = String(absValue)
        
        
        if value > previousValue {
            progressionImage.tintColor = .systemGreen
            progressionImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        } else if value < previousValue {
            progressionImage.tintColor = .systemRed
            progressionImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        
    }

}
