//
//  TaskCell.swift
//  RealmApp
//
//  Created by Артем Пашевич on 16.09.22.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var imageMark: UIImageView!
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var noteTask: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMark.image = #imageLiteral(resourceName: "unmark")
    }
}
