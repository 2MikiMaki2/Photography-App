//
//  RotaryDial.swift
//  Manual Photographer
//
//  Created by Maksim on 3/28/24.
//

import SwiftUI

struct RotaryDial<Element>: View {
    private let scale: CGFloat = 275
    private let indicatorLength: CGFloat = 25
    let valueSet: Array<Element>
    
    @State var value: Element
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
    
    private func calcValue(angle: CGFloat) {
        var valueIndex = Int(angle) / 10
        
        if (valueIndex > valueSet.count - 1) {
            valueIndex = valueSet.count - 1
        }
        
        if (valueIndex < 0) {
            valueIndex = 0
        }
        
        self.value = valueSet[valueIndex]
    }
    
    //TODO: Why return wrong number?
    func getValue() -> Element {
        print("getValue: \(String(describing: self.value))")
        return self.value
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(.black))
                .opacity(0.4)
                .frame(width: 290, height: 290, alignment: .center)
                .gesture(
                    DragGesture().onChanged() { pos in
                        let x: CGFloat = min(max(pos.location.x, 0), self.innerScale)
                        let y: CGFloat = min(max(pos.location.y, 0), self.innerScale)

                        let ending = CGPoint(x: x, y: y)
                        let start = CGPoint(x: (self.innerScale) / 2, y: (self.innerScale) / 2)

                        let angle = self.angle(between: start, ending: ending)
                        self.rotation = angle / 3
                        //value = self.calcValue(angle: angle)
                        self.calcValue(angle: angle)
                        print("Value within dial: \(String(describing: self.value))")
                    }
                )
            
            Circle()
                .stroke(Color(.white), style: StrokeStyle(lineWidth: 15, lineCap: .butt, lineJoin: .miter, dash: [6, 23.18]))
                .rotationEffect(.degrees(self.rotation))
                .frame(width: 275, height: 275, alignment: .center)
                
            Text("\(String(describing: self.value))").font(.title).offset(x: 0.0, y: -70.0)
        }
    }
}

#Preview {
    RotaryDial<CGFloat>(valueSet: [1.0/8000.0, 1.0/4000.0, 1.0/2000.0, 1.0/1000.0, 1.0/500.0, 1.0/250.0, 1.0, 2.0, 4.0, 8.0, 15.0, 30.0, 60.0], value: 1.0)
}
