//
//  NoteVC.swift
//  Chaoli
//
//  Created by 潘涛 on 2021/4/16.
//

import UIKit
import YPImagePicker
import SKPhotoBrowser
import UITextView_Placeholder

class NoteVC: UIViewController {

    var photos:[UIImage] = [] //model,用来存放用户添加的图片
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var photoCollectionview: UICollectionView!

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var titleCountLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    var photonum: Int{
        return photos.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleCountLabel.text = "\(KMaxnotetitlecount)"
        photoCollectionview.dragInteractionEnabled = true
        hideKeyboardWhenTappingAround() //点击空白处收起键盘
        
        //改变Postbtn的样式 #a29bfe
//        postButton.layer.borderWidth = 1
//        saveBtn.layer.borderWidth = 1
        
        //改变textView的样式
        textView.placeholder = "请在这里输入具体的内容～"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 //输入文本的行间距
        let typingAttributes:[NSAttributedString.Key: Any] = [
            .paragraphStyle:paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label //重新设置字体的大小和颜色
        ]
        textView.typingAttributes = typingAttributes
        textView.tintColorDidChange() //改变光标的颜色
    }

    @IBAction func DEOE(_ sender: Any) {
    } //点击确定收起键盘
    @IBAction func TFEditEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }
    @IBAction func TFEditBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }
    
    
    //修复中文输入的bug
    @IBAction func TFEditChange(_ sender: Any) {
        
        /**判断文字是否处于高亮状态，有高亮文本则return出去，不进行计数。即有高亮文本时，该函数只判断了一下，就执行完了。
        而当文字没有高亮时（即文字已经确定输入到Text Field中了），此时titleTextField.markedTextRange == nil成立，继续执行后面的代码
        */
        guard titleTextField.markedTextRange == nil else {
            return
        }
        
        if titleTextField.unwrappedText.count > KMaxnotetitlecount {
            titleTextField.text = String(titleTextField.unwrappedText.prefix(KMaxnotetitlecount)) //截取字符
            showTextHud("最多只可输入\(KMaxnotetitlecount)个字符哦～")
            DispatchQueue.main.async {
                let  end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
                //将光标放在最后
            }
        }
        titleCountLabel.text = "\(KMaxnotetitlecount - titleTextField.unwrappedText.count)"
        print(titleTextField.unwrappedText.count)
    }
}

/**
 压缩优先级与拉伸优先级：
        title（textfield）的拉伸优先级高（数值小），所以会先拉伸textfield，而字数（label）不被拉伸
        title（textfield）的压缩优先级高（数值小），所以会先压缩textfield，而字数（label）不被压缩
        这样就实现了字数这个label一直固定在标题框的右侧
 */
//限制用户最多输入XX个字符
//extension NoteVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if range.location >= KMaxnotetitlecount || (textField.unwrappedText.count + string.count) > KMaxnotetitlecount {
//            showTextHud("最多只可输入\(KMaxnotetitlecount)个字符哦～")
//            return false
//        }
//        return true
//    }
//}

extension NoteVC: UICollectionViewDataSource{
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//    } 默认返回一段，而我们collectionview中也是只有一个section，所以不需要实现
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photonum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPhotoCellID, for: indexPath) as! PhotoCell
        if(photonum != 0){
            cell.imageView.image = photos[indexPath.item]
        }
        return cell
    } //返回photoCell
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photoFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KPhotoFooterID, for: indexPath) as! PhotoFooter  //返回photoFooter
            
            //给btn添加点击事件
            photoFooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            
            //设置btn样式
            photoFooter.addPhotoBtn.layer.borderWidth = 2
            photoFooter.addPhotoBtn.layer.borderColor = UIColor.tertiaryLabel.cgColor
            
            return photoFooter
        default:
            return UICollectionReusableView() //返回空的
        }
    }
}

extension NoteVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. create SKPhoto Array from UIImage
        var images = [SKPhoto]()
        for photo in photos{
            images.append(SKPhoto.photoWithImage(photo))
        }
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        
        browser.delegate = self
        
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.displayStatusbar = true
        browser.initializePageIndex(indexPath.item)
        present(browser, animated: true)
    }
}

extension NoteVC: SKPhotoBrowserDelegate{
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        photoCollectionview.reloadData()
        reload()
    }
}


//监听函数
extension NoteVC{
    @objc private func addPhoto(){
        if photonum < KMaxphotonum{
                var config = YPImagePickerConfiguration()
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.usesFrontCamera = false
                config.showsPhotoFilters = false
                config.showsVideoTrimmer = false
                config.shouldSaveNewPicturesToAlbum = true
                config.albumName = "超理论坛"
                config.startOnScreen = YPPickerScreen.photo
                config.screens = [.photo, .library]
                config.showsCrop = .none //裁剪功能
                config.overlayView = UIView()
                config.hidesBottomBar = false
                config.hidesCancelButton = false
                config.preferredStatusBarStyle = UIStatusBarStyle.default
                config.maxCameraZoomFactor = 5.0
                config.library.preSelectItemOnMultipleSelection = true
                config.library.onlySquare = false
                config.library.isSquareByDefault = false
                config.library.mediaType = YPlibraryMediaType.photo
                config.library.defaultMultipleSelection = true
                config.library.maxNumberOfItems = KMaxphotonum - photonum
                config.library.minNumberOfItems = 1
                config.library.numberOfItemsInRow = 4
                config.library.spacingBetweenItems = 2.0
                config.library.skipSelectionsGallery = false
                config.library.preselectedItems = nil
                config.gallery.hidesRemoveButton = false
                config.icons.capturePhotoImage = UIImage(named: "aperture2")!
                config.wordings.libraryTitle = "相册"
                config.wordings.cameraTitle = "相机"
                config.wordings.next = "下一步"
                config.wordings.cancel = "取消"
                config.wordings.warningMaxItemsLimit = "总共最多选择\(KMaxphotonum)张照片"
                YPImagePickerConfiguration.shared = config
                let picker = YPImagePicker()
            
                picker.didFinishPicking { [unowned picker] items, cancelled in
                    if cancelled {
                        print("是否要放弃编辑？")
                    }
                    for item in items{
                        if case let .photo(photo) = item{
                            self.photos.append(photo.image)
                        }
                    }
                    self.photoCollectionview.reloadData()
                    picker.dismiss(animated: true, completion: nil)
                }
                self.present(picker, animated: true, completion: nil)
        }
        else{
            self.showTextHud("最多只可添加\(KMaxphotonum)张照片")
        }
    }
}
