//
//  ViewController.swift
//  first
//
//  Created by CK on 2016/11/11.
//  Copyright © 2016年 CK. All rights reserved.
//

import UIKit
import CoreImage
//import ImageIO
import MobileCoreServices
import Social


extension UIColor {
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
}
//濾鏡方法
let filterModels: [String] = ["CILineScreen", "CILineOverlay", "CISpotColor"]
var imgbutton = [UIButton]()
//var imgtmp = [UIImage]()

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //主要imgview
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var camButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 0...(filterModels.count) {
            imgbutton.append(UIButton(frame: CGRect(x: 90 * i + 3 * (i + 1), y: 570, width: 70, height: 70)))
            self.view.addSubview(imgbutton[i])
        }
        //關閉相機button
//        if isEqual(UIImagePickerController.isSourceTypeAvailable(.camera)) == false{
//            camButton.isHidden = true
//        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //濾鏡套圖, 回傳UIIMG
    func getFilterWithImg(_ filterName: String!) -> UIImage? {
        let selfImg = CIImage(image: pickedImage.image!)
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        filter?.setValue(selfImg, forKey: kCIInputImageKey)
        var imgtmp = UIImage()
        if let output = filter?.outputImage {
            let tmp = CIContext().createCGImage(output, from: output.extent)
            imgtmp = UIImage(cgImage: tmp!)
        }
        return imgtmp
    }
    
    //imgbuttonaction
    func btaction(_ bt: UIButton){
        pickedImage.image = bt.currentImage
    
    }
    //1.給定原圖
    //2.使用getFilterWithImg回傳濾後圖
    //3.給定BT個別的action, #selector(btaction(_:))表代入本身物件
    //4.顯示imgBT
    @IBAction func doitAction(_ sender: UIButton) {
        imgbutton[0].setImage(pickedImage.image, for: .normal)
        imgbutton[0].addTarget(self, action: #selector(btaction(_:)), for: .touchUpInside)
        imgbutton[0].isHidden = false
        for i in 0...(filterModels.count - 1) {
//            imgtmp.append(getFilterWithImg(filterModels[i])!)
            imgbutton[i+1].setImage(getFilterWithImg(filterModels[i]), for: .normal)
            imgbutton[i+1].addTarget(self, action: #selector(btaction(_:)), for: .touchUpInside)
            imgbutton[i+1].isHidden = false
        }
        
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
    }
    
    @IBAction func shareOnFB() {
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.add(pickedImage.image)
        self.present(shareToFacebook, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            //
            let alertController = UIAlertController(
                title: "提示",
                message: "Camera不可用",
                preferredStyle: .alert)
            
            // 建立確認按鈕
            let okAction = UIAlertAction(
                title: "確認",
                style: .default
            )
            alertController.addAction(okAction)
            super.present(alertController, animated: false, completion: nil)
            //
        }
        
    }
    @IBAction func openPhotoLib(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: false, completion: nil)
            //隱藏imgbutton.image
            for i in imgbutton {
                i.isHidden = true
            }
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage2 = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage.contentMode = .scaleAspectFit
            pickedImage.image = pickedImage2
        }
        self.dismiss(animated: true, completion: nil)
    }
}

