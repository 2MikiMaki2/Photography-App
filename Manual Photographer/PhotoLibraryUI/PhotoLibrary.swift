//
//  PhotoLibrary.swift
//  Manual Photographer
//
//  Created by Maksim on 12/12/23.
//

import SwiftUI
import UIKit
import Foundation
import AVFoundation
import Photos
import PhotosUI

// Reads data from album in camera roll
class PhotoLibrary {
    @State var albumLocation = ""
    var album: [AlbumPhoto]
    
    struct AlbumPhoto: Identifiable {
        let id = UUID()
        let value: UIImage
    }
    
    init() {
        album = []
        
        if (albumLocation == "") {
            print("Making album in PhotoLibrary")
            PHPhotoLibrary.shared().performChanges {
                let assetRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Manual Photographer")
                let assetPlaceholder = assetRequest.placeholderForCreatedAssetCollection
                self.albumLocation.append(assetPlaceholder.localIdentifier)
                print("albumLocation: " + self.albumLocation)
            } completionHandler: { success, error in
                if let error {
                    print("Error saving photo: \(error.localizedDescription)")
                    return
                }
            }
            
            
        }
        
        let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumLocation], options: nil).firstObject
        if (assetCollection != nil) {
            let fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)
            for index in 0...fetchResult.count {
                let photo = AlbumPhoto(value: getAssetThumbnail(asset: fetchResult.object(at: index)))
                album.append(photo)
            }
        }
    }
    
    func getPhotos() -> [AlbumPhoto] {
        return album
    }
    
    func getAlbumLocation() -> String {
        return albumLocation
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
    
}

//#Preview {
//    PhotoLibrary()
//}
