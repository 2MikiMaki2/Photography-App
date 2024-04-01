//
//  RotaryDial.swift
//  Manual Photographer
//
//  Created by Maksim on 3/28/24.
//

import SwiftUI

struct RotaryDial: View {
    private let scale: CGFloat = 275
    let valueScale: CGFloat
    private let indicatorLength: CGFloat = 25
    let maxValue: CGFloat
    let stepSize: CGFloat
    
    @State private var value: CGFloat = 0
    @State private var rotation: CGFloat = 0
    
    private var innerScale: CGFloat {
        return scale - indicatorLength
    }
    
    private func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        var degrees = 90 + (radians * 180 / .pi)
        
        if (degrees < 0) {
            degrees += 360
        }

        return degrees
    }
    
    private func calcValue(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        var newValue = 90 + (radians * 180 / .pi)
        
        if (newValue > maxValue) {
            newValue = 0
        }
        
        return newValue
    }
    
    var body: some View {
        ZStack {
            Cookie()
            
            Circle()
                .stroke(Color(.white), style: StrokeStyle(lineWidth: 25, lineCap: .butt, lineJoin: .miter, dash: [4]))
                .fill(Color(.black))
                .rotationEffect(.degrees(self.rotation))
                .frame(width: 275, height: 275, alignment: .center)
                .opacity(0.4)
                .gesture(
                    DragGesture().onChanged() { value in
                        let x: CGFloat = min(max(value.location.x, 0), self.innerScale)
                        let y: CGFloat = min(max(value.location.y, 0), self.innerScale)

                        let ending = CGPoint(x: x, y: y)
                        let start = CGPoint(x: (self.innerScale) / 2, y: (self.innerScale) / 2)

                        let angle = self.angle(between: start, ending: ending)
                        self.rotation = angle / 10
                        self.value = self.calcValue(between: start, ending: ending)
                    }
                )
            
            Text("\(self.value)").font(.title)
        }
    }
}

#Preview {
    RotaryDial(valueScale: 100.0, maxValue: 32, stepSize: 0.5)
}
