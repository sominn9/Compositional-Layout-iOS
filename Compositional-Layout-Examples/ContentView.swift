//
//  ContentView.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container()
            .edgesIgnoringSafeArea(.all)
            .preferredColorScheme(.dark)
    }
}

struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        // 리스트 뷰
//        UINavigationController(rootViewController: ListViewController())
        
        // 반응형 그리드 뷰
//        UINavigationController(rootViewController: ResponsiveGridViewController())
        
        // 로딩 그리드 뷰
//        UINavigationController(rootViewController: LazyGridViewController())
        
        // 크기 변경이 가능한 그리드 뷰
//        UINavigationController(rootViewController: ResizableGridViewController())
        
        // 배경을 가지고 있는 섹션
//        UINavigationController(rootViewController: BackgroundDecorationViewController())
        
        // 시스템 리스트 뷰
//        UINavigationController(rootViewController: SystemListHeaderViewController())
        
        // Sticky 헤더 뷰
//        UINavigationController(rootViewController: StickyHeaderViewController())
        
        // Carousel 레이아웃
//        UINavigationController(rootViewController: CarouselViewController())
    
        // Infinite Carousel 레이아웃
        UINavigationController(rootViewController: InfiniteCarouselViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
