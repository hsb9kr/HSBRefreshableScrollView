//
//  ContentView.swift
//  HSBRefreshableScrollViewDemo
//
//  Created by Sang bo Hong on 2021/06/11.
//

import SwiftUI

struct ContentView: View {
    @State var isRefresh: Bool = false
    var body: some View {
        NavigationView {
            RefreshableScrollView(isRefresh: $isRefresh) {
                LazyVStack {
                    ForEach(0..<100) { index in
                        Text("\(index)")
                    }
                }
            }
            .navigationTitle(Text("Demo"))
            .navigationBarItems(trailing: Button("done") {
                isRefresh = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
