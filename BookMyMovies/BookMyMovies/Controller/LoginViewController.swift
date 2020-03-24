//
//  LoginViewController.swift
//  book my show
//

import UIKit

class LoginViewController: UIViewController ,UITextFieldDelegate{
    var status : String = ""
    @IBOutlet weak var txtUsername: UITextField!
    var UserName: String = ""
    var Password: String = ""
    @IBOutlet weak var btnlogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtUsername.delegate = self
        setUI()
    }
    func setUI(){
        txtUsername.layer.cornerRadius = 15.0
        txtUsername.layer.borderWidth = 2.0
        txtUsername.layer.borderColor = UIColor.lightGray.cgColor

        txtPassword.layer.cornerRadius = 15.0
        txtPassword.layer.borderWidth = 2.0
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor

        txtUsername.leftViewMode = UITextField.ViewMode.always
        txtUsername.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
        let image = UIImage(named: "user.png")
        imageView.image = image
        txtUsername.leftView = imageView
        txtPassword.leftViewMode = UITextField.ViewMode.always
        txtPassword.leftViewMode = .always
        txtPassword.leftViewMode = UITextField.ViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
        let image1 = UIImage(named: "password-1.png")
        imageView1.image = image1
        txtPassword.leftView = imageView1
        btnlogin.layer.cornerRadius = 15.0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    @IBAction func btnLogin(_ sender: Any) {
        if(InternetCheck()){
            status =  Authentication(username: txtUsername.text as! String, password: txtPassword.text as! String)
        }
        else{
            DisplayNoInternetAlert(Msg: "Please check your internet connection")
        }
    }
    func InternetCheck() -> Bool {
        let hostname = "google.com"
        let hostinfo = gethostbyname2(hostname, AF_INET6)
            if hostinfo != nil {
                return true // internet available
            }
        return false
    }
    func DisplayNoInternetAlert1(Msg : Bool){
        DispatchQueue.main.async {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieList") as! ViewController
        self.present(vc, animated: true, completion: nil)
        }
    }
    func DisplayNoInternetAlert(Msg : String){
      DispatchQueue.main.async {
            let alertController = UIAlertController(title: "BookMyMovies", message: Msg, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)}
    }
    func Authentication( username : String, password : String) -> String{
        UserName = username
        Password = password
        var url = "http://api.themoviedb.org/3/authentication/token/new?api_key=a6f3c06992e5612755f1003897ee65a7"
        jsonParsingFromURL(url: url)
        guard let name = UserDefaults.standard.string(forKey: "Satus") else { return  "Nothing" }
            return name
        }
        //pasring funtion to parse
        func jsonParsingFromURL (url: String) {
            let url = NSURL(string: url)
            if(url != nil){
                let request = NSURLRequest(url: url! as URL)
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
                    self.startParsing(data: data! as NSData)
                }
        }
     }
    func startParsing(data :NSData)
    {
    //fetching all data
        let dict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        //fetching data which present in results
        let results = dict["success"]
        let requestToken = dict["request_token"]
        apicall(requestToken: requestToken as! String)
    }
    func apicall(requestToken: String){
        // Prepare URL
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=a6f3c06992e5612755f1003897ee65a7")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(UserName)&password=\(Password)&request_token=\(requestToken)"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            return
        }
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let dict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if( dict["status_message"] != nil){
                self.DisplayNoInternetAlert(Msg: dict["status_message"] as! String)
            }
            else{
                self.DisplayNoInternetAlert1(Msg: dict["success"]as! Bool)
            }
          }
        }
        task.resume()
    }
      
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
