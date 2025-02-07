//
//  testTab.swift
//  final_ring_sizer
//
//  Created by MANYA on 29/09/24.
//
import SwiftUI

struct TestTab: View {
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var showFingerSizer = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                RingSizerView(showSettings: $showSettings)
                    .tabItem {
                        Image(systemName: "checkmark.circle")
                        Text("Ring Sizer")
                    }
                    .tag(0)
                
                NavigationLink(destination: FingerSizerView(), isActive: $showFingerSizer) {
                    EmptyView()
                }
                    .tabItem {
                        Image(systemName: "hand.tap")
                        Text("Finger Sizer")
                    }
                    .tag(1)
                
                ConverterView()
                    .tabItem {
                        Image(systemName: "arrow.right.arrow.left")
                        Text("Converter")
                    }
                    .tag(2)
            }
            .accentColor(.black)
            /*.background(
                NavigationLink(destination: FingerSizerView(), isActive: $showFingerSizer) {
                    EmptyView()
                }
            )*/
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 1 {
                showFingerSizer = true
                selectedTab = 0  // Immediately switch back to Ring Sizer tab
            }
        }
    }
}



struct TestTab_Previews: PreviewProvider {
    static var previews: some View {
        TestTab()
    }
}
