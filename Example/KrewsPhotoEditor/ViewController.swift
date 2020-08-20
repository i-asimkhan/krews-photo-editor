//
//  ViewController.swift
//  KrewsPhotoEditor
//
//  Created by iamasimkhanjadoon@gmail.com on 08/17/2020.
//  Copyright (c) 2020 iamasimkhanjadoon@gmail.com. All rights reserved.
//

import UIKit

import KrewsPhotoEditor

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickImageButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image","public.movie"]
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: PhotoEditorDelegate {
    func doneEditing(video: URL) {
        
        
    }
    
    
    func doneEditing(image: UIImage) {
        imageView.image = image
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        
        
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            
            photoEditor.image = image
            
            
        } else  {
            
            guard let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL else {
                return
            }
            
            /*
            if let ref =  info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL {
                
                let res = PHAsset.fetchAssets(withALAssetURLs: [ref], options: nil)
                
                res.firstObject!.getURL { (tempPath) in
                    
                    DispatchQueue.main.async {
                        
                        
                    }
                    
                }
                
            }
            
            */
            

            photoEditor.video = url
        }
        
        
        //To hide controls - array of enum control
        //photoEditor.hiddenControls = [.crop, .draw, .share]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
        
        
        
        picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.2))) {
            self.present(photoEditor, animated: true, completion: nil)
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func pickerController(_ controller: UIImagePickerController, didSelect url: URL?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
