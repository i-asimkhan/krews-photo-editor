//
//  PhotoEditor+Font.swift
//
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    //Resources don't load in main bundle we have to register the font
    func registerFonts() {
        
        registerAllFont()
        
        //let bundle = Bundle(for: PhotoEditorViewController.self)
        
        
        /*
        let url =  bundle.url(forResource: "poppins", withExtension: "ttf")
        
        guard let fontDataProvider = CGDataProvider(url: url! as CFURL) else {
            return
        }
        guard let font = CGFont(fontDataProvider) else {return}
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            return
        }
        */
        
        /*
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: bundle.resourcePath!)
            for item in items {
                if let p = bundle.path(forResource: item, ofType: ""), let url = URL(string: p) {
                    
                    
                    guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
                        return
                    }
                    guard let font = CGFont(fontDataProvider) else {return}
                    var error: Unmanaged<CFError>?
                    guard CTFontManagerRegisterGraphicsFont(font, &error) else {
                        return
                    }
                }
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        */
    }
    
    func registerAllFont() {
        let fonts = Bundle(for:
            PhotoEditorViewController.self).urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
    }
}
