//
//  MainView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import XLPagerTabStrip

struct MainView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var selectedTab = 1
    @State private var swipeGestureEnabled: Bool = true
    
    var body: some View {
        

        PagerTabStripView()

    }

}

// MARK: - UIViewControllerRepresentable
struct PagerTabStripView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyPagerTabStripController {
        return MyPagerTabStripController()
    }
    
    func updateUIViewController(_ uiViewController: MyPagerTabStripController, context: Context) {
        // Update state dari SwiftUI ke UIKit jika perlu
    }
}

// MARK: - UIKit PagerTabStrip Controller
class MyPagerTabStripController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        // Style tab bar
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .label
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarBackgroundColor = .systemBackground
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // SwiftUI views sebagai child
        let child1 = HostingControllerWithTab(rootView: HomeView(pokemonUseCase: DependencyContainer.shared.pokemonUseCase), tabTitle: "Home")
        let child2 = HostingControllerWithTab(rootView: ProfileView(), tabTitle: "Profile")
        return [child1, child2]
    }
}


class HostingControllerWithTab<Content: View>: UIHostingController<Content>, IndicatorInfoProvider {
    private let tabTitle: String

    
    init(rootView: Content, tabTitle: String) {
        self.tabTitle = tabTitle
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}



#Preview {
    MainView()
}
