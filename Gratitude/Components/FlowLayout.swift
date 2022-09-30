//
//  FlowLayout.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}



struct FlowLayout<Element: Identifiable, Cell: View>: View {
    let spacing: CGSize
    var items: [Element]
    var cell: (Element) -> Cell
    @State private var sizes: [CGSize] = []
    @State private var containerWidth: CGFloat = 0

    var body: some View {
        let laidout = layout(sizes: sizes, containerWidth: containerWidth)
        
        return VStack(spacing: 0) {
            GeometryReader { proxy in
                Color.clear.preference(key: SizeKey.self, value: [proxy.size])
            }
            .onPreferenceChange(SizeKey.self) {
                containerWidth = $0[0].width
            }
            .frame(height: 0)
            ZStack(alignment: .topLeading) {
                ForEach(Array(zip(items, items.indices)), id: \.0.id) { (item, index) in
                    cell(item)
                        .fixedSize()
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: SizeKey.self, value: [proxy.size])
                        })
                        .alignmentGuide(.leading, computeValue: { dimension in
                            guard !laidout.isEmpty else { return 0 }
                            return -laidout[index].x
                        })
                        .alignmentGuide(.top, computeValue: { dimension in
                            guard !laidout.isEmpty else { return 0 }
                            return -laidout[index].y
                        })
                }
            }
            .onPreferenceChange(SizeKey.self, perform: { value in
                self.sizes = value
            })
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func layout(sizes: [CGSize], containerWidth: CGFloat) -> [CGPoint] {
        var currentPoint: CGPoint = .zero
        var result: [CGPoint] = []
        var lineHeight: CGFloat = 0
        for size in sizes {
            if currentPoint.x + size.width > containerWidth {
                currentPoint.x = 0
                currentPoint.y += lineHeight + spacing.height
            }
            result.append(currentPoint)
            currentPoint.x += size.width + spacing.width
            lineHeight = max(lineHeight, size.height)
        }
        return result
    }
}
