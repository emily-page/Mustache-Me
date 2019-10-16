//
//  ViewController.swift
//  MustacheMe
//
//  Created by  on 4/1/16.
//  Copyright © 2016 DocsApps. All rights reserved.
//

import UIKit

// add UIImagePickerControllerDelegate and UINavigationControllerDelegate for imagePicker

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var mustacheImageView: UIImageView!
    
    // create global variable for UIImagePicker
    let picker = UIImagePickerController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // set imagePickers delegate to self
        picker.delegate = self
        mustacheImageView.isUserInteractionEnabled = true
        let myTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        let myPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        myPanGestureRecognizer.minimumNumberOfTouches = 1
        myPanGestureRecognizer.maximumNumberOfTouches = 1
        mustacheImageView.addGestureRecognizer(myTapGestureRecognizer)
        mustacheImageView.addGestureRecognizer(myPanGestureRecognizer)
        mustacheImageView.addGestureRecognizer(myPinchGestureRecognizer)
    }
    
    // load imagePickerController
    @IBAction func loadImage(_ sender: UIBarButtonItem)
    {
        let sheet = UIAlertController(title: "Select where to get image from", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let libraryAction = UIAlertAction(title: "PHOTO LIBRARY", style: UIAlertActionStyle.default) { (action) -> Void in
            self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.picker.delegate = self
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "CAMERA", style: UIAlertActionStyle.default) { (action) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.allowsEditing = true
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
            }
            else
            {
                self.noCamera()
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        sheet.addAction(libraryAction)
        sheet.addAction(cameraAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    // dsiplays alert if device does not have a camera
    func noCamera()
    {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    
    // Dismiss imagePicker if user hits cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    // add Method to set image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if picker.sourceType == .camera
        {
            // get the image the user selected
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                // set imageview's image and make aspect fit
                myImageView.contentMode = .scaleAspectFit
                myImageView.image = pickedImage
            }
        }
        else
        {
            // get the image the user selected
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                // set imageview's image and make aspect fit
                myImageView.contentMode = .scaleAspectFit
                myImageView.image = pickedImage
            }
        }
        // dismiss imagePickerController
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer)
    {
        let point = sender.location(in: view)
        mustacheImageView.center = point
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
        
//        var point = sender.location(in: myImageView)
//        var mustacheImage = UIImageView(frame: CGRect(x: point.x, y: point.y, width: 80, height: 60)
//            mustacheImage.image = UIImage(named: "Mustache")
//            mustacheImage.contentMode = UIViewContentMode.scaleAspectFit
//            mustacheImage.center = point
//            mustacheImage.isUserInteractionEnabled = true
//            view.addSubview(mustacheImage)
        if mustacheImageView.image == UIImage(named: "Mustache")
        {
            mustacheImageView.image = UIImage(named: "Mustache purple")
        }
        else
        {
            mustacheImageView.image = UIImage(named: "Mustache")
        }
    }
    
    @IBAction func clearButton(_ sender: UIBarButtonItem)
    {
        mustacheImageView.center = CGPoint(x: 80, y: 50)
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer)
    {
        let scale: CGFloat = sender.scale;
        self.mustacheImageView.transform = self.mustacheImageView.transform.scaledBy(x: scale, y: scale);
        sender.scale = 1.0;
    }
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer)
    {
        if let view = sender.view
        {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
}
