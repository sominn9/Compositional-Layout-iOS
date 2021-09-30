//
//  ContentView.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
}

struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        UINavigationController(rootViewController: ListViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
