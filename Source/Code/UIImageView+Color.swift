///**

/**
KrewsPhotoEditor
Created by: Ahmed Alqubaisi on 19/08/2020

UIImageView+Color

--------------------------------------------------+
|                                                     |
|                                                     |
|                                                     |
|                                                     |
+-----------------------------------------------------+

*/

import Foundation
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
