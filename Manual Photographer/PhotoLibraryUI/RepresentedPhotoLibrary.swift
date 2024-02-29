//
//  RepresentedPhotoLibrary.swift
//  Manual Photographer
//
//  Created by Maksim on 2/26/24.
//

import SwiftUI

struct RepresentedPhotoLibrary: View {
    @State var photos: [PhotoLibrary.AlbumPhoto] = PhotoLibrary.album
    
    var body: some View {
        PhotoLibraryDisplay(photos: $photos)
    }
}

//#Preview {
//    RepresentedPhotoLibrary()
//}
