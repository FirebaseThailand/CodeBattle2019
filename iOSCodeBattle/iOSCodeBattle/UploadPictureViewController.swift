//
//  UploadPictureViewController.swift
//  iOSCodeBattle
//
//  Created by Phetrungnapha, Kittisak (Agoda) on 12/10/2562 BE.
//

import UIKit
import SVProgressHUD

final class UploadPictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UploadPictureViewControllerViewModelDelegate {
    
    private var stackView: UIStackView!
    private var imageView: UIImageView!
    private var captionTextField: UITextField!
    private var submitButton: UIButton!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private let viewModel = UploadPictureViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewModel.delegate = self
        
        // Content imageview
        imageView = UIImageView(image: viewModel.cameraImage)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 4
        
        // CaptionTextField
        captionTextField = PaddingTextField()
        captionTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        captionTextField.layer.cornerRadius = 4
        captionTextField.layer.borderWidth = 1
        captionTextField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.5).cgColor
        captionTextField.textColor = UIColor(named: "FirebaseBlue")
        let placeholder = NSAttributedString(string: "What is on your mind?",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray.withAlphaComponent(0.5)])
        captionTextField.attributedPlaceholder = placeholder
        
        // SubmitButton
        submitButton = UIButton(type: .system)
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitButton.setTitle("SHARE", for: .normal)
        submitButton.backgroundColor = UIColor(named: "FirebaseOrange")
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        submitButton.layer.cornerRadius = 4
        
        // ScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let safeArea = view.safeAreaLayoutGuide
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // ContentView
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // StackView
        stackView = UIStackView(arrangedSubviews: [imageView, captionTextField, submitButton])
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func uploadImage() {
        view.endEditing(true)
        
        guard let image = imageView.image, image != viewModel.cameraImage else {
            SVProgressHUD.showError(withStatus: "Please take a photo before upload it")
            return
        }
        
        viewModel.upload(from: image, caption: captionTextField.text)
        submitButton.isEnabled = false
    }
    
    @objc private func takePhoto() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            SVProgressHUD.showError(withStatus: "Image is missing")
            return
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - UploadPictureViewControllerViewModelDelegate
    
    func uploadPictureViewControllerViewModelIsUploadingImage(_ viewModel: UploadPictureViewControllerViewModel, uploading: Bool) {
        if uploading {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    func uploadPictureViewControllerViewModelDidUploadFinish(_ viewModel: UploadPictureViewControllerViewModel) {
        SVProgressHUD.showSuccess(withStatus: "Upload successfully!")
        
        imageView.image = viewModel.cameraImage
        imageView.contentMode = .center
        captionTextField.text = nil
        submitButton.isEnabled = true
    }
    
    func uploadPictureViewControllerViewModelDidGetError(_ viewModel: UploadPictureViewControllerViewModel, message: String) {
        SVProgressHUD.showError(withStatus: message)
        submitButton.isEnabled = true
    }
}
