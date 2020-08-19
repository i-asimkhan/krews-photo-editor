//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - Control
public enum control {
    case crop
    case sticker
    case draw
    case text
    case save
    case share
    case clear
}

struct COLORS {

    static let color1 : UIColor = UIColor(red: 46/255, green: 104/255, blue: 135/255, alpha: 1)
    static let color2 : UIColor = UIColor(red: 79/255, green: 174/255, blue: 174/255, alpha: 1)
    static let color3 : UIColor = UIColor(red: 92/255, green: 166/255, blue: 197/255, alpha: 1)
}

extension PhotoEditorViewController {

     //MARK: Top Toolbar
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cropBtnTapped(_ sender: UIButton) {
        
        //let controller = PhotCropViewController(nibName: "PhotCropViewController", bundle: nil)
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }

    @IBAction func stickersButtonTapped(_ sender: Any) {
        addStickersViewController()
    }
    
    @IBAction func stackButtonPressed(_ sender: UIButton) {
        
        if sender.isSelected {
            self.shadeColorBtn1.isHidden = true
            self.shadeColorBtn2.isHidden = true
            self.shadeColorBtn3.isHidden = true
            
            self.imageView.image = self.image ?? UIImage()
            self.imgShadeView.isHidden = true
        } else {
            
            self.shadeColorBtn1.isHidden = false
            self.shadeColorBtn2.isHidden = false
            self.shadeColorBtn3.isHidden = false
            
            self.imageView.setImageColor(color: COLORS.color1.withAlphaComponent(0.75))
            self.imgShadeView.isHidden = true
            self.shadeColorBtn1.isSelected = true
        }
        
        sender.isSelected = !sender.isSelected
    }

    @IBAction func drawBtnTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        cancelButton.isHidden = false
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }

    @IBAction func textButtonTapped(_ sender: Any) {
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 30))
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
        
    }    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        cancelButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
        showAndHideFontSelector()
        
        /*
        if isTyping {
            self.canvasImageView.subviews.forEach { (view) in
                /*
                if let txtView = view as? UITextView , txtView.gestureRecognizers?.isEmpty ?? false {
                    self.addGestures(view: txtView)
                }
                */
                
                let gesture = view.gestureRecognizers?.first(where: { (gesture) -> Bool in
                    if  ((gesture as? UIPanGestureRecognizer) == nil) || ((gesture as? UIPinchGestureRecognizer) == nil) || ((gesture as? UIRotationGestureRecognizer) == nil) {
                        return false
                    } else {
                        return true
                    }
                })
                
                if gesture == nil {
                    self.addGestures(view: view)
                }
                
                
                
                
            }
            
            
            isTyping = false
        }
        */
    }
    
    @IBAction func editScreencancelButtonTapped(_ sender: UIButton) {
        
        view.endEditing(true)
        cancelButton.isHidden = true
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
        clearBtnTapped(self)
        showAndHideFontSelector()
    }
    
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveBtnTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [canvasView.toImage()], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func clearBtnTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
        
        showAndHideFontSelector()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let img = self.canvasView.toImage()
        photoEditorDelegate?.doneEditing(image: img)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideControls() {
        for control in hiddenControls {
            switch control {
                
            case .clear:
                clearBtn.isHidden = true
            case .crop:
                cropBtn.isHidden = true
            case .draw:
                drawBtn.isHidden = true
            case .save:
                saveBtn.isHidden = true
            case .share:
                shareBtn.isHidden = true
            case .sticker:
                stickerBtn.isHidden = true
            case .text:
                stickerBtn.isHidden = true
            }
        }
    }
    
    func showAndHideFontSelector() {
        self.fontChangeBtn.isHidden = true
        self.canvasImageView.subviews.forEach { (view) in
            if view is UITextView {
                self.fontChangeBtn.isHidden = false
            }
        }
    }
    
}



// MARK: - Shade View
extension PhotoEditorViewController {
    
    @IBAction func didTapColor1(_ sender: UIButton) {
        self.imageView.setImageColor(color: COLORS.color1.withAlphaComponent(0.75))
    }
    
    @IBAction func didTapColor2(_ sender: UIButton) {
        self.imageView.setImageColor(color: COLORS.color2.withAlphaComponent(0.75))
    }
    
    @IBAction func didTapColor3(_ sender: UIButton) {
        self.imageView.setImageColor(color: COLORS.color3.withAlphaComponent(0.75))
    }
    
    @IBAction func didTapChangeFont(_ sender: UIButton) {
        
        self.canvasImageView.subviews.forEach { (view) in
            if let txtView = view as? UITextView {
                
                if txtView.font?.fontName == "Helvetica" {
                     txtView.font = UIFont(name: "GillSans", size: 30)
                    self.fontChangeBtn.titleLabel?.font = UIFont(name: "Gill Sans", size: 25)
                } else if txtView.font?.fontName == "GillSans" {
                     txtView.font = UIFont(name: "AppleColorEmoji", size: 30)
                    self.fontChangeBtn.titleLabel?.font = UIFont(name: "Gill Sans", size: 25)
                } else if txtView.font?.fontName == "AppleColorEmoji" {
                     txtView.font = UIFont(name: "Helvetica", size: 30)
                    self.fontChangeBtn.titleLabel?.font = UIFont(name: "Gill Sans", size: 25)
                } else {
                   txtView.font = UIFont(name: "Helvetica", size: 30)
                    self.fontChangeBtn.titleLabel?.font = UIFont(name: "Gill Sans", size: 25)
                }
                
            }
        }
        
    }
}


