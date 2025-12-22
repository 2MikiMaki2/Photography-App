//
//  RepresentedPhotoLibrary.swift
//  Manual Photographer
//
//  Created by Maksim on 2/26/24.
//

import SwiftUI

struct RepresentedPhotoLibrary: View {
    @State var photos: [PhotoLibrary.AlbumPhoto] = PhotoLibrary.album
    @State var animateRefresh = false
    
    var body: some View {
        VStack {
            Button {
                animateRefresh.toggle()
                print("Refreshing RepresentedPhotoLibrary")
                photos = PhotoLibrary.album
            } label: {
                Image(systemName: "arrow.clockwise.circle").symbolRenderingMode(.hierarchical).symbolEffect(.bounce.down, value: animateRefresh).font(.largeTitle)
            }.foregroundStyle(.white)

            PhotoLibraryDisplay(photos: $photos)
        }
        .onAppear {
            photos = PhotoLibrary.getPhotos()
        }
        .onReceive(NotificationCenter.default.publisher(for: PhotoLibrary.albumDidUpdateNotification)) { _ in
            animateRefresh.toggle()
            print("Automatically refreshing RepresentedPhotoLibrary")
            photos = PhotoLibrary.album
        }
    }
}

//#Preview {
//    RepresentedPhotoLibrary()
//}
