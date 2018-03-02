import UIKit
import FBSDKLoginKit
import FirebaseAuth

private let facebookProfilePermission       = "public_profile"
private let facebookEmailPermission         = "email"
private let facebookUserFriendsPermission   = "user_friends"

class StartVC: BaseVC {

    // MARK: - IBOutlet

    // MARK: - Varialbes

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = FBSDKAccessToken.current() {
            
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func loginPressed(_ sender: UIButton){
        
        let facebookLoginManager = FBSDKLoginManager()
        
        facebookLoginManager.logOut()
        
        facebookLoginManager.logIn(withReadPermissions: [facebookProfilePermission, facebookEmailPermission, facebookUserFriendsPermission], from: self) { [weak self] (result, error) in
            
            guard let strongSelf = self , let _ = FBSDKAccessToken.current().tokenString else { return }
            if error != nil{
                print(error ?? "")
            }
            
            let accessToken = FBSDKAccessToken.current()
            
            guard let accessTokenString = accessToken?.tokenString else { return }
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            Auth.auth().signIn(with: credentials) { (user, error) in
                if error != nil{
                    
                    print(error ?? "")
                    return
                }
                strongSelf.checkApp()
            }
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if err != nil{
                    print(err!)
                    return
                }
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // check app
        //self.checkApp()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Setup View

    // MARK: - Actions

    // MARK: - Call Api

    // MARK: - Functions
    private func checkApp() {

        // User module (login, register, ...)

        // Main app
         self.perform(#selector(StartVC.gotoMainApp), with: nil, afterDelay: 1)
    }


    @objc func gotoMainApp() {
        self.mainTabBarViewController?.setupMainApp()
    }
}

