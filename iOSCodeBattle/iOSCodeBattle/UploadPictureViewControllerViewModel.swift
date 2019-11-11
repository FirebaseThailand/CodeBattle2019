//
//  UploadPictureViewControllerViewModel.swift
//  iOSCodeBattle
//
//  Created by Phetrungnapha, Kittisak (Agoda) on 12/10/2562 BE.
//

import Foundation
import Firebase
import UIKit

protocol UploadPictureViewControllerViewModelDelegate: class {
    func uploadPictureViewControllerViewModelIsUploadingImage(_ viewModel: UploadPictureViewControllerViewModel, uploading: Bool)
    func uploadPictureViewControllerViewModelDidUploadFinish(_ viewModel: UploadPictureViewControllerViewModel)
    func uploadPictureViewControllerViewModelDidGetError(_ viewModel: UploadPictureViewControllerViewModel, message: String)
}

final class UploadPictureViewControllerViewModel {
    
    weak var delegate: UploadPictureViewControllerViewModelDelegate?
    
    let cameraImage: UIImage = {
        UIImage(named: "baseline_camera_alt_white_48pt") ?? UIImage()
    }()
    
    func upload(from image: UIImage, caption: String?) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            delegate?.uploadPictureViewControllerViewModelDidGetError(self, message: "Cannot convert image to .jpeg")
            return
        }
        
        let storageRef = Storage.storage(url: "gs://fir-devday.appspot.com").reference()
        let timestamp = Timestamp()
        let codeBattle2019Ref = storageRef.child("iOS_\(timestamp.seconds).jpeg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        delegate?.uploadPictureViewControllerViewModelIsUploadingImage(self, uploading: true)
        
        codeBattle2019Ref.putData(data, metadata: metadata) { [weak self] metadata, error in
            guard let self = self else { return }
            
            guard let _ = metadata else {
                self.delegate?.uploadPictureViewControllerViewModelDidGetError(self, message: "Metadata is missing")
                return
            }
            
            codeBattle2019Ref.downloadURL { (url, error) in
                if let error = error {
                    self.delegate?.uploadPictureViewControllerViewModelDidGetError(self, message: error.localizedDescription)
                    return
                }
                
                guard let downloadURL = url else {
                    self.delegate?.uploadPictureViewControllerViewModelDidGetError(self, message: "Downlord url is missing")
                    return
                }
                
                self.insertDataToCloudFirestore(from: downloadURL.absoluteString, caption: caption ?? "", timestamp: timestamp)
            }
        }
    }
    
    private func insertDataToCloudFirestore(from imagePath: String, caption: String, timestamp: Timestamp) {
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "caption": caption,
            "imageUrl": imagePath,
            "status": false,
            "timestamp": timestamp
        ]
        
        db.collection("code-battle-2019").addDocument(data: data) { [weak self] err in
            guard let self = self else { return }
            
            self.delegate?.uploadPictureViewControllerViewModelIsUploadingImage(self, uploading: false)
            
            if let err = err {
                self.delegate?.uploadPictureViewControllerViewModelDidGetError(self, message: err.localizedDescription)
            } else {
                self.delegate?.uploadPictureViewControllerViewModelDidUploadFinish(self)
            }
        }
    }
}
