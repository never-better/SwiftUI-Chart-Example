//
//  ContentView.swift
//  SwiftUI-Charts-Example
//
//  Created by youtak on 2023/06/28.
//

import SwiftUI

struct ContentView: View {
    
    private enum Destinations {
        case pie
    }
    
    @State private var selection: Destinations?
    
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: Destinations.pie) {
                    Text("Pie Charts")
                }
            }
        } detail: {
            NavigationStack {
                switch selection {
                case .pie:
                    PieChartView(
                        data: iPhoneOperationSystem.dummyData()
                    )
                case nil:
                    Text("empty")
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
