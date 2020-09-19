//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Abdulaziz AlObaili on 08/12/2018.
//  Copyright © 2018 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
}

extension MemeTableViewController {
    
    // MARK: Required functions for TableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellID = "MemeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath) as! MemeTableViewCell
        cell.memeImageView.image = memes[indexPath.row].memedImage
        cell.topLabel.text = memes[indexPath.row].topText
        cell.bottomLabel.text = memes[indexPath.row].bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let editorController = storyboard?.instantiateViewController(
            withIdentifier: "MemeDetailViewController"
        ) as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        editorController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(editorController, animated: true)
    }
    
    // MARK: Custom Height for row
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 104.00
    }
    
    
}
