//
//  UserPermissions.swift
//  Manual Photographer
//
//  Created by Maksim on 1/12/24.
//

import SwiftUI

struct UserPermissions: View {
    @State var allowCameraAccess: Bool = false
    @State var allowRollAccess: Bool = false
    @State var allowMicAccess: Bool = false
    
    var body: some View {
        List() {
            Toggle(isOn: $allowCameraAccess) {
                Text("Allow access to camera")
            }.font(.headline)
            
            Toggle(isOn: $allowRollAccess) {
                Text("Allow access to camera roll")
            }.font(.headline)
            
            Toggle(isOn: $allowMicAccess) {
                Text("Allow access to microphone")
            }.font(.headline)
        }
    }
}

#Preview {
    UserPermissions()
}
