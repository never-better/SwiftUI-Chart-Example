//
//  PieChartView.swift
//  SwiftUI-Charts-Example
//
//  Created by youtak on 2023/06/28.
//

import SwiftUI
import Charts

struct iPhoneOperationSystem {
    
    let version: String
    let count: Int
    
    static func dummyData() -> [iPhoneOperationSystem] {
        return [
            iPhoneOperationSystem(version: "16.0", count: 81),
            iPhoneOperationSystem(version: "15.0", count: 13),
            iPhoneOperationSystem(version: "14.0", count: 6)
        ]
    }
}

struct PieChartView: View {
    
    let data: [iPhoneOperationSystem]
    
    @State var selectedData: Double?
    
    let cumulativeSalesRangesForStyle: [(version: String, range: Range<Double>)]
    
    init(data: [iPhoneOperationSystem]) {
        self.data = data
        
        var cumulative = 0.0
        
        self.cumulativeSalesRangesForStyle = data.map {
            let newCumulative = cumulative + Double($0.count)
            let result = (version: $0.version, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
            
        }
    }
    
    var selectedStyle: iPhoneOperationSystem? {
        if let selectedData,
           let selectedIndex = cumulativeSalesRangesForStyle
            .firstIndex(where: { $0.range.contains(selectedData)}) {
            return data[selectedIndex]
        }
        
        return nil
    }
    
    var body: some View {
        VStack {
            
            Chart(data, id: \.version) { element in
                SectorMark(
                    angle: .value("Usage", element.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity((element.version == selectedStyle?.version ?? "") ? 1 : 0.3)
                .foregroundStyle(by: .value("Version", element.version))
            }
            .chartLegend(alignment: .center, spacing: 18)
            .chartAngleSelection(value: $selectedData)
            .padding()
            .scaledToFit()
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    
                    VStack {
                        
                        if let selectedStyle {
                            Text("Usage")
                                .font(.callout)
                            
                            Text("iOS \(selectedStyle.version)")
                                .font(.title.bold())
                            
                            let percentage = Int(Double(selectedStyle.count) / Double(data.reduce(into: 0) { $0 += $1.count}) * 100)
                            
                            Text("\(percentage) %")

                        }
                        
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
                
            }
            
        }

        
    }
}

#Preview {
    PieChartView(
        data: iPhoneOperationSystem.dummyData()
    )
}





