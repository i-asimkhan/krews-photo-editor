///**

/**
KrewsPhotoEditor
Created by: Ahmed Alqubaisi on 20/08/2020

PhotoEditorController



Copyright (c) 2020   Dev Shanghai

+-----------------------------------------------------+
|                                                     |
|                                                     |
|                                                     |
|                                                     |
+-----------------------------------------------------+

*/

import UIKit
import AVFoundation
import Foundation


public final class PhotoEditorViewController: UIViewController {
    
    /** holding the 2 imageViews original image and drawing & stickers */
    @IBOutlet weak var canvasView: UIView!
    
    
    // To hold the image
    @IBOutlet var imageView: UIImageView!
    
    // To hold the drawings and stickers
    @IBOutlet weak var canvasImageView: UIImageView!
    
    // Toolbar view
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var topRightToolbar: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    
    // Gradient views
    @IBOutlet weak var topGradientView: GradientView!
    @IBOutlet weak var bottomGradient: GradientView!
    
    
    // Done, Delete and other Views
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorPickerViewBottomConstraint: NSLayoutConstraint!
    
    // Controls
    @IBOutlet weak var cropBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var stackBtn: UIButton!
    @IBOutlet weak var fontChangeBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    //Video Container
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var avPlayerView: UIView!
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    
    // Shade image view
    @IBOutlet weak var imgShadeView: UIView!
    @IBOutlet weak var shadeColorBtn1: UIButton!
    @IBOutlet weak var shadeColorBtn2: UIButton!
    @IBOutlet weak var shadeColorBtn3: UIButton!
    
    
    
    
    public var image: UIImage?
    public var video:URL?
    /**
     Array of Stickers -UIImage- that the user will choose from
     */
    public var stickers : [UIImage] = []
    /**
     Array of Colors that will show while drawing or typing
     */
    public var colors  : [UIColor] = []
    
    public var photoEditorDelegate: PhotoEditorDelegate?
    var colorsCollectionViewDelegate: ColorsCollectionViewDelegate!
    
    // list of controls to be hidden
    public var hiddenControls : [control] = []
    
    var stickersVCIsVisible = false
    var drawColor: UIColor = UIColor.black
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var lastPanPoint: CGPoint?
    var lastTextViewTransform: CGAffineTransform?
    var lastTextViewTransCenter: CGPoint?
    var lastTextViewFont:UIFont?
    var activeTextView: UITextView?
    var imageViewToPan: UIImageView?
    var isTyping: Bool = false
    
    
    var stickersViewController: StickersViewController!
    
    // Register Custom font before we load XIB
    public override func loadView() {
        //registerFont()
        registerFonts()
        super.loadView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
        
        imgShadeView.isHidden = true
        deleteView.layer.cornerRadius = deleteView.bounds.height / 2
        deleteView.layer.borderWidth = 2.0
        deleteView.layer.borderColor = UIColor.white.cgColor
        deleteView.clipsToBounds = true
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .bottom
        edgePan.delegate = self
        self.view.addGestureRecognizer(edgePan)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        configureCollectionView()
        stickersViewController = StickersViewController(nibName: "StickersViewController", bundle: Bundle(for: StickersViewController.self))
        hideControls()
    }
    
    func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        colorsCollectionView.collectionViewLayout = layout
        colorsCollectionViewDelegate = ColorsCollectionViewDelegate()
        colorsCollectionViewDelegate.colorDelegate = self
        if !colors.isEmpty {
            colorsCollectionViewDelegate.colors = colors
        }
        colorsCollectionView.delegate = colorsCollectionViewDelegate
        colorsCollectionView.dataSource = colorsCollectionViewDelegate
        
        colorsCollectionView.register(
            UINib(nibName: "ColorCollectionViewCell", bundle: Bundle(for: ColorCollectionViewCell.self)),
            forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    func updateUI() {
        
        if let image = self.image {
            //let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
            //imageViewHeightConstraint.constant = (size?.height)!
            self.imageView.image = image
            self.videoContainerView.isHidden = true
            self.canvasView.isHidden = false
        } else if let video = self.video {
            
            self.canvasView.isHidden = true
            self.videoContainerView.isHidden = false
            self.getThumbnailImageFromVideoUrl(url:video, completion: { (image) in
                self.videoThumbnailImageView.image = image ?? UIImage()
            })
        }
        
    }
    
    func hideToolbar(hide: Bool) {
        var hideViews = hide
        if isTyping {
            hideViews = true
        }
        topRightToolbar.isHidden = hideViews
        topToolbar.isHidden = hideViews
        topGradientView.isHidden = hideViews
        bottomToolbar.isHidden = hideViews
        bottomGradient.isHidden = hideViews
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension PhotoEditorViewController: ColorDelegate {
    func didSelectColor(color: UIColor) {
        if isDrawing {
            self.drawColor = color
        } else if activeTextView != nil {
            activeTextView?.textColor = color
            textColor = color
        }
    }
}







