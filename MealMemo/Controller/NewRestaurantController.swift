//
//  NewRestaurantController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/20/25.
//

import UIKit

class NewRestaurantController: UITableViewController{
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.delegate = self
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
            
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
            
        }
    }
    
    @IBOutlet var photoImageView : UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize appearance of navigation Bar
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
                navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
        }
        
        //Constraints for the Photo Image View
        
        //Get superview's layout
        let margins = photoImageView.superview!.layoutMarginsGuide
        
        //Disable auto resizing mask to use layout programatically
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Pin the edge of the image view to the  margin's leading edge
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        //Pin's the trailing edge of the imageView to the margin's trailing edge
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        //Pin's the bottom edge of the image view to the margin's bottom edge
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        
        //Dimiss keyboard
        let tap = UIGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            // Code that runs if the user picks the camera to take a photo of the restaurant
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            // Code that operates if the user picks the gallery to select the photos from
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
           
            
            // Cancel button to cancel the action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
                // Adds all the actions to the action sheet of the actionController
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            // For IPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            // Brings up whichever option is selected on action sheet
            present(photoSourceRequestController, animated: true, completion: nil)
            
            
            
        }
        
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
            let alertController  = UIAlertController(title: "Error", message: "Please fill in all fields before proceeding", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            
            return
        }
        
        
        // Prints the details of restaurant when save button clicked
        print("Name: \(nameTextField.text ?? "")")
        print("Type: \(typeTextField.text ?? "")")
        print("Address: \(addressTextField.text ?? "")")
        print("Phone: \(phoneTextField.text ?? "")")
        print("Description: \(descriptionTextView.text ?? "")")
        
        dismiss(animated: true, completion: nil)
    }

}

//Increases current tag cell by 1 and calls view.viewWithTag to retrieve next text field
extension NewRestaurantController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}

//Calls delegate method when the image is chosen from photo library
extension NewRestaurantController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            
        }
        
        dismiss(animated: true , completion: nil)
    }
}
