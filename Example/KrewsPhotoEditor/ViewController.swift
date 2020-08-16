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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        photoEditor.image = UIImage()
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        /*
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        */
        
        //To hide controls - array of enum control
        //photoEditor.hiddenControls = [.crop, .draw, .share]
        //photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
        //present(photoEditor, animated: true, completion: nil)
        
        photoEditor.view.frame = self.view.frame
        self.view.addSubview(photoEditor.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension ViewController :PhotoEditorDelegate {
    func doneEditing(image: UIImage) {
        
    }
    
    func canceledEditing() {
        
    }
    
}

