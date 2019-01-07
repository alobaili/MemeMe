//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Abdulaziz AlObaili on 22/11/2018.
//  Copyright © 2018 Abdulaziz Alobaili. All rights reserved.
//
import Foundation
import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Used to identify which textField the user is currently editing
    var currentTextField: UITextField?
    
    var meme: Meme!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the text centered inside the meme text field
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        // Setup textfield attributes
        let memeTextAttributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.white, .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, .strokeWidth: -4, .paragraphStyle: paragraph]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Hide the navigation bar because "Cancel" button is used to go back to sent memes
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        // bring back the navigation bar before popping the view
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Return to sent memes when "Cancel" button is pressed
    @IBAction func returnToSentMemes() {
        // Pop the editor when the cancel button is pressed
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Keyboard behaviour
    @objc func keyboardWillShow(_ notification:Notification) {
        
        // Move view only if currentTextField is bottomTextField.
        // I used tags to identify textfields.
        if currentTextField?.tag == 1 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Keyboard Notifications (subscribtions)
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: Creating and Saving the Meme
    func save(){
        
        // Update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Hide/Unhide top & bottom toolbars
    func prepareUI(isGeneratingMemedImage: Bool) {
        bottomToolbar.isHidden = isGeneratingMemedImage
        topToolbar.isHidden = isGeneratingMemedImage
        self.navigationController?.setNavigationBarHidden(isGeneratingMemedImage, animated: false)
    }
    
    // MARK: Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        prepareUI(isGeneratingMemedImage: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        prepareUI(isGeneratingMemedImage: false)
        
        return memedImage
    }
    
    // MARK: Share Meme
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard completed else {
                // User canceled
                return
            }
            // User completed activity
            self.save()
        }
        
        present(controller, animated: true, completion: nil)
    }
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Camera and Album actions
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        
        // I used the UIBarButtonItem tag to identify the sender (Camera or Album) ant set the sourceType accordingly
        if sender.tag == 0 {
            pickerController.sourceType = .camera
        } else {
            pickerController.sourceType = .photoLibrary
        }
        
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    // MARK: TextField behaviour
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
