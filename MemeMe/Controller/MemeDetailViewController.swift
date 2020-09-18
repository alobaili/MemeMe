//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Abdulaziz AlObaili on 24/12/2018.
//  Copyright © 2018 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeImage.image = meme.memedImage
    }
    
    
}
