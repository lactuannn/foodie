import UIKit

enum TabBarType: String {
    case timeline
    case message
    case more
}

class MainTabBarController: UITabBarController {

    // MARK: - Varialbes

    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        // setup
        self.setupStartApp()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.view.alpha = 0.0
        // setup view
        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // animate when appear
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1.0
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Setup View
    private func setupView() {

    }

    func hideTabbar(hide: Bool?, animated: Bool = false) {
        self.tabBar.isHidden = hide ?? false
    }

    // MARK: - Actions

    // MARK: - Call Api

    // MARK: - Functions
    private func setupStartApp() {
        let startViewController = StartVC.getViewControllerFromStoryboard(Storyboard.Main.name)
        // set list childs controller to tabbar
        let controllers = [startViewController]
        self.viewControllers = controllers
        self.hideTabbar(hide: true)
    }

    func setupMainApp() {

        // Timeline
        let navigationHome = UIStoryboard(name: Storyboard.Home.name, bundle: nil).instantiateInitialViewController()!

        let naviRandom = UIStoryboard(name: Storyboard.Random.name, bundle: nil).instantiateInitialViewController()!
        
        let naviHis = UIStoryboard(name: Storyboard.History.name, bundle: nil).instantiateInitialViewController()!
        
        // set list childs controller to tabbar
        let controllers = [navigationHome,naviRandom,naviHis]
        self.viewControllers = controllers
        self.hideTabbar(hide: false)
    }
}
