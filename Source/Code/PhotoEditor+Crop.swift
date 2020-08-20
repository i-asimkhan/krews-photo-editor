///**

/**
KrewsPhotoEditor
Created by: Ahmed Alqubaisi on 20/08/2020

PhotoEditor+Crop



Copyright (c) 2020

+-----------------------------------------------------+
|                                                     |
|                                                     |
|                                                     |
|                                                     |
+-----------------------------------------------------+

*/

import Foundation

import Foundation
import UIKit

// MARK: - CropView
extension PhotoEditorViewController: CropViewControllerDelegate {
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
        self.image = image
        self.updateUI()
    }
    
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        self.image = image
        self.updateUI()
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
