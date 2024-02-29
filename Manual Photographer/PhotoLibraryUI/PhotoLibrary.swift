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
    static var albumLocation = ""
    static var album: [AlbumPhoto] = []
    
    public struct AlbumPhoto: Identifiable {
        let id = UUID()
        let value: UIImage
    }
    
    //TODO: Somehow I coded it so that it doesn't add if one photo taken, have to take two photos
    static func getPhotos() -> [AlbumPhoto] {
        checkAlbum()
        updateAlbum()
        
        print("Updated album, new size wrt PhotoLibrary: \(album.count)")
        return album
    }
    
    static func getAlbumLocation() -> String {
        return albumLocation
    }
    
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
            print(info as Any)
        })
        
        print(thumbnail)
        return thumbnail
    }
    
    static func checkAlbum() {
        if (albumLocation == "") {
            print("Making album in PhotoLibrary")
            PHPhotoLibrary.shared().performChanges {
                let assetRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Manual Photographer")
                let assetPlaceholder = assetRequest.placeholderForCreatedAssetCollection
                albumLocation += assetPlaceholder.localIdentifier
                print("localIdentifier after making album: \(assetPlaceholder.localIdentifier)")
                print("albumLocation in checkAlbum(): \(albumLocation)")
            } completionHandler: { success, error in
                if let error {
                    print("Error making album: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    static func checkAssetCollection() -> Bool {
        let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumLocation], options: nil).firstObject
        if (assetCollection != nil) {
            let fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)
            if fetchResult.count != 0 {
                print("checkAssetCollection returned true")
                return true
            }
        }
        
        print("checkAssetCollection returned false")
        return false
    }
    
    static func updateAlbum() {
        if checkAssetCollection() {
            let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumLocation], options: nil).firstObject
            if (assetCollection != nil) {
                let fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)
                for index in 0...(fetchResult.count - 1) {
                    print("Index in updateAlbum: \(index)")
                    let photo = AlbumPhoto(value: getAssetThumbnail(asset: fetchResult.object(at: index)))
                    album.append(photo)
                    print("Added photo to PhotoLibrary album")
                }
            }
        }
    }
    
}

//#Preview {
//    PhotoLibrary()
//}
